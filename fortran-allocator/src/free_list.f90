module freelist
    use blocks
    implicit none
    type :: freelist
        type(block), pointer :: head => null()
    end type free_list
end module freelist