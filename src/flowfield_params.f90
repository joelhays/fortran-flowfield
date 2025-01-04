module flowfield_params
  implicit none

  private
  public :: randomize_params, init_param_presets
  public :: params, presets, selected_preset

  type :: params_type
    integer :: cell_size, rows, cols
    real :: curve, zoom
    integer :: equation
  end type params_type
  type(params_type) :: params

  type(params_type), dimension(:), allocatable :: presets
  integer :: selected_preset

contains

  subroutine randomize_params(width, height)
    implicit none
    integer, intent(in) :: width, height
    real :: r

    call random_number(r)
    params%cell_size = r*(40 - 5) + 5
    params%rows = height/params%cell_size
    params%cols = width/params%cell_size
    call random_number(r)
    params%curve = r*(20) + 0.01
    call random_number(r)
    params%zoom = r*(10) + 0.01
    call random_number(r)
    params%equation = floor(r*(5 - 1) + 1)

    print *, 'using params:'
    print *, ' params%cell_size=', params%cell_size
    print *, ' params%rows=', params%rows
    print *, ' params%cols=', params%cols
    print *, ' params%curve=', params%curve
    print *, ' params%zoom=', params%zoom
    print *, ' params%equation=', params%equation
  end subroutine

  subroutine init_param_presets()
    implicit none
    real :: r

    allocate (presets(20))

    call random_number(r)
    selected_preset = max(floor(r*size(presets)), 1)

    presets(1)%cell_size = 7
    presets(1)%rows = 128
    presets(1)%cols = 228
    presets(1)%curve = 10.185
    presets(1)%zoom = 6.286
    presets(1)%equation = 1

    presets(2)%cell_size = 11
    presets(2)%rows = 81
    presets(2)%cols = 145
    presets(2)%curve = 2.448
    presets(2)%zoom = 6.237
    presets(2)%equation = 1

    presets(3)%cell_size = 25
    presets(3)%rows = 36
    presets(3)%cols = 64
    presets(3)%curve = 7.90291405
    presets(3)%zoom = 0.159332886
    presets(3)%equation = 1

    presets(4)%cell_size = 32
    presets(4)%rows = 28
    presets(4)%cols = 50
    presets(4)%curve = 2.46052337
    presets(4)%zoom = 0.253975511
    presets(4)%equation = 2

    presets(5)%cell_size = 34
    presets(5)%rows = 26
    presets(5)%cols = 47
    presets(5)%curve = 1.13627625
    presets(5)%zoom = 9.70062733
    presets(5)%equation = 2

    presets(6)%cell_size = 29
    presets(6)%rows = 31
    presets(6)%cols = 55
    presets(6)%curve = 13.3630667
    presets(6)%zoom = 6.26238489
    presets(6)%equation = 2

    presets(7)%cell_size = 29
    presets(7)%rows = 31
    presets(7)%cols = 55
    presets(7)%curve = 10.8637285
    presets(7)%zoom = 8.63945198
    presets(7)%equation = 1

    presets(8)%cell_size = 26
    presets(8)%rows = 34
    presets(8)%cols = 61
    presets(8)%curve = 7.48895979
    presets(8)%zoom = 7.71726444E-02
    presets(8)%equation = 1

    presets(9)%cell_size = 12
    presets(9)%rows = 75
    presets(9)%cols = 133
    presets(9)%curve = 4.96248817
    presets(9)%zoom = 6.06476212
    presets(9)%equation = 2

    presets(10)%cell_size = 19
    presets(10)%rows = 47
    presets(10)%cols = 84
    presets(10)%curve = 13.9642878
    presets(10)%zoom = 6.33166838
    presets(10)%equation = 2

    presets(11)%cell_size = 8
    presets(11)%rows = 112
    presets(11)%cols = 200
    presets(11)%curve = 9.93366316E-02
    presets(11)%zoom = 6.53512552E-02
    presets(11)%equation = 4

    presets(12)%cell_size = 10
    presets(12)%rows = 90
    presets(12)%cols = 160
    presets(12)%curve = 14.7534103
    presets(12)%zoom = 6.45308590
    presets(12)%equation = 1

    presets(13)%cell_size = 17
    presets(13)%rows = 52
    presets(13)%cols = 94
    presets(13)%curve = 1.000
    presets(13)%zoom = 6.091
    presets(13)%equation = 2

    presets(14)%cell_size = 10
    presets(14)%rows = 90
    presets(14)%cols = 160
    presets(14)%curve = 0.706
    presets(14)%zoom = 0.246
    presets(14)%equation = 1

    presets(15)%cell_size = 34
    presets(15)%rows = 26
    presets(15)%cols = 47
    presets(15)%curve = 1.743
    presets(15)%zoom = 7.876
    presets(15)%equation = 2

    presets(16)%cell_size = 7
    presets(16)%rows = 128
    presets(16)%cols = 228
    presets(16)%curve = 19.195
    presets(16)%zoom = 7.042
    presets(16)%equation = 3

    presets(17)%cell_size = 31
    presets(17)%rows = 29
    presets(17)%cols = 51
    presets(17)%curve = 18.307
    presets(17)%zoom = 6.219
    presets(17)%equation = 2

    presets(18)%cell_size = 15
    presets(18)%rows = 60
    presets(18)%cols = 106
    presets(18)%curve = 10.784
    presets(18)%zoom = 6.506
    presets(18)%equation = 1

    presets(19)%cell_size = 33
    presets(19)%rows = 27
    presets(19)%cols = 48
    presets(19)%curve = 1.131
    presets(19)%zoom = 3.495
    presets(19)%equation = 2

    presets(20)%cell_size = 8
    presets(20)%rows = 112
    presets(20)%cols = 200
    presets(20)%curve = 0.464114666
    presets(20)%zoom = 5.87129784
    presets(20)%equation = 4

  end subroutine

end module
