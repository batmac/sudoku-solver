#CC = /Volumes/ct-ng/x-tools/armv8-rpi3-linux-gnueabihf/bin/armv8-rpi3-linux-gnueabihf-gcc
CFLAGS = -Wall -O3 -march=native

all: sudoku

sudoku: sudoku.c
	$(CC) $(CFLAGS) $^ -o $@

sudoku-dbg: sudoku.c
	$(CC) $(CFLAGS) -g $^ -o $@

# afl-fuzz -i EXAMPLES/ -o afl ./sudoku-afl @@
# afl-fuzz -i - -o afl ./sudoku-afl @@
sudoku-afl: sudoku.c
	afl-$(CC) $(CFLAGS) $^ -o $@

gcc:
	$(MAKE) CC=gcc

clang:
	$(MAKE) CC=clang

test: sudoku.c
	./test/test.sh

lint: sudoku.c
	cppcheck --error-exitcode=1 --enable=all $^

clean:
	-$(RM) -rf sudoku sudoku-*

.PHONY: all clean test lint gcc clang
