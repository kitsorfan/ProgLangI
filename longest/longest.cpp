//auxilary code from: https://www.geeksforgeeks.org/longest-subarray-having-average-greater-than-or-equal-to-x/?fbclid=IwAR1Prq2UCG54AYjv8w-P6kHwulyoQO3E4kgbCCwq8Ipq3NY7GZAPKbIRlw0
//Literatelly we changed just few lines of code... 


#include <iostream>
#include <vector>
#include <algorithm>
#include <fstream>
#include <climits>

using namespace std;


// Comparison function used to sort preSum vector.
bool compare(const pair<long long int, long long int>& a, const pair<long long int, long long int>& b)
{
	if (a.first == b.first)
		return a.second < b.second;
	return a.first < b.first;
}

// Function to find (binary search) index in preSum vector upto which 
// all prefix sum values are less than or equal to val.
long long int findInd(vector<pair<long long int, long long int> >& preSum, long long int n, long long int val)
{
	long long int l = 0;
	long long int h = n - 1;
	long long int mid;
	long long int ans = -1;

	while (l <= h) {
		mid = (l + h) / 2;
		if (preSum[mid].first <= val) {
			ans = mid;
			l = mid + 1;
		}
		else
			h = mid - 1;
	}
	return ans;
}

// Function to find Longest subarray having average
// greater than or equal to hospitals.
long long int MaxGoodDays(long long int arr[], long long int n)
{
	long long int maxlen = 0;
	vector<pair<long long int, long long int> > preSum;
	double sum = 0;
	long long int minInd[n];
	for (long long int i = 0; i < n; i++) {
		sum = sum + arr[i];
		preSum.push_back({ sum, i });
	}

	sort(preSum.begin(), preSum.end(), compare);
	minInd[0] = preSum[0].second;

	for (long long int i = 1; i < n; i++) {
		minInd[i] = min(minInd[i - 1], preSum[i].second);
	}

	sum = 0;
	for (long long int i = 0; i < n; i++) {
		sum = sum + arr[i];
		if ((sum/((i+1)*n)) >= 0)
			maxlen = i + 1;
		else {
			long long int ind = findInd(preSum, n, sum);
			if (ind != -1 && minInd[ind] < i)
				maxlen = max(maxlen, i - minInd[ind]);
		}
	}

	return maxlen;
}


int main(int argc, char** argv) { //arg = number of arguments, argv pointer array of pointers to arguments

// @@@@@@@@@@@@@@@@@@@@@@@@@@----- DECLARTATIONS -----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  long long int days, hospitals;//number of days and hospitals
  long long int *discharges; //array to store discharges of each day (how many people leave or "leave")
  
  long long int temp = 0;	//temp value for input


// @@@@@@@@@@2@@@@@@@@@@@@@@@----- READING DATA -----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  const char * file_name = argv[1];	//name of file to open
  ifstream File(file_name); 		//open the file
  File>>days>>hospitals;

  discharges = new long long int[days];   //creating dynamic array

  for (long long int j=0; j<days; j++){
    File>>temp;
    discharges[j]=-temp-hospitals; //we add the negative value (to calculate positive sums after)
  }

	cout << MaxGoodDays(discharges, days)<<"\n";

}


