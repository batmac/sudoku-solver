
CC = gcc -Wall -O3

all : sudoku

sudoku : sudoku.c
	$(CC) sudoku.c -o sudoku

clean :
	-rm -f sudoku
