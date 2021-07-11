          
/*
********************************************************************************
  Project     : Programming Languages 1 - Assignment 2 - Exercise longest
  Authors     : Stylianos Kandylakis el17088, 
                Kitsos Orfanopoulos el17025
  -----------
 ProgLangI 2021, ECE-NTUA
 *******************************************************************************

>> TRYING TO TRANSLATE SML SOLUTION:
---------------------------------
    At first we tried to translate the SML solution. Doing that succesfully we found out that it wasn't efficient enough. We did many modifications, nevertheless we couldn't pass the final.

Initial thoughts: We have to find the city from with the minimum sum of distances, where the car with maximum distance, has a distance at max one edge greater than the sum of all the other distances.

New Approach:   We create an inverted list showing how many cars are in every city (initial list shows where everey car is).
                With that list, and knowing the initial sum of distances from the zero final state, we can move two pointers (one main, and one showing next to the main) updating every time the sum and the max.

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



% @@@@@@@@@@@@@@@@@@- 2. Auxilaries -@@@@@@@@@@@@@@@@@@*)

% Auxilary: give max of two numbers. C is the result
giveMax(A,B,C):-    
    A>B,
    C=A,!.              % not sure if this cut (!) speeds up. It does no harm though.
    giveMax(A,B,C):-
    A=<B,
    C=B.

% Auxilary: give Min and its Index
% Ai, is the index of A
giveMin(A,Ai,B,_,C,Ci):-
    A<B,
    C=A,
    Ci=Ai.
giveMin(_,_,B,Bi,C,Ci):-
    C=B,
    Ci=Bi.

% Auxilary: calculate the distance
% Final: the final city, Initial: the initial city, AllCities: total number of cities
distance(Final,Initial,_,Answer):-          % If Final>=Initial then Final-Initial
    Final>=Initial,!,                       % not sure if this cut (!) speeds up. It does no harm though.
    Answer is (Final-Initial).
distance(Final,Initial,AllCities,Answer):-  % Else AllCities-Final + Initial (Pacman effect)
    Answer is ((AllCities-Initial)+Final).

% Auxilary: check validity of Max and Sum tuple
% (Sum-Max) + 1 <= Max

checkDistance(Max,Sum,Result):- % If valid the result is sum (sum is valid)
    2*Max-Sum < 2, 
    Result is Sum.
checkDistance(_,_,10002).       % else result is 10002 (a very large number, larger than cities limit)



% @@@@@@@@@@@@@@@@@@- 3. Compare two lists - (subtract target final state - current state) -@@@@@@@@@@@@@@@@@@
% This clause is used only once, at the begging to find the sum and the max distance from the state [0,0,...]
% Take two lists, the initial and a final state, and find their difference. 
% ex. 1. initial state [2,2,0,2] and final state [3,3,3,3] -> [1,1,3,1] 
%     2. initial state [2,2,0,2] and final state [0,0,0,0] -> [2,2,0,2]  (assume we have 4 cities)
%        Then it returns the Max and Sum of that list


compareWithFinal(_,[],_,Max,Sum,Max,Sum).           % If list is empty return Max = CurrentMax, Sum = CurrentSum
compareWithFinal(FinalCity,[Current|Crest],Cities,CurrentMax,CurrentSum,Max,Sum):-
    distance(FinalCity,Current,Cities,Answer),
    NewSum is CurrentSum + Answer,
    giveMax(CurrentMax,Answer,NewMax),
    compareWithFinal(FinalCity,Crest,Cities,NewMax,NewSum,Max,Sum),!.



% @@@@@@@@@@@@@@@@@@- 4. Create City Table -@@@@@@@@@@@@@@@@@@
% Create invert table. Given the sorted initial state, a list showing where every car is, we 
% will create the CityTable list to show how many cars are in every city. 
% ex.   Initial State:              [2, 0, 2, 2]   (Cities=5)
%       CityTable (Final):  [1, 0, 3, 0, 0]
%   FinalInverted list means that there is 1 car at city 0, and 3 cars at city 2
% To do so we need a sorted 

cityTable(AllCities,AllCities,[],Count,[Count]).
cityTable(Index,AllCities,[Index|InitialRest],Count,Final):-
    NewCount is Count+1,
    cityTable(Index,AllCities,InitialRest,NewCount,Final).
cityTable(Index,AllCities,Initial,Count,[Count|FinalRest]):-
    NewIndex is Index + 1,
    cityTable(NewIndex, AllCities, Initial,0,FinalRest).
    


% @@@@@@@@@@@@@@@@@@- 5. Two Index Game -@@@@@@@@@@@@@@@@@@
% This is the most important clause of this solution.
% We take the city Table from the previous clause.
% We have two pointers, the main shows the current element of the CityTable, the other shows the max in that CityTable (actually we use a DoubleTable-see below-to avoid the usage of nth0 clause)
% In every step we move the main pointer to the right. The max pointer will point to the next, on the right of main pointer, non zero element.
% We begin scanning the CityTable knowing the sum and the max. 
% We update the sum in every step: NewSum = Sum + AllCars - AllCities*CityTable[i], i is main pointer
% Each time we check the validity of that sum, and we update the min as well
% When the scan is over we take the final min 


twoIndexGame(_, _, [],_, _, _, _, FinalMin, FinalMinI, FinalMin, FinalMinI).     % MainIndex == AllCities : end of recursion. We take final Min and index of Min
twoIndexGame(MainIndex, AllCities, CityTable,[_|DoubleRest], AllCities, Sum, AllCars, Min, MinI, FinalMin, FinalMinI):-   % MaxIndex == AllCities : MaxIndex = 0 (pacman effect)
    twoIndexGame(MainIndex, 0, CityTable,DoubleRest, AllCities, Sum, AllCars, Min, MinI, FinalMin, FinalMinI).            % note that only the index changes, the DoubleTable continues the same
twoIndexGame(MainIndex, MainIndex, CityTable,[_|DoubleRest], AllCities, Sum, AllCars, Min, MinI, FinalMin, FinalMinI):-   % MaxIndex == MainIndex : MaxIndex++
    NewMaxIndex is MainIndex+1,
    twoIndexGame(MainIndex, NewMaxIndex, CityTable,DoubleRest, AllCities, Sum, AllCars, Min, MinI, FinalMin, FinalMinI).
        
twoIndexGame(MainIndex, MaxIndex, CityTable,[0|DoubleRest], AllCities, Sum, AllCars, Min, MinI, FinalMin, FinalMinI):-    % MaxIndex points to zero : MaxIndex++
    NewMaxIndex is MaxIndex+1,
    twoIndexGame(MainIndex, NewMaxIndex, CityTable,DoubleRest, AllCities, Sum, AllCars, Min, MinI, FinalMin, FinalMinI).

twoIndexGame(MainIndex, MaxIndex, [CurrentCars|CityTableRest],DoubleTable, AllCities, Sum, AllCars, Min, MinI, FinalMin, FinalMinI):-  % Pointers in normal positions
    NewSum is (Sum + AllCars - AllCities*CurrentCars ), % find new sum
    distance(MainIndex, MaxIndex, AllCities, MaxDistance),  % find new distance for max-sum pair
    checkDistance(MaxDistance,NewSum,Result),               % check the validity of that distance
    giveMin(Result,MainIndex,Min,MinI,NewMin,NewMinI),      % check if we have a new min
    NewMainIndex is MainIndex+1,                            % update main index
    twoIndexGame(NewMainIndex, MaxIndex, CityTableRest, DoubleTable, AllCities, NewSum, AllCars, NewMin, NewMinI, FinalMin, FinalMinI),!. % run the recursion

    


% @@@@@@@@@@@@@@@@@@@@@@@@- MAIN CLAUSE -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
round(File,Min,MinI) :-
    readInput(File, Cities, Cars, InitialState),             % 1. Parse the file
    compareWithFinal(0,InitialState,Cities,0,0,_,Samy),      % 2. Find the Initial Sum distance from zero final state
    msort(InitialState,Sorted),                              % 3. Sort the initial. msort does not remove multiple
    CitiesMinus is Cities-1,                                 
    cityTable(0,CitiesMinus,Sorted,0,CityTable),             % 4.  Create city table   
    append(CityTable,CityTable,DoubleTable),!,               % 5a. Create a duplicate list CityTable@CityTable for max index
    CityTable = [_|T],                                       % 5b. Remove first element from CityTable (we will start from the second element)
    DoubleTable = [_|Rest1],                                 % 5c. Remove first element from DoubleTable (we will start from the second element)
    twoIndexGame(1, 2, T, Rest1, Cities, Samy, Cars, Samy, 0, Min, MinI),!. % 6. start the game of two indexes. Cut (!) every other possible solution.
    



% @@@@@@-- Testing--@@@@@@
% Simple
% round('tests/r1.txt', Min,MinI), write(Min),write(" "), writeln(MinI), fail.
% 
% With timer (not working good enough)
% round('tests/r31.txt', Min,MinI), write(Min),write(" "), writeln(MinI),
%    statistics(walltime, [NewTimeSinceStart | [ExecutionTime]]),
%    write('Execution took '), write(ExecutionTime), write(' ms.'), nl.
