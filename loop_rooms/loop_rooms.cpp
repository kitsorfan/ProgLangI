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

We create a N x M dynamic array, called maze_doors. Each cell is marked with UDRL (up, down, right, left).
We read the given file (from arguments) and fill that maze..

Then we create a N x M dynamic array, called maze_escapes, with initial values '0' to each cell.

We run a DFS to find escapable rooms. If we find a visited one then the whole
path is "else", else is "good".
We use an auilary recursive function that follows the path of every cell.
We check whether the next room is already "visited", "bad" or "good".
We mark "visited" rooms with 2, "bad" with 3, "good" with 1.
Bad or visited are actually the same (see version of ML or Python).
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
    //----------- left door -------------
      case 'L':
        if (j==0)  {
          escapes[i][j] = 1;
          return 1;
        }
        else{
            escapes[i][j] = check_path(doors, escapes, i, j-1, N, M);
            return escapes[i][j];
        }
        break;

    //----------- right door -------------
      case 'R':
        if (j==(M-1)) {
          escapes[i][j] = 1;
          return 1;
        }
        else{
            escapes[i][j] = check_path(doors, escapes, i, j+1, N, M);
            return escapes[i][j];
        }
        break;

      //----------- up door -------------
      case 'U':
        if (i==0){
          escapes[i][j] = 1;
          return 1;
        }
        else{
            escapes[i][j] = check_path(doors, escapes, i-1, j, N, M);
            return escapes[i][j];
        }
        break;

      //----------- down door -------------
      case 'D':
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
    return 0; //useless, to avoid warnings
}




int main(int argc, char** argv) { //arg = number of arguments, argv pointer array of pointers to arguments

// @@@@@@@@@@@@@@@@@@@@@@@@@@----- DECLARTATIONS -----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  int N,M;//number of rooms
  char **maze_doors;
  int **maze_escapes; // initializing to 0
  int escapable_rooms = 0; // number of rooms which can lead to the exit
  int non_escapable_rooms = 0;


// @@@@@@@@@@2@@@@@@@@@@@@@@@----- READING DATA -----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  const char * file_name = argv[1];	//name of file to open
  ifstream File(file_name); 		//open the file
  File>>N>>M;

  //creating dynamic arrays
  maze_doors = new char *[N];
  maze_escapes = new int *[N];

  for (int i=0; i<N; i++){
    maze_doors[i] = new char [M]; //initial array
    maze_escapes[i] = new int [M];//array describing escapability of each doors 
  }

  for (int i=0; i<N; i++){  //reading all rooms
    for (int j=0; j<M; j++){
      File>>maze_doors[i][j];
      maze_escapes[i][j]=0; //initializing to 0, means door has unknown escapability
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
  non_escapable_rooms=N*M-escapable_rooms;
  cout<<non_escapable_rooms<<"\n";

  return 0;
}
