module heap
  implicit none
    type::heap
      type(block), pointer :: start => null()
  end type heap
end module heap