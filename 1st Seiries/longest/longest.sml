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
fun index ((x::more),n) = (x,n)::(index (more,n+1))
| index _ = nil



(*@@@@@@@@@@@@@@@@@@- FINAL FUNCTION -@@@@@@@@@@@@@@@@@@*)
(* Takes a sigle parameter, a text called inputFile, and returns the number of good days *)

fun longest inputFile = 
  let
    val inputTuple = parse inputFile         (* Calls parse that reads from file, return a tuple with 3 parameters: (days, hospitals, discharges). *)
      val days = #1 inputTuple               (* days *)
      val hospitals = #2 inputTuple          (* hospitals *)
      val discharges = #3 inputTuple         (* discharges is how many leave the hospitals everyday. *)
      
    val discharges_sub_hospitals = map (fn x => ~x - hospitals) discharges (* we make the opposite (how many leave as a positive) and we subtract the number of hospitals *)
    val indexed_discharges = index (discharges_sub_hospitals,0)
    
  in
     indexed_discharges

  end;

(* Useless code, only for testing reasons 
 To test the code just type "sml <loop_rooms.sml" on Terminal*)
  longest "tests/longest.in1"; 

