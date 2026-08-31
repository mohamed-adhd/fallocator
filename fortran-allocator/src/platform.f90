module platform
    use, intrinsic :: iso_c_binding
    implicit none

    integer(c_size_t), parameter :: ARENA_SIZE = 100_c_size_t * 1024_c_size_t * 1024_c_size_t  ! 100 MB
    integer(c_int8_t), target, save :: arena(ARENA_SIZE)
    integer(c_size_t), save :: bump_offset = 0_c_size_t
contains
    function gimme_ram(size) result(ptr)
        integer(c_size_t), intent(in) :: size
        type(c_ptr) :: ptr
        integer(c_intptr_t) :: base_addr
        if (bump_offset + size > ARENA_SIZE) then
            ptr = c_null_ptr
            return
        end if
        base_addr = transfer(c_loc(arena(bump_offset + 1_c_size_t)), base_addr)
        ptr = transfer(base_addr, ptr)
        bump_offset = bump_offset + size
    end function gimme_ram
end module platform