
(***************************************************************************
  Project     : Programming Languages 1 - Assignment 1 - Exercise LoopRooms
  Authors     : Stylianos Kandylakis el17088, 
                Kitsos Orfanopoulos el17025
  -----------
 ProgLangI 2021, ECE-NTUA
 ****************************************************************************
*)

(*
  Idea: 
    This program is an adaptation of the equivalant C++ solution. The main idea is the same. We run a DFS to find an exit, or
    to find a cycle, thus these rooms are not escapable. Then we continue the scan and DFS for the nodes that we didn't visit at all.
    We will count the non escapable rooms.

  Main steps:
    1. We parse the file. After that we have N and M and a list of lists, our maze.
    2. We "clean" the maze, to remove special characters.
    3. We convert the list of lists to a double array.
    4. We scan the whole array to find escapable rooms. We count the non escapable.
    5. We print the result.

*)


(*@@@@@@@@@@@@@@@@@@- 1. Parse the file -@@@@@@@@@@@@@@@@@@*)
(* Coded by Stavros Aronis, modified by Nick Korasidis. Source: https://courses.softlab.ntua.gr/pl1/2013a/Exercises/countries.sml 
  Function that takes a string: path for a file, reads and returns a specific tuple (n, m, list of lists)*)
fun parse file =  
    let

      	val inStream = TextIO.openIn file     (* open the file and "put it" in inStream (note: in ML we do into variables, we have no variables) *)

        (* A function to read an integer from specified input. We will use it twice *)
        fun readInt input = 
          Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

        (* A function to read a line as a string, convert that string to list and read the next one until EOF. It returns a list of lists of strings. *)
        fun readLines acc =                  
          let
            val newLineOption = TextIO.inputLine inStream
          in
            if newLineOption = NONE  (* NONE here means something like EOF*)
            then (List.rev acc)  (* reverse inner list *)
            else  (readLines ( explode  (valOf newLineOption):: acc )) (* Explodes string to list of characters. Calls function for the next line, until EOF*)
        end;

        val N = readInt inStream  (* Read N *)
        val M = readInt inStream  (* Read M *)
        val grid = readLines []   (* call function readLines with empty list as parameter*)
        val properGrid = tl grid  (* get rid of the first sublist*)
    in
   	    (N,M,properGrid)          (* Return tuple *)  
end;


(*@@@@@@@@@@@@@@@@@@- 2. Remove Useless -@@@@@@@@@@@@@@@@@@*)
(* Function that removes useless element of every list*)

fun removeUseless (nil,a) = nil           (* Parameter a means how many of each we will keep. We will keep M (the width of maze). Note: when we explode  the string we unintentinally take "\r" and "\n" characters*)
|   removeUseless (doublelist,a) = 
    List.take(hd doublelist,a)::removeUseless(tl doublelist, a) (* List.take keeps only a first elements of a lists*)



(*@@@@@@@@@@@@@@@@@@- 3. Update Element (auxilary) -@@@@@@@@@@@@@@@@@@*)
(* Function that takes a double array, indexes i and j, and a character value. It updates arr[i,j]=value and returns this value *)

fun updateElement (arr, i, j, value) = 
  let 
    val a = Array2.update (arr, i, j, value) (* update arr[i,j] = value *)
  in 
    value
  end;

(*@@@@@@@@@@@@@@@@@@- 4. Escapable Path -@@@@@@@@@@@@@@@@@@*)
(* Function that, given a double array and an initial index [i,j], runs a DFS until it finds a circle (already visited node) or an exit
  We mark each node with these letters:
  E - escapable. This room can lead to exit
  V - visited. This rooms has been reached before. We are not sure if it is  escapable. In the end of every all visited doors that didn't marked with E are considered to be unescapable
  L - left. This door leads left.
  R - Right. >>
  U - up.    >>
  D - down.  >>
*)

fun escapablePath (arr, i, j, n, m) = 
    let
      val element = Array2.sub (arr, i, j)  (* element = arr[i,j] *)
      val response = if (element = #"E") then #"E" else updateElement(arr, i, j, #"V") (* If it not Escapable (E) s, we set current node as visites*)

      (* function that checks the element, aka the arr[i,j] *)
      fun checkElement (#"E") = updateElement(arr, i, j, #"E")  (* If door is already Escapable, we marked it again, returning E as the answer to previous recursions. Recursion stops.*)
      | checkElement   (#"V") = updateElement(arr, i, j,  #"V") (* If door is already Visited, we marked it again, returning V as the answer to previous recursions. Recursion stops*)
      | checkElement   (#"L") = if (j=0) then updateElement(arr, i, j,  #"E") else escapablePath(arr, i, (j-1),n,m) (* If door is Left then if it near the left side it is escapable and the recursion stops. Else we continue the recursion visiting the left door*)
      | checkElement   (#"R") = if (j=m) then updateElement(arr, i, j,  #"E") else escapablePath(arr, i, (j+1),n,m) 
      | checkElement   (#"U") = if (i=0) then updateElement(arr, i, j,  #"E") else escapablePath(arr, (i-1),j,n,m)
      | checkElement   (#"D") = if (i=n) then updateElement(arr, i, j,  #"E") else escapablePath(arr, (i+1),j,n,m)   
      | checkElement    (_) = #"B" (* Useless. Only to avoid nonexhaustive error. A proper input will never lead to this *)
      
    in
      updateElement (arr, i,j,checkElement(element)) (* We call checkElement for our current [i,j]. Note that we also have to updateElement, so when the recursion return to our current [i,j] it will update it. *)
    end

(*@@@@@@@@@@@@@@@@@@- 5. Check escapability (auxilary) -@@@@@@@@@@@@@@@@@@*)
(* Simple function that given a character V or E returns 1 or 0 respectivelly. "1" is used to count the nonescapable rooms *)

fun nonEscapable (#"V") = 1
| nonEscapable (#"E") = 0
| nonEscapable(_) = 0 (* Useless. Only to avoid nonexhaustive error. A proper input will never lead to this *)


(*@@@@@@@@@@@@@@@@@@- 6. Escapable Path -@@@@@@@@@@@@@@@@@@*)
(* Even if function 4 is the most important one this function calls funtion 4. Because DFS can stop when it finds an escapable or a visited node, there can be not visited nodes.
  Thus we need  to scan the whole double array. Each time we finish a DFS we check if the current node (from which the DFS  started) is visited. If so we add it to our counter. 
  Note that, just like C++ program, when we say run the DFS it doesn't mean that we will run the whole DFS. If  the node is already visited then is just O(1) instruction.
  *)

fun scanArray (arr, i, j, n, m, counter) = 
  let
    val currentElement = escapablePath(arr,i,j,n,m) (* Run the DFS for our current node. Expected answers: V or E*)
    val current = nonEscapable currentElement       (* if (currentElement=='E' then current = 0 else current = 1*)
    val newCounter = counter + current              (* Counter+=current *)
  in
    if (j<m) then (scanArray(arr,i,(j+1),n,m,newCounter))       (* if j<m then we can scan j+1 element *)
    else if (i<n) then (scanArray(arr,(i+1),0,n,m,newCounter))  (* else we have to change  row*)
    else newCounter                                             (* if there no rows left then we have finished the scan*) 
  end
  

(**@@@@@@@@@@@@@@@@@@- FINAL FUNCTION-@@@@@@@@@@@@@@@@@@*)
(* Takes a sigle parameter, a text called inputFile, and returns the number of non-escapable rooms*)

fun loop_rooms inputFile = 
  let
    val inputTuple = parse inputFile    (*Calls parse that reads from file, return a tuple with 3 parameters: (n, m, doubleArray) *)
      val n = #1 inputTuple               (*n is the lenght of the maze*)
      val m = #2 inputTuple               (*m is the width of the maze*)
      val grid = #3 inputTuple            (*is the maze. A list of lists. Note that grid contains useless special characters so we have to "clean" it*)
      
    val cleanGrid =  removeUseless(grid,m)                        (* grid without special characters such as "\r" or "\n" *)
    val doubleArray = Array2.fromList cleanGrid                   (* convert list of lists to a double array, that is indexed. See also: https://smlfamily.github.io/Basis/array2.html*)
    val response = scanArray (doubleArray, 0, 0, (n-1), (m-1),0)  (* Scan the array to get the final result. Note that we send (n-1) and (m-1), because array start from [0,0]*)
  in
    (print (Int.toString(response)^"\n") ) (* Print the result*)
  end;

(* Useless code, only for testing reasons 
 To test the code just type "sml <loop_rooms.sml" on Terminal*)
 
(* loop_rooms "tests/fairmaze.in2" *)