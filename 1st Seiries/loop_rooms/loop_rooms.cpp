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


/* -----------------------MAIN IDEA---------------------------------------------

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


int main(int argc, char** argv) { //arg = number of arguments, argv pointer array of pointers to arguments



}
