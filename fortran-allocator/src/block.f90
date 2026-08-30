module blocks
    use, intrinsic :: iso_c_binding
    implicit none
    type, bind(C) :: block
        integer(c_size_t) :: size
        logical(c_bool) :: state
        type(c_ptr) :: next
        type(c_ptr) :: prev
    end type block
end module blocks
!nvmd..integer::state!1 for occupied and 0 for free dave