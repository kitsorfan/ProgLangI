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


int check_neighbour(int array[][1000], int i, int j, int N, int M, char door){
  int return_value=0;

  if (array[i][j]==0){
  switch(door) {
      case 'L': // Left Door
        if (j==0) return_value = 1;
        else{
            if (array[i][j-1]==1) return_value = 1;
        }
        break;


      case 'R': // Right Door
        if (j==(M-1)) return_value = 1;
        else{
            if (array[i][j+1]==1) return_value = 1;
        }
        break;

      case 'U': // Up Door
        if (i==0) return_value = 1;
        else{
            if (array[i-1][j]==1) return_value = 1;
        }
        break;

      case 'D': // Down Door
        if (i==(N-1)) return_value = 1;
        else{
            if (array[i+1][j]==1) return_value = 1;
        }
        break;
    }
    return return_value;
  }
  return 1;
}


int main(int argc, char** argv) { //arg = number of arguments, argv pointer array of pointers to arguments

// @@@@@@@@@@@@@@@@@@@@@@@@@@----- DECLARTATIONS -----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  int N,M;//number of rooms
  char maze_doors[1000][1000];
  int maze_escapes[1000][1000] = { { 0 } }; // initializing to 0
  int escapable_rooms = 0; // number of rooms which can lead to the exit


// @@@@@@@@@@2@@@@@@@@@@@@@@@----- READING DATA -----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  const char * file_name = argv[1];	//name of file to open
  ifstream File(file_name); 		//open the file
  File>>N>>M;
  for (int i=0; i<N; i++){  //reading all rooms
    for (int j=0; j<M; j++){
      File>>maze_doors[i][j];
    }
  }



  //---------- optional
  cout << "Our initial array:\n";
  for (int i=0; i<N; i++){  //reading all rooms
    for (int j=0; j<M; j++){
      cout<<maze_doors[i][j]<<" ";
    }
    cout<<"\n";
  }
  cout<<"\n";
  //--- optional end


// @@@@@@@@@@@@@@@@@@@@@@@@@@@@----- SCANS -----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// LEFT -> RIGHT
  //Scan from left to right (top->bottom)
  for (int i=0; i<N; i++){
    for (int j=0; j<M; j++){
      maze_escapes[i][j]=check_neighbour(maze_escapes, i, j, N, M, maze_doors[i][j]);
    }
  }

  //Scan from left to right (bottom->top)
  for (int i=(N-1); i>=0; i--){
    for (int j=0; j<M; j++){
      maze_escapes[i][j]=check_neighbour(maze_escapes, i, j, N, M, maze_doors[i][j]);
    }
  }

// --------------------------------------------------------------------------

// RIGHT -> LEFT
  //Scan from right to left (top-bottom)
  for (int i=0; i<N; i++){
    for (int j=(M-1); j>=0; j--){
      maze_escapes[i][j]=check_neighbour(maze_escapes, i, j, N, M, maze_doors[i][j]);
    }
  }

  //Scan from right to left (bottom->top)
  for (int i=(N-1); i>=0; i--){
    for (int j=(M-1); j>=0; j--){
      maze_escapes[i][j]=check_neighbour(maze_escapes, i, j, N, M, maze_doors[i][j]);
    }
  }

// --------------------------------------------------------------------------

// TOP->BOTTOM
  //Scan from top to bottom (left->right)
  for (int j=1; j<M; j++){
    for (int i=0; i<N; i++){
      maze_escapes[i][j]=check_neighbour(maze_escapes, i, j, N, M, maze_doors[i][j]);
    }
  }

  //Scan from top to bottom (right->left)
  for (int j=(M-1); j>=0; j--){
    for (int i=0; i<N; i++){
      maze_escapes[i][j]=check_neighbour(maze_escapes, i, j, N, M, maze_doors[i][j]);
    }
  }

// --------------------------------------------------------------------------

// BOTTOM->TOP
  //Scan from bottom to top (left->right)
  for (int j=0; j<M; j++){
    for (int i=(N-1); i>=0; i--){
      maze_escapes[i][j]=check_neighbour(maze_escapes, i, j, N, M, maze_doors[i][j]);
    }
  }

  //Scan from bottom to top (right->left)
  for (int j=(M-1); j>=0; j--){
    for (int i=(N-1); i>=0; i--){
      maze_escapes[i][j]=check_neighbour(maze_escapes, i, j, N, M, maze_doors[i][j]);
    }
  }

  // @@@@@@@@@@@@@@@@@@@@@@@@@@@@----- SCANS AGAIN-----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


  // LEFT -> RIGHT
    //Scan from left to right (top->bottom)
    for (int i=0; i<N; i++){
      for (int j=0; j<M; j++){
        maze_escapes[i][j]=check_neighbour(maze_escapes, i, j, N, M, maze_doors[i][j]);
      }
    }

    //Scan from left to right (bottom->top)
    for (int i=(N-1); i>=0; i--){
      for (int j=0; j<M; j++){
        maze_escapes[i][j]=check_neighbour(maze_escapes, i, j, N, M, maze_doors[i][j]);
      }
    }

  // --------------------------------------------------------------------------

  // RIGHT -> LEFT
    //Scan from right to left (top-bottom)
    for (int i=0; i<N; i++){
      for (int j=(M-1); j>=0; j--){
        maze_escapes[i][j]=check_neighbour(maze_escapes, i, j, N, M, maze_doors[i][j]);
      }
    }

    //Scan from right to left (bottom->top)
    for (int i=(N-1); i>=0; i--){
      for (int j=(M-1); j>=0; j--){
        maze_escapes[i][j]=check_neighbour(maze_escapes, i, j, N, M, maze_doors[i][j]);
      }
    }

  // --------------------------------------------------------------------------

  // TOP->BOTTOM
    //Scan from top to bottom (left->right)
    for (int j=1; j<M; j++){
      for (int i=0; i<N; i++){
        maze_escapes[i][j]=check_neighbour(maze_escapes, i, j, N, M, maze_doors[i][j]);
      }
    }

    //Scan from top to bottom (right->left)
    for (int j=(M-1); j>=0; j--){
      for (int i=0; i<N; i++){
        maze_escapes[i][j]=check_neighbour(maze_escapes, i, j, N, M, maze_doors[i][j]);
      }
    }

  // --------------------------------------------------------------------------

  // BOTTOM->TOP
    //Scan from bottom to top (left->right)
    for (int j=0; j<M; j++){
      for (int i=(N-1); i>=0; i--){
        maze_escapes[i][j]=check_neighbour(maze_escapes, i, j, N, M, maze_doors[i][j]);
      }
    }

    //Scan from bottom to top (right->left)
    for (int j=(M-1); j>=0; j--){
      for (int i=(N-1); i>=0; i--){
        maze_escapes[i][j]=check_neighbour(maze_escapes, i, j, N, M, maze_doors[i][j]);
      }
    }








  //---------- optional
  cout << "What we get:\n";
  for (int i=0; i<N; i++){  //reading all rooms
    for (int j=0; j<M; j++){
      cout<<maze_escapes[i][j]<<" ";
      escapable_rooms+=maze_escapes[i][j];
    }
    cout<<"\n";
  }

  // @@@@@@@@@@@@@@@@@@@@@@@@----- PRINTING OUTPUT -----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  cout<<"Escapable Rooms: "<<escapable_rooms<<"\n";
  //--- optional end

  return 0;
}
