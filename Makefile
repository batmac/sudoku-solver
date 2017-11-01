
CFLAGS = -Wall -O3

all : sudoku

sudoku : sudoku.c
	$(CC) $(CFLAGS) sudoku.c -o sudoku

clean :
	-rm -f sudoku
