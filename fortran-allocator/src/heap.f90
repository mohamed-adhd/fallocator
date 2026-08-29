module heap
  implicit none
  use blocks
    type::heap
      type(block), pointer :: start => null()
  end type heap
  contains
    function func(i) result(ptr)
      type(block), pointer :: temp => start
      do while (temp%next/=null)
      temp=temp%next
      end do
    end function

end module heap