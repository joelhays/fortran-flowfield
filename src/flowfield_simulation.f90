module flowfield_simulation
  use :: flowfield_params

  implicit none

  private
  public :: init_simulation, update_simulation
  public :: particle_type, particles, flowfield

  type :: particle_type
    real, dimension(2) :: pos, vel
    real, dimension(:, :), allocatable :: history
    integer :: numhistory, maxhistory, timer
    real :: angle, speed_modifier
  end type particle_type
  type(particle_type), dimension(:), allocatable :: particles

  real, dimension(:, :), allocatable :: flowfield

  integer, parameter :: MAX_PARTICLES = 2000, MIN_HISTORY = 10, MAX_HISTORY = 50

  integer :: screen_width, screen_height

contains

  subroutine init_simulation(width, height)
    implicit none
    integer, intent(in) :: width, height
    real :: r
    integer :: i, j, maxhistory

    screen_width = width
    screen_height = height

    if (allocated(particles)) then
      deallocate (particles)
    end if
    allocate (particles(MAX_PARTICLES))
    do i = 1, size(particles)
      call random_number(r)
      particles(i)%pos(1) = r*screen_width

      call random_number(r)
      particles(i)%pos(2) = r*screen_height

      call random_number(r)
      particles(i)%speed_modifier = r*5 + 1

      call random_number(r)
      maxhistory = r*(MAX_HISTORY - MIN_HISTORY) + MIN_HISTORY
      particles(i)%maxhistory = maxhistory
      allocate (particles(i)%history(maxhistory, 2))

      particles(i)%history(1, :) = particles(i)%pos
      particles(i)%numhistory = 1

      particles(i)%timer = particles(i)%maxhistory*2
    end do

    if (allocated(flowfield)) then
      deallocate (flowfield)
    end if
    allocate (flowfield(params%cols, params%rows))
    do concurrent(i=1:params%cols)
      do concurrent(j=1:params%rows)
        if (params%equation == 1) then
          flowfield(i, j) = (cos(real(i)*params%zoom) + sin(real(j)*params%zoom))*params%curve
        else if (params%equation == 2) then
          flowfield(i, j) = (cos(real(i)*params%zoom)*sin(real(j)*params%zoom))*params%curve
        else if (params%equation == 3) then
          flowfield(i, j) = (cos(real(i) + params%zoom) + sin(real(j) + params%zoom)) + params%curve
        else if (params%equation == 4) then
          flowfield(i, j) = (cos(real(i)*params%zoom)/sin(real(j)*params%zoom))*params%curve
        else if (params%equation == 5) then
          block
            real :: scale, zoom, curve, x, y, x1, y1, si, sj
            real :: a, b, c, d

            scale = 0.005
            zoom = params%zoom
            curve = params%curve/2
            si = real(i)*real(params%cell_size)
            sj = real(j)*real(params%cell_size)

            a = params%r(1)*4 - 2
            b = params%r(2)*4 - 2
            c = params%r(3)*4 - 2
            d = params%r(4)*4 - 2

            x = (si - width/2)*scale
            y = (sj - height/2)*scale
            x1 = (sin(a*y*zoom) + c*cos(a*x*zoom))*curve
            y1 = (sin(b*x*zoom) + d*cos(b*x*zoom))*curve
            flowfield(i, j) = atan2(y1 - y, x1 - x)
          end block
        end if
      end do
    end do
  end subroutine

  subroutine update_simulation()
    implicit none
    type(particle_type) :: p
    integer :: i
    integer, dimension(2) :: screenpos
    real :: r

    do i = 1, size(particles)
      p = particles(i)

      p%timer = p%timer - 1

      if (p%timer >= 1) then
        screenpos = ceiling(p%pos/[params%cell_size, params%cell_size + 1])
        if (screenpos(1) >= 1 .and. screenpos(2) >= 1 &
            .and. screenpos(1) <= params%cols .and. screenpos(2) <= params%rows) then
          ! only update particle angle if it's within the flow field bounds/render area
          p%angle = flowfield(screenpos(1), screenpos(2))
        end if
        p%vel = [cos(p%angle), sin(p%angle)]
        p%pos = p%pos + p%vel*p%speed_modifier

        if (p%numhistory < p%maxhistory) then
          p%numhistory = p%numhistory + 1
          p%history(p%numhistory, :) = p%pos
        else
          p%history = eoshift(p%history, 1, p%pos)
        end if
      else if (p%numhistory > 1) then
        p%history = eoshift(p%history, 1, p%pos)
        p%numhistory = p%numhistory - 1
      else
        call random_number(r)
        p%pos(1) = r*screen_width
        call random_number(r)
        p%pos(2) = r*screen_height

        p%history(1, :) = p%pos
        p%numhistory = 1

        p%timer = size(p%history)*2
      end if

      particles(i) = p
    end do
  end subroutine

end module
