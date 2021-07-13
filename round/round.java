      
/*
********************************************************************************
  Project     : Programming Languages 1 - Assignment 3 - Exercise Round
  Authors     : Stylianos Kandylakis el17088, 
                Kitsos Orfanopoulos el17025
  -----------
 ProgLangI 2021, ECE-NTUA
 *******************************************************************************

>> 
Main Idea:      We create an inverted list showing how many cars are in every city (initial list shows where everey car is).
                With that list, and knowing the initial sum of distances from the zero final state, we can move two pointers (one main, and one showing next to the main) updating every time the sum and the max.

*/


import java.io.*;
import java.util.*;

public class round {

    private static int distance(int initial, int target,int allCities){
        if (target>=initial) return (target-initial);
        return (allCities-initial+target);
    }
    private static int checkDistance(int max, int sum){
        if ((2*max-sum)<2) return sum;
        return 100002;
    }
    private static int[] compareWithZero(int [] initial, int cars, int cities){
        int [] answer = new int[2];
        int max = 0;
        int sum = 0;
        max = 0;
        for (int i = 0; i < cars; i++){ 
            int Distance = distance(initial[i],0,cities);
            sum += Distance;
            if (max>Distance) max = Distance;
        }
        sum = checkDistance(max,sum);
        answer[0] = max;
        answer[1] = sum;
        return answer;
    }
    private static int[] twoIndexGame(int [] cityTable, int cities, int cars, int sum){
        int [] answer = new int[2];
        int mainIndex = 1;
        int maxIndex = 2;
        int min = sum;
        int minI = 0;
        for (mainIndex = 1; mainIndex < cities; mainIndex++){
            if (maxIndex==mainIndex) maxIndex++;
            while (cityTable[maxIndex%cities]==0) maxIndex++;
            maxIndex = maxIndex%cities;
            sum = sum + cars - cities*cityTable[mainIndex];
            int Distance = distance(mainIndex,maxIndex,cities);
            int tempsum = checkDistance(Distance, sum);
            // System.out.println("here "+sum);
            if (tempsum<min){
                min = sum;
                minI  = mainIndex;
            }
        }
        answer[0] = min;
        answer[1] = minI;
        return answer;
    }

	public static void main(String[] args) {
    	String inputArg = args[0];
    
		try {
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

            int [] cityTable = new int [cities];

            for (int i = 0; i < cars; i++){
                cityTable[initial[i]]++;
            }

            int [] maxAndSum = new int[2];
            maxAndSum = compareWithZero(initial, cars, cities);
            int max = maxAndSum[0];
            int sum = maxAndSum[1];


            int [] minAndMinI = new int[2];
            minAndMinI = twoIndexGame(cityTable, cities, cars, sum);
            int min = minAndMinI[0];
            int minI = minAndMinI[1];
            System.out.println(min+" "+minI);



		} catch (IOException e) {
			e.printStackTrace();
		}

	}
}        
