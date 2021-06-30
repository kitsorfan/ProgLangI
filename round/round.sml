(***************************************************************************
  Project     : Programming Languages 1 - Assignment 3 - Exercise Round
  Authors     : Stylianos Kandylakis el17088, 
                Kitsos Orfanopoulos el17025
  -----------
 ProgLangI 2021, ECE-NTUA
 ****************************************************************************
*)


(*@@@@@@@@@@@@@@@@@@- 1. Parse the File -@@@@@@@@@@@@@@@@@@*)

fun parse file =
    let
        val inStream = TextIO.openIn file       (* Firstly, open the file*)

        (* A function to read an integer from specified input. *)
        fun readInt input = 
        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
       
        (* A function to read N (parameter) days from the open file. *)
        fun readCars 0 acc = rev acc             
        |   readCars i acc = readCars (i - 1) (readInt inStream :: acc)

        val cities = readInt inStream           (* Read the days *)
        val cars = readInt inStream             (* Read the hospitals*)
        val _ = TextIO.inputLine inStream       (* Consume a new line *)
    in
    	(cities, cars, readCars cars [])   (* returned tuple (days, hospitals, discharges). Note: that discharges calls the function defined before with parameter days *)
    end;





(*@@@@@@@@@@@@@@@@@@- 2. Create a final state -@@@@@@@@@@@@@@@@@@*)

fun createFinalList (targetCity, 0) = nil
  | createFinalList (targetCity, cars) = 
     targetCity::(createFinalList(targetCity,cars-1));


(*@@@@@@@@@@@@@@@@@@- 4. Subtract to list (target state - current state) -@@@@@@@@@@@@@@@@@@*)


fun compareTwoList([], [], cities)=nil
  | compareTwoList(target::tRest,current::cRest,cities)=
   let 
      fun distance(a, b, city)=
      if ((a-b)>=0) then (a-b)
      else (city-b+a)
   in 
      distance(target,current,cities)::compareTwoList(tRest,cRest,cities)
   end;


(*@@@@@@@@@@@@@@@@@@- Find the max and the sum of a list -@@@@@@@@@@@@@@@@@@*)


fun maxAndSum ([],currentMax, currentSum) =  (currentMax,currentSum)
 | maxAndSum ((x::xs),currentMax,currentSum) =
    if x > currentMax then maxAndSum(xs, x, (currentSum+x)) else maxAndSum(xs, currentMax, (currentSum+x));

(*@@@@@@@@@@@@@@@@@@-  multiple -@@@@@@@@@@@@@@@@@@*)

fun multipleFinalList (0, cars, initial,cities,min,i,minI) = (min,minI)
  | multipleFinalList (allCities, cars, initial, cities,min,i,minI) = 
    let
        val temp = createFinalList(allCities-1,cars)
        val compared = compareTwoList(temp, initial, cities)
        fun checkMax (max, sum) = 
           if ((2*max-sum)>=2) then valOf Int.maxInt
             else sum;
         val (maxy,sumy) = maxAndSum(compared, 0,0)
         val result = checkMax(maxy,sumy)

    in 
        if (result<=min) then multipleFinalList(allCities-1,cars,initial,cities,result,(i+1),(allCities-1))
        else multipleFinalList(allCities-1,cars,initial,cities,min,(i+1),minI)
    end;


(*@@@@@@@@@@@@@@@@@@- FINAL FUNCTION -@@@@@@@@@@@@@@@@@@*)
(* Takes a sigle parameter, a text called inputFile, *)

fun round inputFile = 
  let
    val inputTuple = parse inputFile         (* Calls parse that reads from file, return a tuple with 3 parameters: (cities, cars, positions). *)
      val cities = #1 inputTuple               (* days *)
      val cars = #2 inputTuple          (* hospitals *)
      val positions = #3 inputTuple         (* discharges: how many leave the hospitals (or die) everyday. *)
      (* val finalList = multipleFinalList(cities,cars) *)
      val finalList = multipleFinalList(cities, cars, positions, cities,(valOf Int.maxInt),0,0)
      (* val comparedLists = compareAllLists(finalList,positions,cities) *)
      (* val moves = movements(comparedLists) *)
      (* val result =  minOfList(moves,(hd moves),0,0) *)
      (* val result =  minOfList(finalList,(hd finalList),0,0) *)

      val res1 = #1 finalList
      val res2 = #2 finalList
       
      
  in
    (* (print(Int.toString(answer)^"\n"))     We print the result     *)
    (* (positions,finalList,comparedLists, moves) *)
    print(Int.toString(res1)^" "^Int.toString(res2)^"\n")
    (* (print(Int.toString(finalList)^"\n")) *)
  end;

(* testing *)
(* round "tests/r1.txt"; 
round "tests/r5.txt";
round "tests/r2.txt"; 
round "tests/r31.txt";   *)


(* this is not a valid command. It cannot be compiled. Thought it terminates the interactive environment allowing as to run it again if we change the code, I guess it does exit in some way*)
(* exit;  *)


(* 






 *)