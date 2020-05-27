all: diff
	@echo ""
	@echo "Use make help to see options"

build:
	@mkdir -p ./bin
	@nasm -f elf64 ./quine.min.s -o ./bin/quine.o
	@ld -emain -melf_x86_64 ./bin/quine.o -o ./bin/quine.out

run: build
	@./bin/quine.out

diff: build
# Run the original executable and output to "quine.out.s"
	@./bin/quine.out > ./bin/quine.out.s
	@diff ./quine.min.s ./bin/quine.out.s

# Rebuild "quine.out.s" to "quine.out.s.out"
	@nasm -f elf64 ./bin/quine.out.s -o ./bin/quine.out.s.o
	@ld -emain -melf_x86_64 ./bin/quine.out.s.o -o ./bin/quine.out.s.out

# Run the second executable and output to "quine.out.s.out.s"
	@./bin/quine.out.s.out > ./bin/quine.out.s.out.s
	@diff ./quine.min.s ./bin/quine.out.s.out.s

	@echo "Quine worked! Check files:"
	@echo "  ./bin/quine.out.s"
	@echo "  ./bin/quine.out.s.out.s"

dbin: build
	objdump -d ./bin/quine.out

delf: build
	readelf -a ./bin/quine.out

min:
	@python ./create_min.py

help:
	@echo "make diff   Equivalent to make all"
	@echo "make run    Runs the quine, output to stdout"
	@echo "make dbin   Objdump the quine binary (text)"
	@echo "make delf   Readelf the quine binary"
	@echo "make min    Re-generate quine.min.s from quine.s"