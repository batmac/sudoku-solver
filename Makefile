
CFLAGS = -Wall -O3

all: sudoku

sudoku: sudoku.c
	$(CC) $(CFLAGS) $^ -o $@

gcc:
	$(MAKE) CC=gcc

clang:
	$(MAKE) CC=clang

test: sudoku
	./test/test.sh

lint: sudoku.c
	cppcheck --error-exitcode=1 --enable=all $^

clean:
	-rm -f sudoku

.PHONY: all clean test lint gcc clang
