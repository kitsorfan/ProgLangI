(***************************************************************************
  Project     : Programming Languages 1 - Assignment 1 - Exercise Longest
  Authors     : Stylianos Kandylakis el17088, 
                Kitsos Orfanopoulos el17025
  -----------
 ProgLangI 2021, ECE-NTUA
 ****************************************************************************
*)

(* Solution based on the article: https://stackoverflow.com/questions/13476927/longest-contiguous-subarray-with-average-greater-than-or-equal-to-k 

Different Approach: 
  According to the article, after sorting the array we must do a swap to the initial array and for each prefix do a binary search at the new array. We avoided that by findinx the maximum Difference at the indixes in the new array. See the example.


Steps:

1. Parse the file
2. Create opposite array and subtract the hospitals
3. Create prefix array and add indexes
4. Add (0,0) as element of the list
5. Sort prefix array according to its prefixes
6. Remove prefixes and create a list only with indexes.
7. Find the maximum difference.

Example: 

Suppose we have 3 hospitals and 11 days. The given array is:
42 -10	8	1	11	-6	-12	16	-15	-11	13

After:
  Step 1: [42,	-10,	8,	1,	11,	-6,	-12,	16,	-15,	-11, 13]
   
  Step 2: [-45,	7,	-11,	-4,	-14,	3,	9,	-19,	12,	8,	-16]    //(element = -element - hospitals)

  Step 3: [(-45,1),	(-38,2),	(-49,3),	(-53,4),	(-67,5),	(-64,6),	(-55,7),	(-74,8),	(-62,9),	(-54,10),	(-70,11)]   //(make indexes and prefixes, where prefix is sum = sum + current)


  Step 4: [(0,0), (-45,1),	(-38,2),	(-49,3),	(-53,4),	(-67,5),	(-64,6),	(-55,7),	(-74,8),	(-62,9),	(-54,10),	(-70,11)]  // add (0,0)

  Step 5:  [(-74,8), (-70,11), (-67,5), (-64,6), (-62,9), (-55,7), (-54,10), (-53,4), (-49,3), (-45,1), (-38,2), (0,0)] //sort by prefixes

  Step 6: [8, 11, 5, 6, 9, 7, 10, 4, 3, 1, 2, 0]    //we remove prefixex, keep only indexes

  Step 7: we do a left to right swap. 
          A. We start with min=8 and maxDif = 0. 
          B. 8<11, so maxDif=(11-8)=3 and min 8. 
          C. 8>5 so min=5
          D. 5<6, but maxDif = 3 (6-5 = 1 < 3)
          and so on

          We will have min 5<10 and maxDif= 10-5 = 5. So 5 is our final answer 



*)


(*@@@@@@@@@@@@@@@@@@- 1. Parse the file -@@@@@@@@@@@@@@@@@@*)
(* Coded by Stavros Aronis, modified by Nick Korasidis. Source: https://courses.softlab.ntua.gr/pl1/2013a/Exercises/countries.sml 
  Function that takes a string: path for a file, reads and returns a specific tuple*)


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
    	(days, hospitals, readDays days [])       (* returned tuple (days, hospitals, discharges). Note: that discharges calls the function defined before with parameter days *)
    end;


(*@@@@@@@@@@@@@@@@@@- 2. Prefix and Index -@@@@@@@@@@@@@@@@@@*)
(* A function that takes a list and returns a tuple with prefix list and the index of this list 
-- 
ex. [12, 9, 3] -> [(12,1), (21, 2), (24, 3)]. We start indexing from 1 (we will add an (0,0) manually)
*)

fun indexAndPrefix ((x::more),1,0) = (x,1)::(indexAndPrefix (more,2,x)) (* For the first time simply we return (x, 1) and we continue the recursive*)
| indexAndPrefix ((x::more),n,sum) = ((sum+x),n)::(indexAndPrefix (more,n+1,(sum+x)))
| indexAndPrefix _ = nil (* finish condition*)


(*@@@@@@@@@@@@@@@@@@- 3. tupleMin (auxilary) -@@@@@@@@@@@@@@@@@@*)
(* Takes two touple (a1,b1) and (a2,b2) and compares them according to their second parameter. If b1<b2 it returns true*)

fun tupleMin ((a1,b1),(a2,b2)) = 
  if (a1<=a2) then true
  else false


(*@@@@@@@@@@@@@@@@@@- 4. Mergesort -@@@@@@@@@@@@@@@@@@*)
(* The well-known mergesort function (see also Adam Brooks Webber book). It takes a list of tuples (value, index) and return a sorted list (value, index).
The only differece with the book is that we have a  list of tuples, so to compare them we use a seperate function called 3. tupleMin
--
ex. [(0,0), (-2, 1), (9,2), (4, 3)] -> [(-2, 1), (0,0), (4, 3), (9,2)]
*)

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
            if tupleMin(x,y) then x::merge(xs, y::ys) (* the only change is here tupleMin*)
            else y::merge(ys, x::xs);

            
            val (x,y) = halve merge_list
       in
            merge(mergesort x, mergesort y)
        end;


(*@@@@@@@@@@@@@@@@@@- 5. onlyIndex -@@@@@@@@@@@@@@@@@@*)
(* A function that takes a list of tuples and returns a single list with elements the second value of each tuple. 
--
ex. [(0,0), (-2, 1), (9,2), (4, 3)] -> [1, 0, 2, 3]
*)
fun onlyIndex ((a,b)::rest) = b::onlyIndex(rest)
  | onlyIndex nil = nil


(*@@@@@@@@@@@@@@@@@@- 6. findMaxDif -@@@@@@@@@@@@@@@@@@*)
(* A function that takes a list and returns the maximum positive difference of the current minimum value from the current value. 
We do a left-to-right swap, updating each step the current minimum value. 
  We subtract that minimum from our current value. If that difference is larger than our current maxDif we update it. 
  The output of this function, maxDif, will be our final answer. 
Initial value for min is list[0] and maxDif=0.
--
ex. [5, 1, 0, 2, 3] ->  2  (Answer is: 2-0)
*)
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
      val discharges = #3 inputTuple         (* discharges: how many leave the hospitals (or die) everyday. *)
      
    val discharges_sub_hospitals = map (fn x => ~x - hospitals) discharges          (* Function that works as this: [5, 9, -6, -44, 8] and hospitals= 3 -> [-8, -12, 3, 41, -11] *)

    val indexed_prefixed_discharges = indexAndPrefix (discharges_sub_hospitals,1,0) (* We take our discharges list and make every element a tuple: (element, index). We also create the prefixes. We start from index 1 and sum 0*)
    val indexed_prefixed_discharges_init = (0,0)::indexed_prefixed_discharges;      (* We add initial value (0,0) to our list.*)
    val sorted_array = mergesort indexed_prefixed_discharges_init                   (* We sort the list *)
    val take_index = onlyIndex sorted_array                                          (* We keep only the index *)
    val answer = findMaxDif (take_index, (hd takeIndex), 0)                          (* We find the maximum difference, for example see above*)

  in
    (print(Int.toString(answer)^"\n"))     (* We print the result*)    

  end;



(* Useless code, only for testing reasons 
 To test the code just type "sml <loop_rooms.sml" on Terminal*)

  (* longest "tests/longest.in1";  *)

