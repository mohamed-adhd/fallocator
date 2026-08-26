module heap
  implicit none
  use blocks
    type::heap
      type(block), pointer :: start => null()
  end type heap
end module heap