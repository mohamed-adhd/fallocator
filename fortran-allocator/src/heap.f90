module heap
  use blocks
  use, intrinsic :: iso_c_binding
  implicit none
    type::heap
      type(c_ptr) :: start = c_null_ptr
  end type heap
  contains
  
end module heap