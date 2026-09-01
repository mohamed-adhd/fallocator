module heapy
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
    type(block), pointer :: next_block
    print *, "SPLIT: entered"
    old_next = ptr%next
    print *, "SPLIT: got old_next"
    addr = transfer(c_loc(ptr), addr)
    print *, "SPLIT: got current address"
    new_addr_int = addr + c_sizeof(ptr) + i
    print *, "SPLIT: calculated new address"
    new_addr = transfer(new_addr_int, new_addr)
    print *, "SPLIT: converted address to c_ptr"
    call c_f_pointer(new_addr, new_block)
    print *, "SPLIT: c_f_pointer done"
    new_block%size = ptr%size - i - c_sizeof(ptr)
    print *, "SPLIT: set new_block size"
    new_block%state = .false._c_bool
    print *, "SPLIT: set new_block state"
    new_block%prev = c_loc(ptr)
    print *, "SPLIT: set new_block prev"
    new_block%next = old_next
    print *, "SPLIT: set new_block next"
    ptr%next = new_addr
    print *, "SPLIT: updated ptr next"
    ptr%size = i
    print *, "SPLIT: updated ptr size"
    ptr%state = .true._c_bool
    print *, "SPLIT: updated ptr state"
    if (c_associated(old_next)) then
      print *, "SPLIT: old_next is associated"
      call c_f_pointer(old_next, next_block)
      print *, "SPLIT: next_block c_f_pointer done"
      next_block%prev = new_addr
      print *, "SPLIT: updated next_block prev"
    else
      print *, "SPLIT: old_next is null"
    end if
    print *, "SPLIT: finished"
  end subroutine split
  function findy(i,h) result(ptr)
    type(block), pointer :: new_block
    type(c_ptr) :: osram
    integer(c_size_t) :: header_size =c_sizeof(new_block)
    character(len=*), parameter :: rd = "reached before do loop    : "
    character(len=*), parameter :: rd1 = "reached after do loop    : "
    character(len=*), parameter :: rd2 = "reached before allocating new block do loop    : "
    character(len=*), parameter :: rd3 = "reached end of findy     : "


    type(c_ptr) :: current_addr
    logical::done
    type(block), pointer :: current
    type(heap), intent(inout) :: h
    integer(c_size_t), intent(in) :: i
    type(c_ptr) :: ptr
    ptr = c_null_ptr
    current_addr = h%start
    print*,rd

    do while (c_associated(current_addr))
      call c_f_pointer(current_addr, current)
      if(current%size==i .and. current%state .eqv. .false._c_bool)then
        current%state=.true._c_bool! false for free and true for busy
        ptr = current_addr
        return
      else if (current%size >= i .and. .not. current%state) then
        ptr = current_addr
        call split(current, i)
        return
      end if
      current_addr = current%next
    end do
    print*,rd1

    osram=gimme_ram(i + header_size)
    call c_f_pointer(osram, new_block)

    current_addr = h%start
    do while (c_associated(current_addr))
      call c_f_pointer(current_addr, current)
      if (.not. c_associated(current%next)) exit
      current_addr = current%next
    end do

    print*,rd2

    new_block%size  = i - c_sizeof(new_block)
    new_block%state = .true._c_bool
    new_block%next  = c_null_ptr
    new_block%prev  = current_addr
    if (c_associated(current_addr)) then
      current%next = osram
    else
      h%start = osram
    end if
    ptr = osram
    print*,rd3

  end function findy
  function checkme(h) result(res)
    type(heap), intent(in) :: h
    integer :: res
    integer :: counter
    type(c_ptr) :: current_addr
    type(block), pointer :: current
    print *, "CHECKME: entered"
    counter = 0
    print *, "CHECKME: counter initialized"
    current_addr = h%start
    print *, "CHECKME: got h%start"
    do while (c_associated(current_addr))
      print *, "CHECKME: current_addr is associated"
      call c_f_pointer(current_addr, current)
      print *, "CHECKME: c_f_pointer done"
      counter = counter + 1
      print *, "CHECKME: counter =", counter
      current_addr = current%next
      print *, "CHECKME: moved to next block"
    end do
    print *, "CHECKME: exited loop"
    res = counter
    print *, "CHECKME: result =", res
    return
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
      if (current%state .eqv. .false._c_bool) then
      counter = counter + current%size
      current_addr = current%next
      else
        current_addr = current%next
      end if
    end do
    res = counter
    return
  end function how_much_motion












  

end module heapy