module heap
  use blocks
  use, intrinsic :: iso_c_binding
  implicit none
    type::heap
      type(c_ptr) :: start = c_null_ptr
  end type heap
  contains
  subroutine split

  end subroutine split
  function find(i,h) result(ptr)
    type(c_ptr) :: current_addr
    logical::done
    type(block), pointer :: current
    type(heap), intent(inout) :: h
    integer(c_size_t), intent(in) :: i
    type(c_ptr) :: ptr
    ptr = c_null_ptr
    current_addr = h%start
    do while (c_associated(current_addr))
      call c_f_pointer(current_addr, current)
      if(current%size==i .and. current%state==FALSE)then
        current%state=TRUE! false for free and true for busy
        ptr = current_addr
        return
      else if (current%size>=i) then
        ptr = current_addr
        call split(current, i)
        return
      end if
      current_addr = current%next
    end do
  end function find
end module heap