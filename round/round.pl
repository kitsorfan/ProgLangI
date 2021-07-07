          
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
    A>=B,!,
    Answer is (A-B).
distance(A,B,City,Answer):-
    Answer is ((City-B)+A).

% Auxilary: give min of two numbers
giveMax(A,B,C):-
    A>B,
    C=A,!.
giveMax(A,B,C):-
    A=<B,
    C=B.

% Auxilary: return Min and Index
giveMin(A,Ai,B,_,C,Ci):-
    A<B,
    C=A,
    Ci=Ai.
giveMin(_,_,B,Bi,C,Ci):-
    C=B,
    Ci=Bi.


checkDistance(Max,Sum,Result):-
    2*Max-Sum < 2, % check validity of Max and Sum tuple
    Result is Sum.
checkDistance(_,_,10002).



% @@@@@@@@@@@@@@@@@@- 3. Compare two lists - (subtract target state - current state) -@@@@@@@@@@@@@@@@@@
% Take two lists, the initial and a final state, and find their difference. Note that if a>b we just find a-b, else we find city-b+a
% ex. A. initial state [2,2,0,2] and final state [3,3,3,3] -> [1,1,3,1] 
%        B. initial state [2,2,0,2] and final state [0,0,0,0] -> [2,2,0,2]  (assume we have 4 cities)
%        Then it return the Max and Sum of that list

compareWithFinal(_,[],_,Max,Sum,Max,Sum).
compareWithFinal(FinalCity,[Current|Crest],Cities,CurrentMax,CurrentSum,Max,Sum):-
    distance(FinalCity,Current,Cities,Answer),
    NewSum is CurrentSum + Answer,
    giveMax(CurrentMax,Answer,NewMax),
    compareWithFinal(FinalCity,Crest,Cities,NewMax,NewSum,Max,Sum),!.


% @@@@@@@@@@@@@@@@@@- 4. Merged Multifunction -@@@@@@@@@@@@@@@@@@
% This function is does multiple things. Takes many parameters and returns the final answer tuple

% mergedFunction(Cities,_,_,Cities,Min,MinI,Min,MinI).
% mergedFunction(CityIndex,Cars,Initial,Cities,Min,MinI,FinalMin,FinalIndexMin):-
%     NewCityIndex is (CityIndex+1), 
%     compareWithFinal(CityIndex,Initial,Cities,0,0,Maxy,Samy),
%     2*Maxy-Samy < 2, % check validity of Max and Sum tuple
%     giveMin(Samy,CityIndex,Min,MinI,NewMin,NewMinI),

%     % write(Initial),write(" "),write(" now checking "), write(CityIndex),write(" "),
%     % write(" | "),
%     % write(Maxy),
%     % write(" "),
%     % write(Samy),
%     % write(" ---> "),
%     % writeln(NewMin),

%     mergedFunction(NewCityIndex,Cars,Initial,Cities,NewMin,NewMinI,FinalMin,FinalIndexMin),!.

createCityTable(0,[]).
createCityTable(Cities,[0|Rest]):-
    NewCities is Cities-1,
    createCityTable(NewCities,Rest).

invertTable([],FinalInverted,FinalInverted).
invertTable([Init|InitRest],Inverted,FinalInverted):-
    nth0(Init,Inverted,X,R),
    NewX is X+1,
    nth0(Init,NewInverted,NewX,R),
    invertTable(InitRest,NewInverted,FinalInverted),!.

twoIndexGame(_, _, [],_, _, _, _, FinalMin, FinalMinI, FinalMin, FinalMinI).                   % MainIndex == AllCities : end of recursion
twoIndexGame(MainIndex, AllCities, CityTable,[_|DoubleRest], AllCities, Sum, AllCars, Min, MinI, FinalMin, FinalMinI):-    % MaxIndex == AllCities : MaxIndex = 0 (pacman effect)
    twoIndexGame(MainIndex, 0, CityTable,DoubleRest, AllCities, Sum, AllCars, Min, MinI, FinalMin, FinalMinI).  
twoIndexGame(MainIndex, MainIndex, CityTable,[_|DoubleRest], AllCities, Sum, AllCars, Min, MinI, FinalMin, FinalMinI):-    % MaxIndex == MainIndex : MaxIndex++
    NewMaxIndex is MainIndex+1,
    twoIndexGame(MainIndex, NewMaxIndex, CityTable,DoubleRest, AllCities, Sum, AllCars, Min, MinI, FinalMin, FinalMinI).
        
twoIndexGame(MainIndex, MaxIndex, CityTable,[0|DoubleRest], AllCities, Sum, AllCars, Min, MinI, FinalMin, FinalMinI):-     % MaxIndex points to zero : MaxIndex++
    NewMaxIndex is MaxIndex+1,
    twoIndexGame(MainIndex, NewMaxIndex, CityTable,DoubleRest, AllCities, Sum, AllCars, Min, MinI, FinalMin, FinalMinI).

twoIndexGame(MainIndex, MaxIndex, [CurrentCars|CityTableRest],DoubleTable, AllCities, Sum, AllCars, Min, MinI, FinalMin, FinalMinI):-     % Pointers in normal positions
    NewSum is (Sum + AllCars - AllCities*CurrentCars ),
    distance(MainIndex, MaxIndex, AllCities, MaxDistance),
    % write(Sum),write(" "), write(MaxDistance),write(" "), write(MainIndex),write(" "), write(MaxIndex),write(" "), writeln(CurrentCars),
    checkDistance(MaxDistance,NewSum,Result),
    giveMin(Result,MainIndex,Min,MinI,NewMin,NewMinI),
    NewMainIndex is MainIndex+1,
    twoIndexGame(NewMainIndex, MaxIndex, CityTableRest,DoubleTable, AllCities, NewSum, AllCars, NewMin, NewMinI, FinalMin, FinalMinI),!.

    

% aggregate(count, member(X,[2, 2, 3,2 , 43, 2, 3, 2]), R).

% @@@@@@@@@@@@@@@@@@@@@@@@- MAIN CLAUSE -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
round(File,Min,MinI) :-
    readInput(File, Cities, Cars, InitialState),             % 1. Parse the file
    compareWithFinal(0,InitialState,Cities,0,0,_,Samy),
    createCityTable(Cities,EmptyCityTable),
    invertTable(InitialState,EmptyCityTable,CityTable),
    % writeln(CityTable),
    % mergedFunction(0,Cars,InitialState,Cities,10002,0,Min,MinI),
    % write(Min),write(" "),writeln(MinI),
    append(CityTable,CityTable,DoubleTable),!,
    % writeln(DoubleTable),
    DoubleTable = [_|Rest1],
    CityTable = [_|T],
    twoIndexGame(1, 2, T, Rest1, Cities, Samy, Cars, Samy, 0, Min, MinI),!.
    % write(FinalMin),write(" "),writeln(FinalMinI),
    



% @@@@@@-- Testing--@@@@@@
% round('tests/r31.txt', Min,MinI), write(Min),write(" "), writeln(MinI),
%    statistics(walltime, [NewTimeSinceStart | [ExecutionTime]]),
%    write('Execution took '), write(ExecutionTime), write(' ms.'), nl.

% @@@@@@-- Testing--@@@@@@
% round('tests/r1.txt', Answer), writeln(Answer), fail.
% round('tests/r1.txt', Min,MinI), write(Min),write(" "), writeln(MinI), fail.