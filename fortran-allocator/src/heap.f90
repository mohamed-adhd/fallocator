module heapy
  use blocks

  use platform
  use, intrinsic :: iso_c_binding
  implicit none
    type::heap
      type(c_ptr) :: start = c_null_ptr
  end type heap
  contains

  character(len=20) function fmt_bytes(n) result(s)
    integer(c_size_t), intent(in) :: n
    real(8) :: mb
    if (n >= 1024_c_size_t*1024_c_size_t) then
      mb = real(n,8) / (1024.0_8*1024.0_8)
      write(s, '(F0.2,A)') mb, " Mb"
    else if (n >= 1024_c_size_t) then
      write(s, '(F0.2,A)') real(n,8)/1024.0_8, " Kb"
    else
      write(s, '(I0,A)') n, " B"
    end if
  end function fmt_bytes





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
    old_next = ptr%next
    addr = transfer(c_loc(ptr), addr)
    new_addr_int = addr + c_sizeof(ptr) + i
    new_addr = transfer(new_addr_int, new_addr)
    call c_f_pointer(new_addr, new_block)
    new_block%size = ptr%size - i - c_sizeof(ptr)
    new_block%state = .false._c_bool
    new_block%prev = c_loc(ptr)
    new_block%next = old_next
    ptr%next = new_addr
    ptr%size = i
    ptr%state = .true._c_bool
    if (c_associated(old_next)) then
      call c_f_pointer(old_next, next_block)
      next_block%prev = new_addr
    else
    end if
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
      if(current%size==i .and. (current%state .eqv. .false._c_bool))then
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

    new_block%size  = i
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
    counter = 0
    current_addr = h%start
    do while (c_associated(current_addr))
      call c_f_pointer(current_addr, current)
      counter = counter + 1
      current_addr = current%next
    end do
    res = counter
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


  subroutine free_dave(h)!kendrick reference 
    type(heap), intent(in) :: h
    type(c_ptr) :: current_addr
    type(block), pointer :: current

    current_addr = h%start

    do while (c_associated(current_addr))
      call c_f_pointer(current_addr, current)

      if (current%state .eqv. .true._c_bool) then
        current%state = .false._c_bool
      end if

      current_addr = current%next
    end do
  end subroutine free_dave









end module heapy