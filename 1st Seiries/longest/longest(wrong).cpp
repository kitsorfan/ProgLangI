//  ECE NTUA
//  ProglangI
//  2021
//  Stulianos Kandylakis el17088
//  Kitsos Orfanopoulos el17025

#include <iostream>
#include <vector>
#include <algorithm>
#include <fstream>
#include <climits>


using namespace std;


/* ----------------------- MAIN IDEA -------------------------------------------

--------------------------------------------------------------------------------
*/
void  Kadane_recursive(int *discharges, int hospitals, int &max_length, int current_index,  int current_length, int local_max){
  cout<<"current_index | current_length | local_max | discharges[current_index] | max_length\n";
  cout<<(current_index+1)<<" | "<<current_length<<" | "<<local_max<<" | "<<discharges[current_index]<<" | "<<max_length<<"\n";
  //local_max = max(discharges[current_index],(local_max+discharges[current_index]));
  if ((discharges[current_index])>(discharges[current_index]+local_max)){
    local_max=discharges[current_index];
    current_length=1;
  }
  else {
    local_max+=discharges[current_index];
    current_length++;
    //cout<<"     I am the "<<(current_index+1)<<"st, aka "<<discharges[current_index]<<" and now the length is "<<current_length<<"\n";
  }
  if (local_max/(hospitals*current_length)>=1){
    if (current_length>max_length) { 
      max_length=current_length;
      //cout<<(current_index+1)<<" : "<<(discharges[current_index])<<" is part of the max_length\n";
      }
  }
  cout<<(current_index+1)<<" | "<<current_length<<" | "<<local_max<<" | "<<discharges[current_index]<<" | "<<max_length<<"\n";
  cout<<"------------------------\n";

  if (current_index!=0) Kadane_recursive(discharges, hospitals, max_length, (current_index-1), current_length, local_max);

}


int main(int argc, char** argv) { //arg = number of arguments, argv pointer array of pointers to arguments

// @@@@@@@@@@@@@@@@@@@@@@@@@@----- DECLARTATIONS -----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  int days,hospitals;//number of days and hospitals
  int *discharges; //array to store discharges of each day
  
  int max_good_days = 0; // number of good days
  int temp = 0;


// @@@@@@@@@@2@@@@@@@@@@@@@@@----- READING DATA -----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  const char * file_name = argv[1];	//name of file to open
  ifstream File(file_name); 		//open the file
  File>>days>>hospitals;

  //creating dynamic arrays
  discharges = new int[days];

  for (int j=0; j<days; j++){
    File>>temp;
    discharges[j]=-temp; //we add the absolute value (to calculate positive sums after)
  }


  // @@@@@@@@@@2@@@@@@@@@@@@@@@----- SCANNING -----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


  // @@@@@@@@@@@@@@@@@@@@@@@@----- PRINTING OUTPUT -----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  Kadane_recursive(discharges, hospitals, max_good_days, (days-1) , 0,(discharges[days-1]));
  cout<<max_good_days<<"\n";

  return 0;
}
