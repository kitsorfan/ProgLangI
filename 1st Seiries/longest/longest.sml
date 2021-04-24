(***************************************************************************
  Project     : Programming Languages 1 - Assignment 1 - Exercise Longest
  Authors   : Stylianos Kandylakis, Kitsos Orfanopoulos
  -----------
  School of ECE, National Technical University of Athens.
*)

(* Input parse code by Stavros Aronis, modified by Nick Korasidis. Source: https://courses.softlab.ntua.gr/pl1/2013a/Exercises/countries.sml *)
(* Solution based on the article: https://stackoverflow.com/questions/13476927/longest-contiguous-subarray-with-average-greater-than-or-equal-to-k *)



(*@@@@@@@@@@@@@@@@@@- Parse the file -@@@@@@@@@@@@@@@@@@*)
fun parse file =
    let
        val inStream = TextIO.openIn file       (* Firstly, open the file*)

        (* A function to read an integer from specified input. *)
        fun readInt input = 
        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
       
        (* A function to read N (parameter) days from the open file. *)
        fun readDays 0 acc = rev acc             
        |   readDays i acc = readDays (i - 1) (readInt inStream :: acc)



        val days = readInt inStream             (* Read the days *)
        val hospitals = readInt inStream        (* Read the hospitals*)
        val _ = TextIO.inputLine inStream       (* Consume a new line *)
    in
    	(days, hospitals, readDays days [])                      (* returned tuple (days, hospitals, discharges). Note: that discharges calls the function defined before with parameter days *)
    end;


(*@@@@@@@@@@@@@@@@@@- Prefix and Index -@@@@@@@@@@@@@@@@@@*)
(* Function that takes a list and returns a tuple with prefix list and the index of this list *)
fun indexAndPrefix ((x::more),1,0) = (x,1)::(indexAndPrefix (more,2,x)) (* For the first time simply we return (x, 0) and we continue the recursive*)
| indexAndPrefix ((x::more),n,sum) = ((sum+x),n)::(indexAndPrefix (more,n+1,(sum+x)))
| indexAndPrefix _ = nil (* finish condition*)


fun tupleMin ((a1,b1),(a2,b2)) = 
if (a1<=a2) then true
else false

(*@@@@@@@@@@@@@@@@@@- Mergesort -@@@@@@@@@@@@@@@@@@*)
(* *)

fun mergesort nil = nil
|   mergesort [a] = [a]
|   mergesort merge_list = 
        let 
        fun halve nil = (nil, nil) 
        |   halve [a] = ([a], nil)
        | halve (a::b::rest) = 
            let 
                val (x, y) = halve rest
            in 
                (a::x, b::y)
            end;
            
        fun merge (nil, a) = a 
        |   merge (b , nil) = b
        |   merge (x::xs, y::ys) =
            if tupleMin(x,y) then x::merge(xs, y::ys)
            else y::merge(ys, x::xs);

            
            val (x,y) = halve merge_list
       in
            merge(mergesort x, mergesort y)
        end;


  fun onlyIndex ((a,b)::rest) = b::onlyIndex(rest)
  | onlyIndex nil = nil


fun findMaxDif ((a::rest), min, maxDif) = 
  let 
     val neo_min = if (a<min) then a else min
     val neo_maxDif = if  ((a-min)>maxDif) then (a-min) else maxDif
  in
    findMaxDif(rest,neo_min,neo_maxDif)
  end
| findMaxDif ([],min,maxDif) = maxDif



(*@@@@@@@@@@@@@@@@@@- FINAL FUNCTION -@@@@@@@@@@@@@@@@@@*)
(* Takes a sigle parameter, a text called inputFile, and returns the number of good days *)

fun longest inputFile = 
  let
    val inputTuple = parse inputFile         (* Calls parse that reads from file, return a tuple with 3 parameters: (days, hospitals, discharges). *)
      val days = #1 inputTuple               (* days *)
      val hospitals = #2 inputTuple          (* hospitals *)
      val discharges = #3 inputTuple         (* discharges is how many leave the hospitals everyday. *)
      
    val discharges_sub_hospitals = map (fn x => ~x - hospitals) discharges (* we make the opposite (how many leave as a positive) and we subtract the number of hospitals *)
    val indexed_prefixed_discharges = indexAndPrefix (discharges_sub_hospitals,1,0) (* we take our discharges list and make every element a tuple: (element, index). We also create at the same time prefixes. We start from index 1 and sum 0*)
    val indexed_array = (0,0)::indexed_prefixed_discharges;
    val sorted_array = mergesort indexed_array
    val takeIndex = onlyIndex sorted_array
    val answer = findMaxDif (takeIndex, (hd takeIndex), 0)

  in
     (answer)

  end;

(* Useless code, only for testing reasons 
 To test the code just type "sml <loop_rooms.sml" on Terminal*)
  longest "tests/longest.in14"; 

(*
1. Parse the file
2. Create opposite array and subtract the hospitals
3. Create prefix array and add indexes
4. Sort prefix array according to its prefixes


*)
