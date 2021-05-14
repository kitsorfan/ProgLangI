
"""
********************************************************************************
  Project     : Programming Languages 1 - Assignment 2 - Exercise LoopRooms
  Authors     : Stylianos Kandylakis el17088, 
                Kitsos Orfanopoulos el17025
  -----------
 ProgLangI 2021, ECE-NTUA
 *******************************************************************************

>> TRANSLATING OUR C++ SOLUTION:
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

# @@@@@@@@@@@@@@@@@@@@@--- Functions for first DFS ---@@@@@@@@@@@@@@@@@@@@@@@@@@@

def check_next(door, escapes,i,j,N,M):
    """
    Function that takes:
        door: a char (L,R,U,D)
        escapes: a double array of escapability (0, 1, 2)
        i,j: the indexes of current room
        N,M: the dimensions of the arrays

    The function returns the indexes of the next room and its paint, if such room exists,
    or the indexes of current room and paint=1 if that room leads to an exit 
    """
    #Left door
    if (door=="L"):
        if (j==0): return (i,j,1)
        else: return (i,(j-1),escapes[i][j-1])
    #Right door
    elif (door=="R"):
        if (j==(M-1)): return (i,j,1)
        else: return (i,(j+1),escapes[i][j+1])
    #Up door
    elif (door=="U"):
        if (i==0): return (i,j,1)
        else: return ((i-1),j,escapes[i-1][j])
    #Down door
    else:
        if (i==(N-1)): return (i,j,1)
        else: return ((i+1),j,escapes[i+1][j])


    
def check_path(doors, escapes, i, j, N, M):
    """
    Function that takes:
        doors: a double array of rooms (L,R,U,D)
        escapes: a double array of escapability (0, 1, 2)
        i,j: the initial indexes to start the DFS from
        N,M: the dimensions of the arrays

    The function returns the indexes of the final room of the path, and its paint.
    """
    while True: #emulate do-while (if with break)
        door = doors[i][j]                                  # read the door of the room (L, R, U or D)
        if (escapes[i][j]!=1): escapes[i][j]=2              # if current room is not escapable then is visited
        (i,j,next_room) = check_next(door,escapes,i,j,N,M)  # check the next room (if it a direct exit, or it is escapable/visited). Return indexes of the next, and its paint.
        if (next_room!=0): break                            # if next room is unvisited then continue, else we have found our last room for the current path
        

    return (i,j,next_room) # Return final room of the path (end indexes and paint)
  


# @@@@@@@@@@@@@@@@@@@@@--- Functions for second DFS ---@@@@@@@@@@@@@@@@@@@@@@@@@@@

def next_indexes(i,j,door):
    """
    Function that takes:
        door: a char (L,R,U,D)
        i,j: the indexes of current room
    and  returns the indexes of the next room
    
    A simpler version of  check_next function:
    Note that we could just use the check_next function, but we do not have to 
    check if we will go "off-limits" of the array (we know that the path exists), 
    nor we have to return the paint. Thus no need to parse N x M dimensions here.
    """
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
    """
    Function that takes:
        doors: a double array of rooms (L,R,U,D)
        escapes: a double array of escapability (0, 1, 2)
        i,j: the initial indexes to start the DFS from
        end_i,end_j: the indexes to finish the path
        
    Note that we don't need the dimensions of the the array, because we now that the path 
    will not go "off-limits", since we already cross it.

    The function paints 
    """
    escapes[i][j]=paint     # paint first room of the path

    while((i!=end_i) or(j!=end_j)):     # while we have not reached final room of the path
        door = doors[i][j]              # find current door (L,R,U,D)
        (i,j)=next_indexes(i,j,door)    # find next indexes
        escapes[i][j]=paint             # paint next room

        

# @@@@@@@@@@@@@@@@@@@@@@@@@@@--- MAIN ---@@@@@@@@@@@@@@@@@@@@@@@@@@@

if __name__ == "__main__":
    # *********  Reading Data *********
    with open(sys.argv[1], "rt") as inputFile:                      # open the file, argument[1] from terminal is each name
        N, M = map(int, inputFile.readline().split())               # N x M the dimensions of the maze

        maze_doors = [[0 for j in range(M)] for i in range(N)]      # create a double array for the maze (input values)
        maze_escapes = [[0 for j in range(M)] for i in range(N)]    # create a double array for the escapability (initial value 0=unknown)

        for i in range(N):
            maze_doors[i]= tuple(inputFile.readline())              # read input 

    # *********  DFS scanning *********
    escapable_rooms=0   # counter

    for i in range(N):
        for j in range(M):
            if (maze_escapes[i][j]==0):                                             # if the room is unvisited 
                (end_i, end_j, paint) = check_path(maze_doors,maze_escapes,i,j,N,M) # then start a DFS (note the returning tuple: we get the final room[end_i,end_j] and the paint)
                paint_path(maze_doors, maze_escapes,paint,i,j,end_i,end_j)          # then follow again the path to paint it
            if (maze_escapes[i][j]==1): escapable_rooms+=1                          # increase the counter if it is escapable

    non_escapable_rooms = N*M-escapable_rooms 
    print(non_escapable_rooms)