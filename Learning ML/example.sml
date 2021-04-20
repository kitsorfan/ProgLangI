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