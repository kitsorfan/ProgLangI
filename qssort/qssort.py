from collections import deque
import sys
import os
import psutil

# 🔵Read the input (easy)
# 🔵Sort the data (easy)
# 🔵Create nodes (queue, stack, pointerQ, pointerS) (medium)
# 🔵Add nodes creating graph till find the desirable One (check if node already exists in the graph) (hard x2)
# 🔵Find minimum path to that node (medium)


if __name__ == "__main__":
    with open(sys.argv[1], "rt") as inputFile:
        N = int(inputFile.readline())
        for i in range(N):
            #print(process.memory_info())

            father = {}
            rna = inputFile.readline()[:-1]
            qrna = deque(rna)
            (father, final) = bfsSolve(N, qrna)
            #print(father)
            #print(final)
            path = find_path(father, "," + ''.join(final))
            print(path[::-1])