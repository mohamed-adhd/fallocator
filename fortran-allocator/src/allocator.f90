program shi
    implicit none
    character(len=*), parameter :: status = "stats   : "
    character(len=*), parameter :: fm = "free memory = 2465 Mb"
    character(len=*), parameter :: tb = "total blocks = 5"
    character(len=*), parameter :: allocate= "(enter how much mb you want to allocate) : "
    integer:: how_much_for_a_banana
    integer :: ios
    character(len=142), parameter :: banner(10) = [ character(len=142) :: &
            '                                    _______    ___       __       __        ______     ______     ___   .___________.  ______   .______      ', &
                    '                                    |   ____|  /   \     |  |     |  |      /  __  \   /      |   /   \  |           | /  __  \  |   _  \     ', &
                    '                                    |  |__    /  ^  \    |  |     |  |     |  |  |  | |  ,----"  /  ^  \ `---|  |----`|  |  |  | |  |_)  |    ', &
                    '                                    |   __|  /  /_\  \   |  |     |  |     |  |  |  | |  |      /  /_\  \    |  |     |  |  |  | |      /     ', &
                    '                                    |  |    /  _____  \  |  `----.|  `----.|  `--"  | |  `----./  _____  \   |  |     |  `--"  | |  |\  \----.', &
                    '                                    |__|   /__/     \__\ |_______||_______| \______/   \______/__/     \__\  |__|      \______/  | _| `._____|',  &
                    '                                                                                                                                              ', &
                    '                                                                                by mohamed-adhd :D                                            ', &
                    '                                                                                                                                              ', &
                    '                                                                                                                                              ' &

            ]
    integer :: i
    call execute_command_line('clear')
    do i = 1, 10
        print *,banner(i)
    end do
    print *,status
    print *,fm
    print *,tb
    print *,allocate
    do





end program shi