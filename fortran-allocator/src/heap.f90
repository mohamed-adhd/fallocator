module heap
  use blocks
  use, intrinsic :: iso_c_binding
  implicit none
    type::heap
      type(c_ptr) :: start = c_null_ptr
  end type heap
  contains
  subroutine split(ptr, i)
    integer(c_intptr_t) :: addr
    integer(c_intptr_t) :: new_addr_int
    type(block), pointer, intent(inout) :: ptr
    integer(c_size_t), intent(in) :: i
    type(c_ptr) :: ptr_addr
    type(c_ptr) :: new_addr
    type(c_ptr) :: old_next
    type(block), pointer :: new_block
    old_next = ptr%next
    ptr_addr = c_loc(ptr)
    addr = transfer(c_loc(ptr), addr)
    new_addr_int = addr + c_sizeof(ptr) + i
    new_addr = transfer(new_addr_int, new_addr)
    call c_f_pointer(new_addr, new_block)
    new_block%size  = ptr%size - i - c_sizeof(ptr)
    new_block%state = .false._c_bool
    new_block%prev  = c_loc(ptr)
    new_block%next  = old_next

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