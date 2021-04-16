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

// algorithm
double min_ending_here = DBL_MAX;
double min_so_far_d = DBL_MAX;
double min_so_far = DBL_MAX;
double length;


int max_length;
double sum=0;
}
*/

/*
for (int i=0; i<M; i++)
{
      // if min_ending_here > 0, then it could not possibly
      // contribute to the minimum sum further
      if (min_ending_here > 0)
      {    min_ending_here = bedsperday[i];
          length=0;
      }
      // else add the value arr[i] to min_ending_here
      else
      {  min_ending_here += bedsperday[i];
         length++ ;
      }
      // update min_so_far

      min_so_far_d = max( (min_so_far_d/length) , min_ending_here);
cout<<min_so_far_d<<endl;
      min_so_far = min(min_so_far , min_ending_here);
}

//  beds_sum = min_so_far;


cout<< length<<endl;
cout<< min_so_far <<endl;
cout<<min_so_far_d<<endl;
// sum = beds_sum / N*arr_sum ;
*/

//  if (sum > max_sum)
// max_sum = sum ;




// algorithm
double min_ending_here = DBL_MAX;
double min_so_far_d = DBL_MAX;
double min_so_far = DBL_MAX;
double length;


int max_length;
double sum=0;

for (int i=0; i<M; i++)
{
      if (fun(min_ending_here,N*length) < 1)
      {   min_ending_here = bedsperday[i];
          length=0;
      }

      else
      {
         if( fun(min_ending_here,N*length) > sum ) {

           sum = fun(min_ending_here,N*length);
           max_length=length;
          }

          length++ ;
          min_ending_here += bedsperday[i];

      }
}
cout<<sum<<endl;

cout<< max_length<<endl;
