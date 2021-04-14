//auxilary code from: https://www.geeksforgeeks.org/longest-subarray-having-average-greater-than-or-equal-to-x/?fbclid=IwAR1Prq2UCG54AYjv8w-P6kHwulyoQO3E4kgbCCwq8Ipq3NY7GZAPKbIRlw0

#include <iostream>
#include <climits>
#include <algorithm>

using namespace std;


int main(){
int N , M ;

cin >> M >> N ;                   // M = max days , N = #hospitals

int beds_sum;

int bedsperday[M];

for(int i=0; i<M; i++){ cin>> bedsperday[i]; }

// algorithm
int min_ending_here = INT_MAX;

  // to store the minimum value encountered so far
  int min_so_far = INT_MAX;

  // traverse the array elements
  for (int i=0; i<M; i++)
  {
      // if min_ending_here > 0, then it could not possibly
      // contribute to the minimum sum further
      if (min_ending_here > 0)
          min_ending_here = bedsperday[i];

      // else add the value arr[i] to min_ending_here
      else
          min_ending_here += bedsperday[i];

      // update min_so_far
      min_so_far = min(min_so_far, min_ending_here);
  }

  beds_sum = min_so_far;



cout<< beds_sum <<endl;

// sum = beds_sum / N*arr_sum ;


//  if (sum > max_sum)
// max_sum = sum ;

}
