
CFLAGS = -Wall -O3

all: sudoku

sudoku: sudoku.c
	$(CC) $(CFLAGS) $^ -o $@

test: sudoku
	./test/test.sh

clean:
	-rm -f sudoku

.PHONY: all clean test
