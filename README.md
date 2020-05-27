## x86:64 Assembly Language Quine
This is a [quine](https://en.wikipedia.org/wiki/Quine_%28computing%29) written in x86:64 assembly language for linux. Check out [this code golf link](https://codegolf.stackexchange.com/questions/577/assembly-language-quine) for other cool assembly language quines.

To build, you need:
- `binutils`
- `nasm`
- `python` (python 2 or 3, this is optional and only required if you want to "minify" quine.s)

### About this project
- This project doesn't link with any libraries
- Writing to stdout occurs via interrupt 0x80, syscall 4. [See here.](./quine.s#L26)
- This code does nothing to preserve registers or the stack, it was only made to be "good enough"

