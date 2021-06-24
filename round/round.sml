(***************************************************************************
  Project     : Programming Languages 1 - Assignment 3 - Exercise Round
  Authors     : Stylianos Kandylakis el17088, 
                Kitsos Orfanopoulos el17025
  -----------
 ProgLangI 2021, ECE-NTUA
 ****************************************************************************
*)



fun parse file =
    let
        val inStream = TextIO.openIn file       (* Firstly, open the file*)

        (* A function to read an integer from specified input. *)
        fun readInt input = 
        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
       
        (* A function to read N (parameter) days from the open file. *)
        fun readCars 0 acc = rev acc             
        |   readCars i acc = readCars (i - 1) (readInt inStream :: acc)

        val cities = readInt inStream           (* Read the days *)
        val cars = readInt inStream             (* Read the hospitals*)
        val _ = TextIO.inputLine inStream       (* Consume a new line *)
    in
    	(cities, cars, readCars cars [])   (* returned tuple (days, hospitals, discharges). Note: that discharges calls the function defined before with parameter days *)
    end;









(*@@@@@@@@@@@@@@@@@@- FINAL FUNCTION -@@@@@@@@@@@@@@@@@@*)
(* Takes a sigle parameter, a text called inputFile, *)

fun round inputFile = 
  let
    val inputTuple = parse inputFile         (* Calls parse that reads from file, return a tuple with 3 parameters: (cities, cars, positions). *)
      val cities = #1 inputTuple               (* days *)
      val cars = #2 inputTuple          (* hospitals *)
      val positions = #3 inputTuple         (* discharges: how many leave the hospitals (or die) everyday. *)
    
  in
    (* (print(Int.toString(answer)^"\n"))     We print the result     *)
    positions

  end;

  (* testing *)

print("\n\n\n\n\n\n\n");
round "tests/r1.txt"; 
print("\n\n\n\n\n\n\n");

(* this is not a valid command. It cannot be compiled. Thought it terminates the interactive environment allowing as to run it again if we change the code, I guess it does exit in some way*)
exit;