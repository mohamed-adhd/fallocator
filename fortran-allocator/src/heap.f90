module heap
  implicit none
  use blocks
    type::heap
      type(block), pointer :: start => null()
  end type heap
  contains
    function func(i) result(ptr)
      type(heap), intent(inout) :: h
      integer, intent(in) :: i
      type(block), pointer :: ptr
      emp => h%start
      do while (associated(temp%next))
        if
      temp=>temp%next
      end do

    end function
  function swap (ptr,i) result (ptr)
    type(block), pointer :: part1 => null()
    type(block), pointer :: part2 => null()

  end function

end module heap