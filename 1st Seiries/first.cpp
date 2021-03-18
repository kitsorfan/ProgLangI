#include <iostream>
#include <climits>
using namespace std;


int main(){
int N , M ;

cin >> M >> N ;                   // M = max days , N = #hospitals

int beds_sum;

int bedsperday[M];

for(int i=0; i<M; i++){ cin>> bedsperday[i]; }

// algorithm

    int max_so_far = INT_MIN, max_ending_here = 0;

    for (int i = 0; i < M; i++)
    {
        max_ending_here = max_ending_here + bedsperday[i];
        if (max_so_far < max_ending_here)
            max_so_far = max_ending_here;

        if (max_ending_here < 0)
            max_ending_here = 0;
    }

  beds_sum = max_so_far;



cout<< beds_sum <<endl;

// sum = beds_sum / N*arr_sum ;


//  if (sum > max_sum)
// max_sum = sum ;

}
