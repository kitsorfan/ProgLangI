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

(*@@@@@@@@@@@@@@@@@@- 3. Create all final states -@@@@@@@@@@@@@@@@@@*)


fun multipleFinalList (0, cars) = nil
  | multipleFinalList (allCities, cars) = 
    let
        val temp = createFinalList(allCities-1,cars)
    in 
        multipleFinalList(allCities-1,cars)@[temp]
    end;


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

(*@@@@@@@@@@@@@@@@@@- 7. Check max -@@@@@@@@@@@@@@@@@@*)


fun compareAllLists([],initialState,cities)= nil
  | compareAllLists(target::rest,initial,cities)=
  compareTwoList(target,initial,cities)::compareAllLists(rest,initial,cities);

(*@@@@@@@@@@@@@@@@@@- Find max of a list -@@@@@@@@@@@@@@@@@@*)


fun maxOfList [] = raise Empty 
 | maxOfList [x] = x
 | maxOfList (x::xs) =
      let 
        val y = maxOfList xs
      in
        if x > y then x else y
      end;

(*@@@@@@@@@@@@@@@@@@- Find sum of a list -@@@@@@@@@@@@@@@@@@*)

fun sumOfList L = foldl(op +) 0 L;

(*@@@@@@@@@@@@@@@@@@- Check max -@@@@@@@@@@@@@@@@@@*)

fun checkMax (max, sum) = 
  if ((2*max-sum)>=2) then valOf Int.maxInt
  else sum;

(*@@@@@@@@@@@@@@@@@@-  Check max -@@@@@@@@@@@@@@@@@@*)

fun movements([])=nil
| movements(a::rest) = 
let
  val maxy = maxOfList a
  val sumy = sumOfList a
  val result = checkMax(maxy, sumy)
in
  result::movements rest
end;


(*@@@@@@@@@@@@@@@@@@-  Find min -@@@@@@@@@@@@@@@@@@*)

fun minOfList ([],min,i,minI) = (min,minI) 
 | minOfList (x::xs,min,i,minI) =
      if (x<min) then minOfList(xs,x,i+1,i)
      else minOfList(xs,min,i+1,minI)
       


(*@@@@@@@@@@@@@@@@@@- FINAL FUNCTION -@@@@@@@@@@@@@@@@@@*)
(* Takes a sigle parameter, a text called inputFile, *)

fun round inputFile = 
  let
    val inputTuple = parse inputFile         (* Calls parse that reads from file, return a tuple with 3 parameters: (cities, cars, positions). *)
      val cities = #1 inputTuple               (* days *)
      val cars = #2 inputTuple          (* hospitals *)
      val positions = #3 inputTuple         (* discharges: how many leave the hospitals (or die) everyday. *)
      val finalList = multipleFinalList(cities,cars)
      val comparedLists = compareAllLists(finalList,positions,cities)
      val moves = movements(comparedLists)
      val headmoves = hd moves
      val result =  minOfList(moves,headmoves,0,0)
      val res1 = #1 result
      val res2 = #2 result
       
      
  in
    (* (print(Int.toString(answer)^"\n"))     We print the result     *)
    (* (positions,finalList,comparedLists, moves) *)
    print(Int.toString(res1)^" "^Int.toString(res2)^"\n")
  end;

  (* testing *)

 (* print("\n\n\n\n\n\n\n"); *)
(* round "tests/r2.txt";  *)
(* createFinalList (1, 5); *)
(* multipleFinalList(4,4,[]);   *)
(* print("\n"); *)
(* compareTwoList([1,1,1,1],[2,0,2,2],4); *)
(* val maxy = maxOfList (compareTwoList([1,1,1,1],[2,0,2,2],4));
val sumy = sumOfList (compareTwoList([1,1,1,1],[2,0,2,2],4));
checkMax(maxy,sumy); *)

(* print("\n\n\n\n\n\n\n"); *)

(* this is not a valid command. It cannot be compiled. Thought it terminates the interactive environment allowing as to run it again if we change the code, I guess it does exit in some way*)
(* exit;  *)