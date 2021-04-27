
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


fun updateElement (arr, i, j, value) = 
  let 
    val a = Array2.update (arr, i, j, value)
    val _ = print ("Who you gonna call "^Int.toString(i)^" "^Int.toString(j)^" "^Char.toString(value)^"\n")
    
  in 
    value
  end;

(*@@@@@@@@@@@@@@@@@@- 3. DoTheJob -@@@@@@@@@@@@@@@@@@*)
fun escapablePath (arr, i, j, n, m) = 
    let
      val element = Array2.sub (arr, i, j)
      val response = updateElement(arr, i, j, #"V")
      val hi = print ("["^Int.toString(i)^", "^Int.toString(j)^ "] of ["^Int.toString(n)^", "^Int.toString(m)^"]  had "^Char.toString(element)^", now has "^Char.toString(response)^"\n")

      fun checkElement (#"E",_,_) = updateElement(arr, i, j, #"E")
      | checkElement (#"V",_,_) = updateElement(arr, i, j,  #"V")
      | checkElement (#"L",_,0) = updateElement(arr, i, j, #"E")
      | checkElement (#"R",_,a) = if (j=m) then updateElement(arr, i, j,  #"E") else escapablePath(arr, i,(j+1),n,m)
      | checkElement (#"U",0,_) = updateElement(arr, i, j, #"E")
      | checkElement (#"D",b,_) = if (b=n) then updateElement(arr, i, j, #"E") else escapablePath(arr, (i+1),j,n,m)      
      | checkElement (#"L",_,_) = escapablePath(arr, i,(j-1),n,m)
      | checkElement (#"U",_,_) = escapablePath(arr, (i-1),j,n,m)

            
    in
      checkElement(element,2,2)
      
    end

        (* if ((i+1)=n) then 
          ( if ((j+1)=m) then 
            "#V"
          else
            findEscapableRooms(arr, 0,j+1,n,m)
          )
        else
          findEscapableRooms(arr,i+1,j,n,m) *)

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

    val doubleArray = Array2.fromList cleanGrid
    val response = escapablePath (doubleArray, 2, 2, (n-1), (m-1))
  in
    response
  end;

(* Useless code, only for testing reasons 
 To test the code just type "sml <loop_rooms.sml" on Terminal*)
  loop_rooms "tests/maze1.txt"; 


(* 
  (* //----- ------ right door ------------- *)
        else if (element="#R") then (  
          if (j=(m-1))  then
          (
            Array2.update(arr, i, j, "#E");
            response = "#E"
          )
          else (
              response = escapablePath(arr, i, j+1, n, m);
              Array2.update(arr, i, j, response)
            )
          )
       (* //------------ up door ------------- *)
        else if (element="#U") then (  
          if (i=0)  then
          (
            Array2.update(arr, i, j, "#E");
            response = "#E"
          )
          else (
              response = escapablePath(arr, i-1, j, n, m);
              Array2.update(arr, i, j, response)
            )
          )
          (* //------------ up door ------------- *)
        else (  
          if (i=n-1)  then
          (
            Array2.update(arr, i, j, "#E");
            response = "#E"
          )
          else (
              response = escapablePath(arr, i+1, j, n, m);
              Array2.update(arr, i, j, response)
            )
          ) *)


          (*
        let 
        fun giveResponse x =
          x= if (element = "#E") then (
            "#E"
          )
          else (if element ="#V") then (
            "#V"
          )

        in 

        end 
        
        
      response = if (element = "#E") then "#E"
      else if (element = "#V") then "#V"
      else (
        Array2.update(arr, i, j, "#V");
        (* //----------- left door ------------- *)
        if (element="#L") andalso (j=0) then (  
          (
            Array2.update(arr, i, j, "#E");
            "#E"
          )
          else (
              val newresponse = escapablePath(arr, i, j-1, n, m);
              Array2.update(arr, i, j, newresponse);
              newresponse

            )
          )
        (* //----- ------ right door ------------- *)
        else if (element="#R") then (  
          if (j=(m-1))  then
          (
            Array2.update(arr, i, j, "#E");
            "#E"
          )
          else (
              response = escapablePath(arr, i, j+1, n, m);
              Array2.update(arr, i, j, response);
              response
            )
          )
       (* //------------ up door ------------- *)
        else if (element="#U") then (  
          if (i=0)  then
          (
            Array2.update(arr, i, j, "#E");
            response = "#E"
            "#E";
          )
          else (
              response = escapablePath(arr, i-1, j, n, m);
              Array2.update(arr, i, j, response)
              response
            )
          )
          (* //------------ up door ------------- *)
        else (  
          if (i=n-1)  then
          (
            Array2.update(arr, i, j, "#E");
            response = "#E"
          )
          else (
              response = escapablePath(arr, i+1, j, n, m);
              Array2.update(arr, i, j, response)
            )
          )
      )
      *)