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
    This solutions follows the same steps descriped in our previous SML solution.

*/

% *@@@@@@@@@@@@@@@@@@- 1. Parse the file -@@@@@@@@@@@@@@@@@@*
% Based on: https://courses.softlab.ntua.gr/pl1/2019a/Exercises/read_colors_SWI.pl

% Main clause. Reads two lines and separates their elements
readInput(File, Cities, Cars, InitialState) :-
    open(File, read, Stream),               % open the file
    readLine(Stream, [Cities, Cars]),   % read first line
    readLine(Stream, InitialState).          % read second line

% Auxilary clause. Reads a line and seperates its elements. Returns a list.
readLine(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).


% @@@@@@@@@@@@@@@@@@- 2. Create a final state -@@@@@@@@@@@@@@@@@@*)
% Take a number, targetCity, and create a final state, a list with cars elements.
% ex. For targetCity=4 and cars=6 we create: [4,4,4,4,4,4]

createFinalList(_,0,[]).                         % end of recursion, return empty list
createFinalList(TargetCity,Cars,[Head|Rest]):-   
    Head = TargetCity,
    NewCars is (Cars-1),                        
    createFinalList(TargetCity,NewCars,Rest),!. % we use cut because we want to find the first one possible


% @@@@@@@@@@@@@@@@@@- 3. Compare two lists - (subtract target state - current state) -@@@@@@@@@@@@@@@@@@
% Take two lists, the initial and a final state, and find their difference. Note that if a>b we just find a-b, else we find city-b+a
% ex. A. initial state [2,2,0,2] and final state [3,3,3,3] -> [1,1,3,1] 
%        B. initial state [2,2,0,2] and final state [0,0,0,0] -> [2,2,0,2]  (assume we have 4 cities)

% Auxilary distance
distance(A,B,_,Answer):-
    A>=B,
    Answer is (A-B).
distance(A,B,City,Answer):-
    Answer is (City-B+A).


compareTwoLists([],[],_,[]).
compareTwoLists([Target|Trest],[Current|Crest],Cities,[Answer|Arest]):-
    distance(Target,Current,Cities,Answer),
    compareTwoLists(Trest,Crest,Cities,Arest),!.


% @@@@@@@@@@@@@@@@@@- 4. Find the max and the sum of a list -@@@@@@@@@@@@@@@@@@
% Find the maxiumum and the sum of a list
%    ex. [4,2,1,4,8,5] -> (max, sum) = (8,24)

% % auxilary
% giveMax(A,B,C):-
%     A>B,
%     C=A.
% giveMax(_,B,C):-
%     C=B.


maxAndSum([],CurrentMax,CurrentSum,Max,Sum):-
    Max=CurrentMax,
    Sum=CurrentSum.
maxAndSum([Head|Rest],CurrentMax,CurrentSum,Max,Sum):-
    Head>CurrentMax,            % if then
    NewSum is CurrentSum+Head,
    maxAndSum(Rest,Head,NewSum,Max,Sum),!.
maxAndSum([Head|Rest],CurrentMax,CurrentSum,Max,Sum):-
    NewSum is CurrentSum+Head,
    maxAndSum(Rest,CurrentMax,NewSum,Max,Sum),!.

% @@@@@@@@@@@@@@@@@@- 5. Merged Multifunction -@@@@@@@@@@@@@@@@@@
% This function is does multiple things. Takes many parameters and returns the final answer tuple


% auxilary
checkMax(Max,Sum,Result):-
    Check is (2*Max-Sum),
    Check>=2,
    Result is 80008,!. % a very large number. By convention the maximum distance can be 10.000 (maximum number of cities)
checkMax(_,Sum,Result):-
    Result is Sum.

mergedFunction(0,_,_,_,Min,MinI,FinalMin,FinalIndexMin):-
    FinalMin is Min,
    FinalIndexMin is MinI.
mergedFunction(AllCities,Cars,Initial,Cities,Min,_,FinalMin,FinalIndexMin):-
    NewCities is (AllCities-1), 
    createFinalList(NewCities,Cars,Temp),
    compareTwoLists(Temp,Initial,Cities,Compared),
    maxAndSum(Compared,0,0,Maxy,Samy),
    write(Initial),write(" "), write(Temp),write(" "),
    write(Compared),
    write(" | "),
    write(Maxy),
    write(" "),
    write(Samy),

    checkMax(Maxy,Samy,Result),
    write(" ---> "),
    writeln(Result),
    Result=<Min,!,
    mergedFunction(NewCities,Cars,Initial,Cities,Result,NewCities,FinalMin,FinalIndexMin),!.

mergedFunction(AllCities,Cars,Initial,Cities,Min,MinI,FinalMin,FinalIndexMin):-
    NewCities is (AllCities-1), 
    createFinalList(NewCities,Cars,Temp),
    compareTwoLists(Temp,Initial,Cities,Compared),
    maxAndSum(Compared,0,0,Maxy,Samy),
    write(Initial),write(" "), write(Temp),write(" "),
    write(Compared),
    write(" | "),
    write(Maxy),
    write(" "),
    write(Samy),

    checkMax(Maxy,Samy,Result),
    write(" ---> "),
    writeln(Result),
    mergedFunction(NewCities,Cars,Initial,Cities,Min,MinI,FinalMin,FinalIndexMin).


% @@@@@@@@@@@@@@@@@@@@@@@@- MAIN FUNCTION -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
round(File,Min,MinI) :-
    readInput(File, Cities, Cars, InitialState),             % 1. Parse the file
    mergedFunction(Cities,Cars,InitialState,Cities,80008,0,Min,MinI),!.

% --Check the Answer
% round('tests/r1.txt', Answer), writeln(Answer), fail.
% round('tests/r2.txt', Min,MinI), write(Min),write(" "), writeln(MinI), fail.