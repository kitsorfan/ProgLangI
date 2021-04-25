(* Some basic SML examples to copy 
    Also I have solved some exercises from the book 
*)


(* 
fun factorian n = 
    if n = 0 then 1
    else n * factorian(n-1);

factorian 5;
fun listsum S = 
    if null S then 0
    else hd S + listsum (tl S);

listsum [1, 2, 3, 10];

fun length S = 
    if null S then 0
    else 1 + length(tl S);

val x = length [1, 2, 3, 4, 5, 5, 11];
val y = length []; *)

(* fun reorder S = 
    if null S then nil
    else (reorder (tl S))@[hd S];

reorder [1, 2, 3, 4, 5];

fun cube(x:real) : real = 
    x*x*x;

cube 2.1; *)
(* 
fun fourth_auxilary (S, n) = 
    if n=4 then (hd S)
    else fourth_auxilary(tl S, (n+1));


fun fourth S =
    fourth_auxilary(S, 1);

fourth [1, 2 ,3 ,88 , 7]; *)

(* fun min_of_three (x, y, z) =
    if x < y then (
        if x < z then x 
        else z
    )
    else
    (
        if y < z then y 
        else z
        );

min_of_three(1, 2 , 5);
min_of_three(8, 2 , 5);
(* min_of_three(11, 22 , 5); *)

fun cut_the_second (x, y, z) = 
    (x, z);


cut_the_second (1,3, 8); *)
(* 
fun third_char S =
    List.nth((explode S), 2);

third_char("herlo"); *)

(* ASKISI 7 *)

(* fun cycle_1st S = 
    ((tl S)@[hd S]);

cycle_1st [1, 2, 4, 6, 8]; *)

(* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ *)




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
            if (x<y) then x::merge(xs, y::ys)
            else y::merge(ys, x::xs);

            
            val (x,y) = halve merge_list
       in
            merge(mergesort x, mergesort y)
        end;

mergesort([5,4,32,46,122,42,12]);




(***************************************************************************
  Project     : Programming Languages 1 - Assignment 1 - Exercise 1
  Author(s)   : <Author name> (<author mail>)
  Date        : April 08, 2013
  Description : Teh S3cret Pl4n
  -----------
  School of ECE, National Technical University of Athens.
*)

(* Input parse code by Stavros Aronis, modified by Nick Korasidis. *)
fun parse file =
    let
	(* A function to read an integer from specified input. *)
        fun readInt input = 
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

	(* Open input file. *)
    	val inStream = TextIO.openIn file

        (* Read an integer (number of countries) and consume newline. *)
	val n = readInt inStream
	val _ = TextIO.inputLine inStream

        (* A function to read N integers from the open file. *)
	fun readInts 0 acc = acc (* Replace with 'rev acc' for proper order. *)
	  | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
   	(n, readInts n [])
    end

(* Dummy solver & requested interface. *)
fun solve (n, sizelist) = (42, 42)
fun countries fileName = solve (parse fileName)
			 
(* Uncomment the following lines ONLY for MLton submissions.
val _ =
    let
        val (a, b) = countries (hd (CommandLine.arguments()))
    in
        print(Int.toString a ^ " " ^ Int.toString b ^ "\n") 
    end
*)