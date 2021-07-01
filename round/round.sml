(***************************************************************************
  Project     : Programming Languages 1 - Assignment 3 - Exercise Round
  Authors     : Stylianos Kandylakis el17088, 
                Kitsos Orfanopoulos el17025
  -----------
 ProgLangI 2021, ECE-NTUA
 ****************************************************************************
*)

(*

Initial thoughts: We have to find the city with the minimum sum of distances from our initial state. 
On the same time we have to assure that the largest distance of individual cars 

Initial thoughts: We have to find the city from with the minimum sum of distances, where the car with maximum distance, has a distance at max one edge greater than the sum of all the other distances.

Initial Steps:
1. Parse the file (identify cities, cars, intialState)
2. Create all possible final States (list of lists)
3. For each final state find the distance from the initial state (list of lists). This is a list o distances
4. For every final-initial distance, find the sum of individual distances and the max individual distance
5. Check if sum and max is  legit, and create a list of legit sums.
6.  Find the min sum and its index in the list. This is your result.

These steps produce the wanted result, but doing them seperetaly is not efficient, thus we had to merge many functions together to reduce time and space.
We avoided to create lists of lists, by initially merging steps 2-3-4 then 4-5 and finally we merged step 6.
*)





(*@@@@@@@@@@@@@@@@@@- 1. Parse the File -@@@@@@@@@@@@@@@@@@*)

fun parse file =
    let
        val inStream = TextIO.openIn file       (* Firstly, open the file*)

        (* A function to read an integer from specified input. *)
        fun readInt input = 
        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
       
        (* A function to read N (parameter) numbers, the positions of the cars, from the open file. *)
        fun readCars 0 acc = rev acc             
        |   readCars i acc = readCars (i - 1) (readInt inStream :: acc)

        val cities = readInt inStream           (* Read the cities *)
        val cars = readInt inStream             (* Read the cars*)
        val _ = TextIO.inputLine inStream       (* Consume a new line *)
    in
    	(cities, cars, readCars cars [])   (* returned tuple (cities, cars, initialState). Note: that readCars calls the function , who was defined before, with parameter cras *)
    end;

(*@@@@@@@@@@@@@@@@@@- AUXILARY FUNTIONS -@@@@@@@@@@@@@@@@@@*)

(*@@@@@@@@@@@@@@@@@@- 2. Create a final state -@@@@@@@@@@@@@@@@@@*)
(* Take a number, targetCity, and create a final state, a list with cars elements.
ex. For targetCity=4 and cars=6 we create: [4,4,4,4,4,4] *)

fun createFinalList (targetCity, 0) = nil
  | createFinalList (targetCity, cars) = 
     targetCity::(createFinalList(targetCity,cars-1));


(*@@@@@@@@@@@@@@@@@@- 3. Compare two lists - (subtract target state - current state) -@@@@@@@@@@@@@@@@@@*)
(* Take two lists, the initial and a final state, and find their difference. Note that if a>b we just find a-b, else we find city-b+a *)
(* ex. A. initial state [2,2,0,2] and final state [3,3,3,3] -> [1,1,3,1] 
       B. initial state [2,2,0,2] and final state [0,0,0,0] -> [2,2,0,2]  (assume we have 4 cities) *)

fun compareTwoLists([], [], cities)=nil
  | compareTwoLists(target::tRest,current::cRest,cities)=
   let 
      fun distance(a, b, city)= (* auxilary function *)
      if ((a-b)>=0) then (a-b)
      else (city-b+a) 
   in 
      distance(target,current,cities)::compareTwoLists(tRest,cRest,cities) (* tail-recursive *)
   end;


(*@@@@@@@@@@@@@@@@@@- 4. Find the max and the sum of a list -@@@@@@@@@@@@@@@@@@*)
(* Find the maxiumum and the sum of a list
   ex. [4,2,1,4,8,5] -> (max, sum) = (8,24) *)

fun maxAndSum ([],currentMax, currentSum) =  (currentMax,currentSum) (* End of recursion, return result tuple *)
 | maxAndSum ((x::xs),currentMax,currentSum) =
    if x > currentMax then maxAndSum(xs, x, (currentSum+x)) else maxAndSum(xs, currentMax, (currentSum+x));


(*@@@@@@@@@@@@@@@@@@- 5. Merged Multifunction -@@@@@@@@@@@@@@@@@@*)
(* This function is does multiple things. Takes many parameters and returns the final answer tuple *)

fun mergedFunction (0, cars, initial,cities,min,minI) = (min,minI) (* end of recursion (first parameter is 0) return (min, index) *)
  | mergedFunction (allCities, cars, initial, cities,min,minI) = 
    let
        val temp = createFinalList(allCities-1,cars)          (* we create a new final state to examine. Starting from [allCities-1, allCities-1, ... , allCities-1] *)
        val compared = compareTwoLists(temp, initial, cities) (* we create the compared list (difference between final and initial state) *)
        fun checkMax (max, sum) =                             (* auxilary function to check if a (max,sum) tuple is valid*)
           if ((2*max-sum)>=2) then valOf Int.maxInt          (* max - (sum-max)<=1*)
             else sum;                                        (* Return the sum if it is valid, else return "a very large number". Note here is >= because we start the scan from the allCities-1, not from 0 *)
         val (maxy,sumy) = maxAndSum(compared, 0,0)           (* get max and sum of the list*)
         val result = checkMax(maxy,sumy)                     (* check if max and sum is valid *)

    in 
        if (result<=min) then mergedFunction(allCities-1,cars,initial,cities,result,(allCities-1)) (* Recursion: start from a very big min, and each time call the function with the current min, and the current index*)
        else mergedFunction(allCities-1,cars,initial,cities,min,minI)
    end;


(*@@@@@@@@@@@@@@@@@@- FINAL FUNCTION -@@@@@@@@@@@@@@@@@@*)
(* Takes a sigle parameter, a text called inputFile, prints the final result*)

fun round inputFile = 
  let
    val inputTuple = parse inputFile         (* Calls parse that reads from file, return a tuple with 3 parameters: (cities, cars, initialState). *)
      val cities = #1 inputTuple           
      val cars = #2 inputTuple               
      val initialState = #3 inputTuple        
      val result = mergedFunction(cities, cars, initialState, cities,(valOf Int.maxInt),0) (* calls *)
      val res1 = #1 result  (* seperate result tuple to each components*)
      val res2 = #2 result
  in
    print(Int.toString(res1)^" "^Int.toString(res2)^"\n")
  end;

(* testing. Run sml round.sml on terminal. Comment this when upload to the grader *)
round "tests/r1.txt"; 
round "tests/r2.txt"; 
round "tests/r5.txt";
round "tests/r31.txt";  

(* this is not a valid command. It cannot be compiled. Thought it terminates the interactive environment allowing as to run it again if we change the code, I guess it does exit in some way*)
exit; 
