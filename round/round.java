      
/*
********************************************************************************
  Project     : Programming Languages 1 - Assignment 3 - Exercise Round
  Authors     : Stylianos Kandylakis el17088, 
                Kitsos Orfanopoulos el17025
  -----------
 ProgLangI 2021, ECE-NTUA
 *******************************************************************************

 Translate PROLOG:
    This solution is a translation of our prolog solution. See also the pdf with the solution analysis.


Main Idea:      We create an inverted list showing how many cars are in every city (initial list shows where everey car is).
                With that list, and knowing the initial sum of distances from the zero final state, we can move two pointers (one main, and one showing next to the main) updating every time the sum and the max.

*/


import java.io.*; // for I/O methods

public class round { // we will use only one class

    // @@@@@@@@@@@@@@@@@@- 1. Distance -@@@@@@@@@@@@@@@@@@
    // target: the final city, Initial: the initial city, cities: total number of cities
    private static int distance(int initial, int target,int cities){
        if (target>=initial) return (target-initial);
        return (cities-initial+target);
    }
    // @@@@@@@@@@@@@@@@@@- 2. checkDistance -@@@@@@@@@@@@@@@@@@
    // check validity of Max and Sum tuple
    // (Sum-Max) + 1 <= Max
    private static int checkDistance(int max, int sum){
        if ((2*max-sum)<2) return sum;
        return 100002; // a very large number
    }


    // @@@@@@@@@@@@@@@@@@- 3. compareWithZero -@@@@@@@@@@@@@@@@@@
    //    This method is used only once, at the begging to find the sum and the max distance from the state [0,0,...]
    //    Take two lists, the initial and a final state, and find their difference. 
    //    ex. 1. initial state [2,2,0,2] and final state [3,3,3,3] -> [1,1,3,1] 
    //          2. initial state [2,2,0,2] and final state [0,0,0,0] -> [2,2,0,2]  (assume we have 4 cities)
    //          Then it returns the Max and Sum of that list
    //    We need the max to check the validity (checkDistance) later.
    private static int[] compareWithZero(int [] initial, int cars, int cities){
        int max = 0;
        int sum = 0;
        max = 0;
        for (int i = 0; i < cars; i++){ 
            int Distance = distance(initial[i],0,cities);
            sum += Distance;
            if (max>Distance) max = Distance;
        }
        int [] answer = new int[2];
        answer[0]=max;
        answer[1]=sum;
        return answer;
    }
    
    // @@@@@@@@@@@@@@@@@@- 4. Two Index Game -@@@@@@@@@@@@@@@@@@
    // This is the most important method clause of this solution.
    // We take the city Table from the previous method.
    // We have two pointers, the main shows the current element of the CityTable, the other shows the max in that CityTable (actually we use a DoubleTable-see below-to avoid the usage of nth0 clause)
    // In every step we move the main pointer to the right. The max pointer will point to the next, on the right of main pointer, non zero element.
    // We begin scanning the CityTable knowing the sum. 
    // We update the sum in every step: NewSum = Sum + cars - cities*CityTable[i], i is main pointer
    // Each time we check the validity of that sum, and we update the min as well
    // When the scan is over we take the final min 
    private static int[] twoIndexGame(int [] cityTable, int cities, int cars, int sum, int max){
        int [] answer = new int[2];
        int mainIndex = 1;  // Useless. We start from 1, because we have already checked 0
        int maxIndex = 2;   // consequently, maxIndex starts from two
        int min = checkDistance(max, sum); // check the validity of the sum, without affecting the sum
        int minI = 0;   // minI is the index of min
        for (mainIndex = 1; mainIndex < cities; mainIndex++){
            if (maxIndex==mainIndex) maxIndex++;
            while (cityTable[maxIndex%cities]==0) maxIndex++; 
            maxIndex = maxIndex%cities; //pacman effect
            sum = sum + cars - cities*cityTable[mainIndex];
            int Distance = distance(maxIndex,mainIndex,cities);
            int tempsum = checkDistance(Distance, sum); // check the validity
            if (tempsum<min){
                min = sum;
                minI  = mainIndex;
            }
        }
        answer[0] = min;
        answer[1] = minI;
        return answer; //tuple
    }
    // @@@@@@@@@@@@@@@@@@- MAIN -@@@@@@@@@@@@@@@@@@
	public static void main(String[] args) {
    	String inputArg = args[0];
    
		try {
            // reading the input
		    BufferedReader in = new BufferedReader(new FileReader(inputArg));
            String line = in.readLine ();
            String [] a = line.split (" ");
            int cities = Integer.parseInt(a[0]);
            int cars = Integer.parseInt(a[1]);
            int [] initial = new int [cars];
            line = in.readLine ();
            a = line.split (" ");
            for (int i = 0; i < cars; i++)
                initial[i] = Integer.parseInt(a[i]);
            in.close ();

            // creating cityTable array
            int [] cityTable = new int [cities];
            for (int i = 0; i < cars; i++){
                cityTable[initial[i]]++;
            }

            // finding initial max and sum (for zero final states)
            int [] maxAndSum = new int[2];
            maxAndSum = compareWithZero(initial, cars, cities);
            int max = maxAndSum[0];
            int sum = maxAndSum[1];

            // finding the min total Distance
            int [] minAndMinI = new int[2]; // tuple 
            minAndMinI = twoIndexGame(cityTable, cities, cars, sum, max);
            int min = minAndMinI[0];
            int minI = minAndMinI[1];   // the index of min

            // printing the result
            System.out.println(min+" "+minI);



		} catch (IOException e) {
			e.printStackTrace();
		}

	}
}        
