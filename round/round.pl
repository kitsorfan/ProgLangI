/*
********************************************************************************
  Project     : Programming Languages 1 - Assignment 2 - Exercise longest
  Authors     : Stylianos Kandylakis el17088, 
                Kitsos Orfanopoulos el17025
  -----------
 ProgLangI 2021, ECE-NTUA
 *******************************************************************************

>> TRANSLATING OUR SML SOLUTION:
---------------------------------
    This solutions follows the same steps descriped in our previous SML solution. Though it wasn't efficient enough for Prolog pattern matching.

Initial thoughts: We have to find the city with the minimum sum of distances from our initial state. 
On the same time we have to assure that the largest distance of individual cars 

Initial thoughts: We have to find the city from with the minimum sum of distances, where the car with maximum distance, has a distance at max one edge greater than the sum of all the other distances.

Initial Steps:
1. Parse the file (identify cities, cars, intialState)
2. Create all possible final States (list of lists)
3. For each final state find the distance from the initial state (list of lists). This is a list o distances
4. For every final-initial distance, find the sum of individual distances and the max individual distance
5. Check if sum and max is  legit, and create a list of legit sums.
6.  Find the min sum and its index in the list. This is your result.

These steps produce the wanted result, but doing them seperetaly is not efficient, thus we had to merge many functions together to reduce time and space.
We avoided to create lists of lists, by initially merging steps 2-3-4 then 4-5 and finally we merged step 6.

*/

% *@@@@@@@@@@@@@@@@@@- 1. Parse the file -@@@@@@@@@@@@@@@@@@*
% Based on: https://courses.softlab.ntua.gr/pl1/2019a/Exercises/read_colors_SWI.pl

% Main clause. Reads two lines and separates their elements
readInput(File, Cities, Cars, InitialState) :-
    open(File, read, Stream),               % open the file
    readLine(Stream, [Cities, Cars]),       % read first line
    readLine(Stream, InitialState).         % read second line

% Auxilary clause. Reads a line and seperates its elements. Returns a list.
readLine(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).



% @@@@@@@@@@@@@@@@@@- Auxilaries -@@@@@@@@@@@@@@@@@@*)

% Auxilary: calculate distance
distance(A,B,_,Answer):-
    A>=B,
    Answer is (A-B).
distance(A,B,City,Answer):-
    Answer is ((City-B)+A).

% Auxilary: give min of two numbers
giveMax(A,B,C):-
    A>B,
    C=A,!.
giveMax(_,B,C):-
    C=B.

% Auxilary: return Min and Index
giveMin(A,Ai,B,_,C,Ci):-
    A=<B,
    C=A,
    Ci=Ai.
giveMin(_,_,B,Bi,C,Ci):-
    C=B,
    Ci=Bi.

% @@@@@@@@@@@@@@@@@@- 2. Create a final state -@@@@@@@@@@@@@@@@@@*)
% Take a number, targetCity, and create a final state, a list with cars elements.
% ex. For targetCity=4 and cars=6 we create: [4,4,4,4,4,4]

createFinalList(_,0,[]).                         % end of recursion, return empty list
createFinalList(TargetCity,Cars,[TargetCity|Rest]):-   
    NewCars is (Cars-1),                        
    createFinalList(TargetCity,NewCars,Rest).     % we use cut because we want to find the first one possible


% @@@@@@@@@@@@@@@@@@- 3. Compare two lists - (subtract target state - current state) -@@@@@@@@@@@@@@@@@@
% Take two lists, the initial and a final state, and find their difference. Note that if a>b we just find a-b, else we find city-b+a
% ex. A. initial state [2,2,0,2] and final state [3,3,3,3] -> [1,1,3,1] 
%        B. initial state [2,2,0,2] and final state [0,0,0,0] -> [2,2,0,2]  (assume we have 4 cities)
%        Then it return the Max and Sum of that list

compareTwoLists([],[],_,Max,Sum,Max,Sum).
compareTwoLists([Target|Trest],[Current|Crest],Cities,CurrentMax,CurrentSum,Max,Sum):-
    distance(Target,Current,Cities,Answer),
    NewSum is CurrentSum+Answer,
    giveMax(CurrentMax,Answer,NewMax),
    compareTwoLists(Trest,Crest,Cities,NewMax,NewSum,Max,Sum).


% @@@@@@@@@@@@@@@@@@- 4. Merged Multifunction -@@@@@@@@@@@@@@@@@@
% This function is does multiple things. Takes many parameters and returns the final answer tuple

mergedFunction(0,_,_,_,Min,MinI,Min,MinI).
mergedFunction(AllCities,Cars,Initial,Cities,Min,MinI,FinalMin,FinalIndexMin):-
    NewCities is (AllCities-1), 
    createFinalList(NewCities,Cars,Temp),
    compareTwoLists(Temp,Initial,Cities,0,0,Maxy,Samy),
    2*Maxy-Samy < 2,!, % check validity of Max and Sum tuple
    giveMin(Samy,NewCities,Min,MinI,NewMin,NewMinI),

    % write(Initial),write(" "), write(Temp),write(" "),
    % write(" | "),
    % write(Maxy),
    % write(" "),
    % writeln(Samy),
    % writeln(NewMin),

    mergedFunction(NewCities,Cars,Initial,Cities,NewMin,NewMinI,FinalMin,FinalIndexMin),!.


% @@@@@@@@@@@@@@@@@@@@@@@@- MAIN FUNCTION -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
round(File,Min,MinI) :-
    readInput(File, Cities, Cars, InitialState),             % 1. Parse the file
    mergedFunction(Cities,Cars,InitialState,Cities,10002,0,Min,MinI),!.




% @@@@@@-- Testing--@@@@@@
% round('tests/r1.txt', Answer), writeln(Answer), fail.
% round('tests/r1.txt', Min,MinI), write(Min),write(" "), writeln(MinI), fail.