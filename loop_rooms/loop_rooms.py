
"""
********************************************************************************
  Project     : Programming Languages 1 - Assignment 2 - Exercise LoopRooms
  Authors     : Stylianos Kandylakis el17088, 
                Kitsos Orfanopoulos el17025
  -----------
 ProgLangI 2021, ECE-NTUA
 *******************************************************************************

>> TRANSLATING THE C++ PROBLEM:
---------------------------------
    At first we tried to "translate" our C++ code (*) to Python. That worked
    pretty much well for small testcases. Though for larger ones we exceeded
    the maximum recursion depth. Even with increasing the recursion limit 
    (sys.setrecursionlimit(5000)) the problem could not be solved, possibly
    due to memory problems. Python is not as fast as C++ and its performance 
    for recursion is very poor.

    (*): Our C++ solution was a RECURSIVE DFS at a double array. We follow
        the path of every door; if we found an exit the path was "good", else
        if we found an already visited room the path was "bad". 

>> ITERATIVE ADAPTATION:
----------------------------
    Our recursive DFS should be written in an iterative way. The Idea is to
    follow the path (do a DFS) until you find the last room, the door of which 
    leads to an exit/visited room (that will be the "paint"). Then we follow 
    again the same path from initial room to the last room, "painting" each 
    room with the same "paint". 
    "Paint" is the escapability of each room, 
        0 is unknown (initial value), 
        1 is escapable, 
        2 is visited=non escapable. 
    So in every step we follow twice each path. 
    At the end we scan our array to count escapable rooms.

>> STEPS:
----------------------------
    1. Read input and create arrays.
    2. Start following paths (DFS) from every unvisited room.
    3. Every time you finish one path, follow it again to "paint" it.
    4. Count escapable rooms and print them.
"""


import sys #for reading input from terminal


def check_next(door, escapes,i,j,N,M):
    #left door
    if (door=="L"):
        if (j==0): return (i,j,1)
        else: return (i,(j-1),escapes[i][j-1])
    #right door
    elif (door=="R"):
        if (j==(M-1)): return (i,j,1)
        else: return (i,(j+1),escapes[i][j+1])
    #right door
    elif (door=="U"):
        if (i==0): return (i,j,1)
        else: return ((i-1),j,escapes[i-1][j])
    #down door
    else:
        if (i==(N-1)): return (i,j,1)
        else: return ((i+1),j,escapes[i+1][j])

def next_indexes(i,j,door):
    #left door
    if (door=="L"):
        i,j=i,(j-1)
        #right door
    elif (door=="R"):
        i,j=i,(j+1)
        #up door
    elif (door=="U"):
        i,j=(i-1),j
        #down door
    else: i,j=(i+1),j
    return (i,j)
    



def paint_path(doors,escapes,paint,i,j,end_i,end_j):
    escapes[i][j]=paint
    # print("@@@@@@@@@@@@@@@@@@@@@@@@@@")
    # print("  Paint={}, Start=[{}][{}], End=[{}][{}]".format(paint,i,j,end_i,end_j),end=" | ")


    while((i!=end_i) or(j!=end_j)):
        
        # print("[{}][{}]".format(i,j), end=" -> ")

        door = doors[i][j]
        (i,j)=next_indexes(i,j,door)
        escapes[i][j]=paint
        
    # print()
    
def check_path(doors, escapes, i, j, N, M):
    while True:
        door = doors[i][j]
        
        # print("I am door[{}][{}]={} and I am {}".format(i,j,door,escapes[i][j]))
        
        if (escapes[i][j]!=1): escapes[i][j]=2
        (i,j,next_door) = check_next(door,escapes,i,j,N,M)
        
        # print("My next is:",next_door,"[{}][{}]".format(i,j))
      
        if (next_door!=0): break #emulate do-while
        

    return (i,j,next_door) #(end_i, end_j, paint)
  
    

        

# @@@@@@@@@@@@@@@@@@@@@@@@@@@--- MAIN ---@@@@@@@@@@@@@@@@@@@@@@@@@@@

if __name__ == "__main__":
    # Reading Data
    with open(sys.argv[1], "rt") as inputFile: # open the file, name as 
        N, M = map(int, inputFile.readline().split())
        maze_doors = [[0 for j in range(M)] for i in range(N)]
        maze_escapes = [[0 for j in range(M)] for i in range(N)]

        for i in range(N):
            maze_doors[i]= tuple(inputFile.readline())

    # Scanning
    escapable_rooms=0
    for i in range(N):
        for j in range(M):
            if (maze_escapes[i][j]==0): 
                (end_i, end_j, paint)=check_path(maze_doors,maze_escapes,i,j,N,M)
                paint_path(maze_doors, maze_escapes,paint,i,j,end_i,end_j)
            if (maze_escapes[i][j]==1): escapable_rooms+=1
    #for record in maze_escapes:
        # print(record)
    non_escapable_rooms=N*M-escapable_rooms
    print(non_escapable_rooms)