module heap
  use blocks

  use platform
  use, intrinsic :: iso_c_binding
  implicit none
    type::heap
      type(c_ptr) :: start = c_null_ptr
  end type heap
  contains
  subroutine split(ptr, i)
    type(block), pointer, intent(inout) :: ptr
    integer(c_size_t), intent(in) :: i
    integer(c_intptr_t) :: addr
    integer(c_intptr_t) :: new_addr_int
    type(c_ptr) :: new_addr
    type(block), pointer :: new_block
    type(c_ptr) :: osram
    type(c_ptr) :: old_next
    type(block), pointer :: new_block
    type(block), pointer :: next_block
    old_next = ptr%next!at some point u realise this shi is not worth it walah
    addr = transfer(c_loc(ptr), addr)
    new_addr_int = addr + c_sizeof(ptr) + i
    new_addr = transfer(new_addr_int, new_addr)
    call c_f_pointer(new_addr, new_block)
    new_block%size  = ptr%size - i - c_sizeof(ptr)
    new_block%state = .false._c_bool
    new_block%prev  = c_loc(ptr)
    new_block%next  = old_next
    ptr%next  = new_addr
    ptr%size  = i
    ptr%state = .true._c_bool
    if (c_associated(old_next)) then
      call c_f_pointer(old_next, next_block)
      next_block%prev = new_addr
    end if
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
    osram=gimme_ram(i)
    call c_f_pointer(osram, new_block)










    
    new_block%size  = i - c_sizeof(new_block)
    new_block%state = .false._c_bool
    new_block%next  = c_null_ptr
    new_block%prev  = c_null_ptr
  end function find
  function checkme(h) result(res)
    type(heap), intent(in) :: h
    integer :: res
    integer :: counter
    type(c_ptr) :: current_addr
    type(block), pointer :: current
    counter = 0
    current_addr = h%start
    do while (c_associated(current_addr))
      call c_f_pointer(current_addr, current)
      counter = counter + 1
      current_addr = current%next
    end do
    res = counter
  end function checkme

  function how_much_motion(h) result(res)
    type(heap), intent(in) :: h
    integer :: res
    integer :: counter
    type(c_ptr) :: current_addr
    type(block), pointer :: current
    counter = 0
    current_addr = h%start
    do while (c_associated(current_addr))
      call c_f_pointer(current_addr, current)
      if (current%state==FALSE)
      counter = counter + current%size
      current_addr = current%next
      else
        current_addr = current%next
      end if
    end do
    res = counter
  end function how_much_motion



end module heap