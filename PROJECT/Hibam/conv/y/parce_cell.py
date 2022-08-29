import sys
import re

def main():
    if (len(sys.argv) != 3):
        print("Wrong number of args")
        return 0

    FILE_NAME = sys.argv[1]
    ITER_COUNT = sys.argv[2]

    with open(FILE_NAME) as f:
        FILE = f.readlines()

    out=""
    final = False
    dp = 1
    replace = 0

    for line in FILE:
        if (line.__contains__("[") and line.__contains__("]")):
            res = re.findall(r'\[.*?\]', line)

            parce = res[0][1:-1]
            parce = parce.split(",")
            start = parce[0]
            end = parce[1]
            dp = len(str(end))
            step = parce[2]

            replace = int(start) + int(ITER_COUNT) * int(step)
            if (int(replace) == int(end)):
                final = True
            line = line.replace(res[0], str(replace))
        out += line

    path = 'input/' + FILE_NAME + "." + str(replace).zfill(dp)
    f = open(path, "w+")
    f.write(out)

    return final

final = main()
print(str(final))
