(* usefull functions for lists *)



(* //Split the list to two lists of even and odds *)
fun split [] = ([], [])   
  | split [x] = ([x], [])  
  | split (x1::x2::xs) = 
               let 
                 val (ys, zs) = split xs
               in 
                ((x1::ys), (x2::zs))
              end;
(* FALSE	 *)



(* // number of elements of a list (or length) *)

fun numel nil = 0 
|   numel (x::xs) = 1 + numel (xs);


(* //sum of elements in a list  *)

fun sumel nil = 0 
|   sumel (x::xs) = x + sumel (xs);

(* ΑΛΛΙΩΣ  *)

fun sumlist xs =
    let fun loop [] sum = 0
         |  loop (y::ys) sum = loop ys sum+y 
    in loop xs 0                                   (*(//ξεκινάμε με λίστα και μηδενικό sum)*)
    end;

(* //add number to each element of list *)


fun addnum list number =
let 
val n = number
fun addn [] = [] 
 |  addn (x::xs) = (x+n)::addn(xs)
in 
addn list
end

(* ΑΛΛΙΩΣ (με map από List library ¨η σκέτο) *)

fun addnum num list  =  List.map  (fn num=>num+2)  (list); 
       



































Nested definitions

//example sort descendong order:

fun sort nil = nil 
 |  sort (h::t) = 
  let 
    fun insert(i,nil) = [i]
     |   insert(i,h::t) = if i>h then i::h::t else h::insert(i,t)

  in
 insert(h,sort t) 
 end;




fun Myf nil = nil
|   Myf (x1::(x2::t) ) = 
let 
fun mf (i,nil) = [i]
 |  mf (i, x1::x2::t) = if (not(i=0)) then (x2+2)::(x1-1)::t  else x1::(x2::mf(i ,(x2::t)))
in 
mf(x2, Myf (x2::t) ) 
end;



















fun sort nil = nil 
 |  sort (x1::x2::t,sum) = 
  let 
    fun insert(i,nil , sum) = [i]
     |  insert(i,x1::x2::t,sum ) = if (i=0) then (x1+2)::(x2-1)::t  else  x2::insert(i,x2::t,sum+1)

  in
 insert(x2,sort x2::t ,sum) 
 end;




Για να βρίσκεις χρόνο που τρέχει

fun time_it (action, arg) = let
        val timer = Timer.startCPUTimer ()
        val _ = action arg
        val times = Timer.checkCPUTimer timer
    in
        Time.+ (#usr times, #sys times)
    end

fun r x = print ("Corona with input:"^ x ^" takes " ^ Time.toString (time_it ([*****], x)) ^ " seconds.\n");

Στο [*****] βάζετε το όνομα της συνάρτησης που της δίνετε σαν όρισμα το inputfile. Και καλείτε την r με όρισμα το inputfile: r "coronagraph.in12";























