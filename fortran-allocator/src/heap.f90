module heap
  use blocks
  use, intrinsic :: iso_c_binding
  implicit none
    type::heap
      type(c_ptr) :: start = c_null_ptr
  end type heap
  contains
  subroutine swap

  end subroutine swap
  function find(i,h) result(ptr)
    type(c_ptr) :: current_addr
    type(block), pointer :: current
    type(heap), intent(inout) :: h
    integer(c_size_t), intent(in) :: i
    type(c_ptr) :: ptr
    ptr = c_null_ptr
    current_addr = h%start
    do while (c_associated(current_addr))
      call c_f_pointer(current_addr, current)


      current_addr = current%next

    end do
  end function find
end module heap