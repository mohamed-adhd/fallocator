program shi
    use blocks
    use platform
    use heap
    implicit none
    type(heap)::hippie

    character(len=*), parameter :: status = "stats   : "
    character(len=*), parameter :: wtf = "nigga why are u as an individual allocating more than 100 mb?"
    character(len=*), parameter :: conf = "we dont have the ressources twinn ☹ , can we allocate : "
    character(len=*), parameter :: fm = "free memory = 2465 Mb"
    character(len=*), parameter :: tb = "total blocks = 5"
    character(len=*), parameter :: allocate= "(enter how much mb you want to allocate,type -1 for exit) : "
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

            ]!cooking straight poison , aint no way a human being ever thought of this idea ever , like , no words twin walah
    integer :: i

    do while (ios/=-1)
        call execute_command_line('clear')
        do i = 1, 10
            print *,banner(i)
        end do
        print *,status
        print *,fm
        print *,tb
        print *,allocate
        do
            read(*,*, iostat=ios) how_much_for_a_banana
            if (ios == 0) then
                !time to fuck some shit up!!!!
                if (.not. checkme)
                    if(ios>100)
                        print *,wtf
                    else
                        find(ios,hippie)

                    end if
                end if
            else
                write(*,*) 'dawg just enter a valid number...'
            end if
        end do
    end do




end program shi