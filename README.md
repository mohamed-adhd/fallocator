<div align="center">

# fallocator

**A custom heap allocator written in Fortran, backed by a hand-written x86-64 NASM `mmap` syscall wrapper — first-fit allocation with block splitting, driven from an interactive terminal menu.**

![Fortran](https://img.shields.io/badge/Fortran-2008-734F96?style=flat-square)
![NASM](https://img.shields.io/badge/NASM-x86--64-D64541?style=flat-square)
![Linux](https://img.shields.io/badge/Linux-mmap%20syscall-FCC624?style=flat-square&logo=linux&logoColor=black)
![C Interop](https://img.shields.io/badge/iso__c__binding-C%20Interop-8F6BFF?style=flat-square)
![Allocator](https://img.shields.io/badge/Strategy-First--Fit%20%2B%20Split-5B4CFF?style=flat-square)

</div>

<h2 align="center">Overview</h2>

`fallocator` is a heap allocator built from scratch in Fortran, using `iso_c_binding` to bind directly to a hand-written x86-64 assembly routine that pulls raw memory straight from the kernel via the `mmap` syscall — no libc `malloc` involved anywhere in the chain.

On top of that raw memory, a linked list of C-interop `block` structs (size, state, `next`/`prev` pointers) is maintained manually, with a first-fit search-and-split strategy for satisfying allocation requests. The whole thing is driven from an interactive CLI menu that prints live stats (block count, free memory) and lets you allocate chunks by size or free everything back.

<h2 align="center">Core Workflow</h2>

```
program shi (allocator.f90)
      |
      v
loop: clear screen, print banner + stats, show menu
      |
      +--- choice 1: allocate ---> read size in MB (capped at 100MB)
      |                                  |
      |                                  v
      |                          findy(size, heap)
      |                                  |
      |                    walk block linked list (heap%start -> ...)
      |                                  |
      |            +--- exact-size free block found -> mark busy, return
      |            |
      |            +--- larger free block found -> split() it, return front half
      |            |
      |            +--- no fit found -> gimme_ram(size + header)
      |                                  |
      |                                  v
      |                    platform.f90: gimme_ram -> asm_gimme_ram (C interop)
      |                                  |
      |                                  v
      |                    main.s: asm_gimme_ram -> mmap syscall -> raw pages
      |                                  |
      |                                  v
      |                    new block appended to end of linked list
      |
      +--- choice 2: free ---> free_dave(heap): walk list, mark every block free
      |
      v
loop back to menu
```

<h2 align="center">What It Does</h2>

| Area | Details |
|---|---|
| Raw memory sourcing | `main.s` implements `asm_gimme_ram`, a NASM routine that calls the `mmap` syscall (`rax=9`) directly to request pages from the kernel. |
| C interop bridge | `platform.f90` declares a `bind(C, name="asm_gimme_ram")` interface and exposes a thin `gimme_ram` wrapper Fortran code calls. |
| Block representation | `block.f90` defines a `bind(C)` derived type — `size`, `state` (busy/free), `next`, `prev` — laid out as a linked list directly inside the allocated arena. |
| First-fit search | `findy` in `heap.f90` walks the block list looking for an exact-size free block first, then any large-enough free block to split. |
| Block splitting | `split` carves a larger free block into an allocated front portion and a new free remainder block, relinking `next`/`prev` pointers. |
| Growing the heap | When no existing block fits, `findy` calls `gimme_ram` for a fresh block-sized region and appends it to the end of the list. |
| Stats reporting | `checkme` counts total blocks; `how_much_motion` sums the size of all free blocks; `fmt_bytes` formats sizes as B/Kb/Mb for display. |
| Freeing | `free_dave` walks the entire list and marks every block free — see limitations below. |
| Interactive shell | `allocator.f90` (`program shi`) prints an ASCII banner + live stats every loop, and reads a menu choice (allocate / free) from stdin. |

<h2 align="center">Code Map</h2>

| File | Role |
|---|---|
| `allocator.f90` | Entry point (`program shi`) — the interactive menu loop, banner, and input handling. |
| `heap.f90` (module `heapy`) | Core allocator logic: `findy` (first-fit search), `split`, `checkme`, `how_much_motion`, `free_dave`, `fmt_bytes`. |
| `block.f90` (module `blocks`) | Defines the `block` derived type — the linked-list node layout shared between Fortran and the raw memory. |
| `platform.f90` (module `platform`) | C-interop bridge: declares the `asm_gimme_ram` interface and wraps it as `gimme_ram`. |
| `main.s` | NASM implementation of `asm_gimme_ram` — issues the `mmap` syscall to get memory straight from Linux. |

<h2 align="center">Build & Run</h2>

Built with `gfortran` + `gcc` via the included Makefile — Fortran sources are compiled and linked together with the assembled `main.s` object:

```bash
make
```

Run it:

```bash
./allocator
```

Clean build artifacts:

```bash
make clean
```

<h2 align="center">Tech Stack</h2>

| Tech | Usage |
|---|---|
| Fortran (gfortran) | Allocator logic, block/heap data structures, interactive CLI |
| NASM / x86-64 assembly | Raw `mmap` syscall wrapper for sourcing memory from the OS |
| `iso_c_binding` | C-interoperable derived types (`bind(C)`) and interfaces linking Fortran to the asm routine |
| Linux syscalls | `mmap` (syscall 9) called directly, no libc `malloc` |

<h2 align="center">Current Limitations</h2>

- **`free_dave` frees everything, not one block.** The "free" menu option walks the entire list and marks *every* block free — there's no free-by-address or free-by-index, so you can't release a single allocation without releasing all of them.
- **No coalescing.** Adjacent free blocks are never merged back together after a free, so the heap can fragment into many small free blocks over time.
- **No minimum split size.** `split` doesn't check whether the leftover remainder is large enough to be useful, so it's possible to end up with tiny, effectively unusable free blocks.
- **Linear search.** `findy` walks the full block list on every allocation — there's no separate free-list, so lookup cost grows with heap size.
- **Single global heap, not thread-safe.**

<h2 align="center">Planned Improvements</h2>

- Selective free (free a specific block by address/index instead of clearing the whole heap).
- Block coalescing on free to reduce fragmentation.
- Minimum split threshold to avoid unusable splinter blocks.
- A dedicated free-list to avoid scanning busy blocks during allocation.

<h2 align="center">Why I Built This</h2>

nah , this is the wildest one yet , i m pretty sure nobody even managed to form a thought ressembling this idea , an allocator is already something out of regular , and fortran wasnt helping either , i m not sure how this evene worked , and the worst part ? assembly somehow got involved in this ! , but yea it was either asseembly or use on of fortran's allocator and cheat my way 

<h2 align="center">Developer Notes</h2>
- as always , not a production elevel allocator 
- you wouldnt pay me a million to touch fortran again, neither this repo
- the allocator is not capabel of joinging free blocks  , it can only use free whole blocks
- allocator cannot free specific blocks , the free option nukes the full list with keeping the blocks intact 
- hours spent  : not really sure of this one 

