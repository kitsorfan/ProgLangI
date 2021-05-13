import sys



def check_next(door, escapes,i,j,N,M):
    #left door
    if (door=="L"):
        if (j==0): return 1
        else: return escapes[i][j-1]
    #right door
    elif (door=="R"):
        if (j==(M-1)): return 1
        else: return escapes[i][j+1]
    #right door
    elif (door=="U"):
        if (i==0): return 1
        else: return escapes[i-1][j]
    #down door
    else:
        if (i==(N-1)): return 1
        else: return escapes[i+1][j]

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
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@")
    print("  Paint={}, Start=[{}][{}], End=[{}][{}]".format(paint,i,j,end_i,end_j),end=" | ")


    while((i!=end_i) and(j!=end_j)):
        
        print("[{}][{}]".format(i,j), end=" -> ")

        door = doors[i][j]
        (i,j)=next_indexes(i,j,door)
        escapes[i][j]=paint
        
    print()
    
def check_path(doors, escapes, i, j, N, M):
    while True:
        door = doors[i][j]
        
        print("I am door[{}][{}]={} and I am {}".format(i,j,door,escapes[i][j]))
        
        if (escapes[i][j]!=1): escapes[i][j]=2
        next_door = check_next(door,escapes,i,j,N,M)
        
        print("My next is:",next_door)
        
        (i,j)=next_indexes(i,j,door)
        if (next_door!=0): break #emulate do-while
        

    return (i,j,next_door) #(end_i, end_j, paint)
  
    

        

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
            if (maze_escapes[i][j]==0): 
                (end_i, end_j, paint)=check_path(maze_doors,maze_escapes,i,j,N,M)
                paint_path(maze_doors, maze_escapes,paint,i,j,end_i,end_j)
            if (maze_escapes[i][j]==1): escapable_rooms+=1
    for record in maze_escapes:
        print(record)
    non_escapable_rooms=N*M-escapable_rooms
    print(non_escapable_rooms)