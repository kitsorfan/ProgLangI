//  ECE NTUA
//  ProglangI
//  2021
//  Stulianos Kandylakis el17088
//  Kitsos Orfanopoulos el17025

#include <iostream>
#include <vector>
#include <algorithm>
#include <fstream>


using namespace std;


/* ----------------------- MAIN IDEA -------------------------------------------

We create a N x M array, called maze_doors. Each cell is marked with UDRL (up, down, right, left).
We read the given file (from arguments) and fill that maze..

Then we create a N x M array, called maze_escapes, with initial values '0' on each cell.
We will scan 4 times:
top->bottom
bottom->top
left->right
right->left

On each scan we check if each cell points to a "good" neighbour, who can escape.
A "good" neighbour is marked with '1' in the maze_escapes array.
If so, we mark this cell with 1, else with '2', and we continue the scan.

As we said before, we will scan the maze 4 times, 1 in every direction.
Ofcourse, we  must specially handle the first and last rows and columns.

At the end, we will scan the maze one more time to count the '2's.
That will be our final response.


Note: Possibly it is true that '0'==='2'; we will check out later.

--------------------------------------------------------------------------------
*/


int check_path(char ** doors, int **escapes, int i, int j, int N, int M){
  if ((escapes[i][j]==2) || (escapes[i][j]==3)) { // bad path (cycle)
    escapes[i][j]=3;
    return 3;
  }
  if (escapes[i][j]==1) { // good path
    return 1;
  }

  escapes[i][j] = 2; //we have visited this room

  char door = doors[i][j];
  switch(door) {
      case 'L': // Left Door
        if (j==0)  {
          escapes[i][j] = 1;
          return 1;
        }
        else{
            escapes[i][j] = check_path(doors, escapes, i, j-1, N, M);
            return escapes[i][j];
        }
        break;

      case 'R': // Right Door
        if (j==(M-1)) {
          escapes[i][j] = 1;
          return 1;
        }
        else{
            escapes[i][j] = check_path(doors, escapes, i, j+1, N, M);
            return escapes[i][j];
        }
        break;

      case 'U': // Up Door
        if (i==0){
          escapes[i][j] = 1;
          return 1;
        }
        else{
            escapes[i][j] = check_path(doors, escapes, i-1, j, N, M);
            return escapes[i][j];
        }
        break;

      case 'D': // Down Door
        if (i==(N-1)){
          escapes[i][j] = 1;
          return 1;
        }
        else{
            escapes[i][j] = check_path(doors, escapes, i+1, j, N, M);
            return escapes[i][j];
        }
        break;
    }
    return 0;
}




int main(int argc, char** argv) { //arg = number of arguments, argv pointer array of pointers to arguments

// @@@@@@@@@@@@@@@@@@@@@@@@@@----- DECLARTATIONS -----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  int N,M;//number of rooms
  char **maze_doors;
  int **maze_escapes; // initializing to 0
  int escapable_rooms = 0; // number of rooms which can lead to the exit


// @@@@@@@@@@2@@@@@@@@@@@@@@@----- READING DATA -----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  const char * file_name = argv[1];	//name of file to open
  ifstream File(file_name); 		//open the file
  File>>N>>M;

  //creating dynamic arrays
  maze_doors = new char *[N];
  maze_escapes = new int *[N];

  for (int i=0; i<N; i++){
    maze_doors[i] = new char [M];
    maze_escapes[i] = new int [M];
  }

  for (int i=0; i<N; i++){  //reading all rooms
    for (int j=0; j<M; j++){
      File>>maze_doors[i][j];
      maze_escapes[i][j]=0;
    }
  }


  // @@@@@@@@@@2@@@@@@@@@@@@@@@----- SCANNING -----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

for (int i=0;i<N;i++){
  for (int j=0;j<M;j++){
    if (maze_escapes[i][j]==0){
      int color = check_path(maze_doors, maze_escapes, i, j, N, M); //the color (1 or 3) to "paint" the path
      maze_escapes[i][j]=color; //useless, but we avoid warning
    }
    if (maze_escapes[i][j]==1) escapable_rooms++;
  }
}

  // @@@@@@@@@@@@@@@@@@@@@@@@----- PRINTING OUTPUT -----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  cout<<escapable_rooms<<"\n";
  //--- optional end

  return 0;
}
