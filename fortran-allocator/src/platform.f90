module platform
    use, intrinsic :: iso_c_binding
    implicit none
    interface
        function asm_gimme_ram(size) bind(C, name="asm_gimme_ram") result(ptr)
            import :: c_size_t, c_ptr
            integer(c_size_t), value :: size
            type(c_ptr) :: ptr
        end function
    end interface
contains
    function gimme_ram(size) result(ptr)
        integer(c_size_t), intent(in) :: size
        type(c_ptr) :: ptr
        ptr = asm_gimme_ram(size)
    end function
end module platform