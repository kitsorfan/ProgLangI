import sys


def check_path(doors, escapes, i, j, N, M):
    if (escapes[i][j]==3): return 3
    if (escapes[i][j]==1): return 1
    
    escapes[i][j]=3

    door = doors[i][j]

    # left door
    if (door=="L"):
        if (j==0): 
            escapes[i][j]=1
            return 1
        else:
            escapes[i][j]=check_path(doors, escapes, i, j-1,N,M)
            return escapes[i][j]

    # right door
    elif (door=="R"): 
        if (j==(M-1)):
            escapes[i][j]=1
            return 1
        else:
            escapes[i][j]=check_path(doors, escapes, i, j+1,N,M)
            return escapes[i][j]

    # up door
    elif (door=="U"): 
        if (i==0):
            escapes[i][j]=1
            return 1
        else:
            escapes[i][j]=check_path(doors, escapes, i-1, j,N,M)
            return escapes[i][j]
    # down door
    elif (door=="D"): 
        if (i==(N-1)):
            escapes[i][j]=1
            return 1
        else:
            escapes[i][j]=check_path(doors, escapes, i+1, j,N,M)
            return escapes[i][j]
    else: return 0 #useless


# Main
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
            if (maze_escapes[i][j]==0): color = check_path(maze_doors,maze_escapes,i,j,N,M)
            if (maze_escapes[i][j]==1): escapable_rooms+=1
    non_escapable_rooms=N*M-escapable_rooms
    print(non_escapable_rooms)