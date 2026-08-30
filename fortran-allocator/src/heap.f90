module heap
  implicit none
  use blocks
    type::heap
      type(block), pointer :: start => null()
  end type heap
  contains
  function swap (ptr,i) result (ptr)
    type(block), pointer :: part1 => null()
    type(block), pointer :: part2 => null()
    part1%size=i
    part1%state=FALSE
    part1%prev=>ptr%prev
  end function
    function func(i) result(ptr)
      logical :: done
      type(heap), intent(inout) :: h
      integer, intent(in) :: i
      type(block), pointer :: ptr
      emp => h%start
      do while (associated(temp%next))
        if(temp%size==i) then
          temp%state=False
        else if (temp%size>i) then
          call swap(temp,i)

        end if
      temp=>temp%next
      end do

    end function


end module heap