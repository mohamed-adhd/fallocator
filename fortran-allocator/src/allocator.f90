program shi
    use blocks
    use platform
    use heapy
    implicit none
    type(heap)::hippie
    INTEGER(KIND=4) :: number
    integer(c_size_t) :: number2
    type(c_ptr) :: result_ptr
    CHARACTER(LEN=11) :: str






    integer :: choice
    CHARACTER(LEN=30) :: str2
    character(len=*), parameter :: status = "stats   : "
    character(len=*), parameter :: rd = "reached starting findy   : "
    character(len=*), parameter :: wtf = "nigga why are u as an individual allocating more than 100 mb?"
    character(len=*), parameter :: conf = "we dont have the ressources twinn ☹ , can we allocate : "
    character(len=*), parameter :: fm = "free memory = "
    character(len=*), parameter :: tb = "total blocks = "
    character(len=*), parameter :: allocate= "(enter how much mb you want to allocate,type -1 for exit) : "
    character(len=*), parameter :: ch1= "1->allocate"
    character(len=*), parameter :: ch2= "2->free blocks"

    integer(c_size_t) :: how_much_for_a_banana
    integer(c_size_t) :: how_much_for_a_bananas
    integer :: ios=1
    integer :: ioss=1
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
        number=checkme(hippie)
        number2=how_much_motion(hippie)
        WRITE(str, '(I0)') number
        str2 = fmt_bytes(int(number2, c_size_t))
        call execute_command_line('clear')
        do i = 1,10
            print *,banner(i)
        end do
        print *,status
        print *,fm//str2
        print *,tb//str
        print *,allocate

        do while (ios /= -1)

            number = checkme(hippie)
            number2 = how_much_motion(hippie)

            write(str, '(I0)') number
            str2 = fmt_bytes(int(number2, c_size_t))

            call execute_command_line('clear')

            do i = 1, 10
                print *, banner(i)
            end do

            print *, status
            print *, fm//str2
            print *, tb//str

            print *, ch1
            print *, ch2

            read(*,*,iostat=ios) choice

            if (ios == -1) exit

            if (ios /= 0) then
                print *, 'dawg just enter a valid number...'
                cycle
            end if

            if (choice == 1) then

                print *, allocate
                read(*,*,iostat=ios) how_much_for_a_banana

                if (ios == -1) exit

                if (ios /= 0) then
                    print *, 'dawg just enter a valid number...'
                    cycle
                end if

                if (how_much_for_a_banana > 100) then
                    print *, wtf
                else
                    result_ptr = findy(how_much_for_a_banana * 1024_c_size_t * 1024_c_size_t, hippie)
                end if

            else if (choice == 2) then

                call free_dave(hippie)

            else

                print *, 'u gotta be kidding me'

            end if

        end do
    end do




end program shi