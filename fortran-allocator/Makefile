CC = gcc
FC = gfortran
CFLAGS = -c
FFLAGS = 
TARGET = allocator
ASM_SRC = main.s
F90_SRC = block.f90 platform.f90 heap.f90 allocator.f90
ASM_OBJ = main.o
F90_OBJ = $(F90_SRC:.f90=.o)
OBJS = $(ASM_OBJ) $(F90_OBJ)

all: $(TARGET)
$(TARGET): $(OBJS)
	$(FC) $(F90_SRC) $(ASM_OBJ) -o $(TARGET)

$(ASM_OBJ): $(ASM_SRC)
	$(CC) $(CFLAGS) $< -o $@

%.o: %.f90
	$(FC) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all clean