
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

        fun readInt input = 
        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

        fun readLines acc =                   (* read *)
          let
            val newLineOption = TextIO.inputLine inStream
          in
            if newLineOption = NONE  (* NONE here means EOF*)
            then (List.rev acc)
            else  (readLines ( explode  (valOf newLineOption):: acc ))
        end;

        val N = readInt inStream
        val M = readInt inStream
        val grid = readLines []   (* call function readLines with empty list as parameter*)
        val grid2 = tl grid       (* get rid of the first subarray*)
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
    (* val _ = print ("Who you gonna call "^Int.toString(i)^" "^Int.toString(j)^" "^Char.toString(value)^"\n") *)
    
  in 
    value
  end;

(*@@@@@@@@@@@@@@@@@@- 3. DoTheJob -@@@@@@@@@@@@@@@@@@*)
fun escapablePath (arr, i, j, n, m) = 
    let
      val element = Array2.sub (arr, i, j)
      (* val response = updateElement(arr, i, j, #"V") *)
      val response = if (element = #"E") then updateElement(arr, i, j, #"E") else updateElement(arr, i, j, #"V")
      (* val hi = print ("----> ["^Int.toString(i)^", "^Int.toString(j)^ "] of ["^Int.toString(n)^", "^Int.toString(m)^"]  had "^Char.toString(element)^", now has "^Char.toString(response)^"\n") *)

      fun checkElement (#"E") = updateElement(arr, i, j, #"E")
      | checkElement (#"V") = updateElement(arr, i, j,  #"V")
      | checkElement (#"L") = if (j=0) then updateElement(arr, i, j,  #"E") else escapablePath(arr, i, (j-1),n,m)
      | checkElement (#"R") = if (j=m) then updateElement(arr, i, j,  #"E") else escapablePath(arr, i, (j+1),n,m)
      | checkElement (#"U") = if (i=0) then updateElement(arr, i, j,  #"E") else escapablePath(arr, (i-1),j,n,m)
      | checkElement (#"D") = if (i=n) then updateElement(arr, i, j,  #"E") else escapablePath(arr, (i+1),j,n,m)   
      | checkElement (_) = #"B"
      
    in
      updateElement (arr, i,j,checkElement(element))
      
    end

fun nonEscapable (#"V") = 1
| nonEscapable (#"E") = 0
| nonEscapable(_) = 0


fun scanArray (arr, i, j, n, m, counter) = 
  let
    val currentElement = escapablePath(arr,i,j,n,m)
    val current = nonEscapable currentElement
    val newCounter = counter + current
    (* val hi = print ("["^Int.toString(i)^", "^Int.toString(j)^ "] of ["^Int.toString(n)^", "^Int.toString(m)^"]  element: "^Char.toString(currentElement)^", counter: "^Int.toString(newCounter)^"\n")  *)

  in
    if (j<m) then (scanArray(arr,i,(j+1),n,m,newCounter))
    else if (i<n) then (scanArray(arr,(i+1),0,n,m,newCounter))
    else newCounter
  end
  

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
    val response = scanArray (doubleArray, 0, 0, (n-1), (m-1),0)
  in
    (* (n, m, grid,cleanGrid, response) *)
    (* (n, m, cleanGrid) *)
  ( print (Int.toString(response)^"\n") )

  end;

(* Useless code, only for testing reasons 
 To test the code just type "sml <loop_rooms.sml" on Terminal*)
