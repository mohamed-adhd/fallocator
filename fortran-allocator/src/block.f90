module blocks
    implicit none
    type::block
        integer::size
        !nvmd..integer::state!1 for occupied and 0 for free dave
        logical :: state
        type(block), pointer :: next => null()
        type(block), pointer :: prev => null()

    end type block
end module blocks