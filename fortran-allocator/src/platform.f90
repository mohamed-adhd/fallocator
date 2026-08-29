program platform
    use, intrinsic :: iso_c_binding
    implicit none
    interface
        function gimme_ram(size) bind(C, name="gimme_ram") result(ptr)
            import :: c_size_t, c_ptr
            integer(c_size_t), value :: size
            type(c_ptr) :: ptr
        end function gimme_ram
    end interface
end program platform