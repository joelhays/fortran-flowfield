program main
  use, intrinsic :: iso_c_binding, only: c_null_char
  use :: raylib
  use :: flowfield_params
  use :: flowfield_simulation

  implicit none(type, external)

  integer, parameter :: SCREEN_WIDTH = 800*2, SCREEN_HEIGHT = 450*2
  type(color_type), dimension(7), parameter :: COLORS = &
                                               [RED, PINK, MAROON, PURPLE, &
                                                VIOLET, DARKPURPLE, MAGENTA]

  logical :: display_trail_enabled, display_grid_enabled
  display_trail_enabled = .true.
  display_grid_enabled = .false.

  call init_param_presets()
  call reset()

  call init_window(SCREEN_WIDTH, SCREEN_HEIGHT, 'Flow Fields'//c_null_char)
  call set_target_fps(60)

  do while (.not. window_should_close())
    ! 'R' resets simulation with new random parameters
    if (is_key_pressed(KEY_R)) then
      selected_preset = 0
      call reset()
    end if

    ! 'P' resets simulation and cycles through preset parameters
    if (is_key_pressed(KEY_P)) then
      selected_preset = max(mod(selected_preset + 1, size(presets) + 1), 1)
      call reset()
    end if

    ! 'D' toggles display state between trails and particles
    if (is_key_pressed(KEY_D)) then
      display_trail_enabled = .not. display_trail_enabled
    end if

    ! 'G' toggles grid on or off
    if (is_key_pressed(KEY_G)) then
      display_grid_enabled = .not. display_grid_enabled
    end if

    call update_simulation()

    call begin_drawing()
    block
      call clear_background(BLACK)
      call display_grid()
      call display_particles()
      call draw_text("P - cycle presets", 0, 30, 20, WHITE)
      call draw_text("R - random parameters", 0, 60, 20, WHITE)
      call draw_text("D - toggle trail/particle display", 0, 90, 20, WHITE)
      call draw_fps(0, 0)

    end block
    call end_drawing()
  end do

  call close_window()

contains

  subroutine reset()
    implicit none

    print *, 'selected preset', selected_preset
    if (selected_preset == 0) then
      call randomize_params(SCREEN_WIDTH, SCREEN_HEIGHT)
    else
      params = presets(selected_preset)
    end if

    call init_simulation(SCREEN_WIDTH, SCREEN_HEIGHT)
  end subroutine

  subroutine display_particles()
    implicit none
    type(particle_type) :: p
    integer :: i, j
    type(color_type) :: selected_color

    do i = 1, size(particles)
      p = particles(i)
      selected_color = COLORS(mod(i, size(COLORS)) + 1)

      if (display_trail_enabled) then
        do j = 2, p%numhistory
          call draw_line(floor(p%history(j - 1, 1)), floor(p%history(j - 1, 2)), &
                         floor(p%history(j, 1)), floor(p%history(j, 2)), selected_color)
        end do
      else
        call draw_circle(floor(p%pos(1)), floor(p%pos(2)), max(params%cell_size/10.0, 1.0), selected_color)
      end if
    end do
  end subroutine

  subroutine display_grid()
    implicit none
    integer :: i

    if (.not. display_grid_enabled) then
      return
    end if

    do i = 1, params%cols
      call draw_line(i*params%cell_size, 0, i*params%cell_size, SCREEN_HEIGHT, DARKGRAY)
    end do
    do i = 1, params%rows
      call draw_line(0, i*params%cell_size, SCREEN_WIDTH, i*params%cell_size, DARKGRAY)
    end do
  end subroutine

end program main

