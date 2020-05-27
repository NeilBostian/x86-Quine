import re

if '__main__' == __name__:
    re_comment = re.compile(r"^(.*);.*$")
    re_newline = re.compile(r"^(.*)\n$")
    re_whitespace = re.compile(r"^\s*$")

    def process_line(line):
        m = re_comment.match(line)
        if m:
            line = m.groups(1)[0]

        m = re_newline.match(line)
        if m:
            line = m.groups(1)[0]

        line = line.rstrip()

        if re_whitespace.match(line):
            return None
        else: return line

    with open('./quine.s', 'r') as fin:
        all_lines = [y for y in [process_line(x) for x in fin] if y is not None]

    with open('./quine.min.s', 'w') as fout:
        for line in all_lines:
            fout.write(line + '\n')

        first_line = True
        for line in all_lines:
            if first_line:
                fout.write("      ")
                first_line = False
            else:
                fout.write("    , ")

            line = line.replace("\"", "\", 0x22, \"")
            fout.write("\"" + line + "\", 0x0A \\\n")

        fout.write("    , 0x00\n")
