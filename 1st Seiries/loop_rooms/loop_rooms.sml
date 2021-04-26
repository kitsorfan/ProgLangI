
(***************************************************************************
  Project     : Programming Languages 1 - Assignment 1 - Exercise LoopRooms
  Authors     : Stylianos Kandylakis el17088, 
                Kitsos Orfanopoulos el17025
  -----------
 ProgLangI 2021, ECE-NTUA
 ****************************************************************************
*)


(*@@@@@@@@@@@@@@@@@@- 1. Parse the file -@@@@@@@@@@@@@@@@@@*)
(* Coded by Stavros Aronis, modified by Nick Korasidis. Source: https://courses.softlab.ntua.gr/pl1/2013a/Exercises/countries.sml 
  Function that takes a string: path for a file, reads and returns a specific tuple*)
fun parse file =  
    let

      	val inStream = TextIO.openIn file     (* open the file and "put it" in inStream (note: in ML we do into variables, we have no variables) *)

        fun readLines acc =                   (* read *)
          let
            val newLineOption = TextIO.inputLine inStream
          in
            if newLineOption = NONE  (* NONE here means EOF*)
            then (List.rev acc)
            else  (readLines ( explode  (valOf newLineOption):: acc ))
        end;

        val grid = readLines []   (* call function readLines with empty list as parameter*)
        val grid2 = tl grid       (* get rid of the first subarray*)
        val M = length (hd grid) - 2 (*M is*)
        val N = length grid - 1
    in
   	    (N,M,grid2)
end;

(*@@@@@@@@@@@@@@@@@@- 2. W -@@@@@@@@@@@@@@@@@@*)
fun removeUseless (nil,a) = nil
|   removeUseless (doublelist,a) = 
    List.take(hd doublelist,a)::removeUseless(tl doublelist, a)




(**@@@@@@@@@@@@@@@@@@- FINAL FUNCTION-@@@@@@@@@@@@@@@@@@*)
(* Takes a sigle parameter, a text called inputFile, and returns the number of non-escapable rooms*)

fun loop_rooms inputFile = 
  let
    val inputTuple = parse inputFile    (*Calls parse that reads from file, return a tuple with 3 parameters: (n, m, doubleArray) *)
    val n = #1 inputTuple               (*n is the lenght of the maze*)
    val m = #2 inputTuple               (*m is the width of the maze*)
    val grid = #3 inputTuple            (*is the maze*)
    val cleanGrid =  removeUseless(grid,m)
   (* val first  =  (fn (x::y) => x) grid   *)
    (* val first  = (fn(a::b) => a) ((fn (x::y) => y) grid) *)
  in
     
    cleanGrid
  end;

(* Useless code, only for testing reasons 
 To test the code just type "sml <loop_rooms.sml" on Terminal*)
  loop_rooms "tests/maze1.txt"; 


