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
    Our first solution was based on the article: https://stackoverflow.com/questions/13476927/longest-contiguous-subarray-with-average-greater-than-or-equal-to-k

    Different Approach: 
        According to the article, after sorting the array we must do a swap to the initial array and for each 
        prefix-index we do a binary search at the new array. 
        We avoided that by finding the maximum Difference at the indixes in the new array. See the example.


Steps:

    1. Parse the file
    2. Create opposite array and subtract the hospitals
    3. Create prefix array and add indexes
    4. Add (0,0) as element of the list
    5. Sort prefix array according to its prefixes
    6. Remove prefixes and create a list only with indexes.
    7. Find the maximum difference.

Example: 

Suppose we have 3 hospitals and 11 days. The given array is:
11 3
42 -10	8	1	11	-6	-12	16	-15	-11	13

After:
  Step 1: [42,	-10,	8,	1,	11,	-6,	-12,	16,	-15,	-11, 13]
   
  Step 2: [-45,	7,	-11,	-4,	-14,	3,	9,	-19,	12,	8,	-16]    //(element = -element - hospitals)

  Step 3: [(-45,1),	(-38,2),	(-49,3),	(-53,4),	(-67,5),	(-64,6),	(-55,7),	(-74,8),	(-62,9),	(-54,10),	(-70,11)]   //(make indexes and prefixes, where prefix is sum = sum + current)


  Step 4: [(0,0), (-45,1),	(-38,2),	(-49,3),	(-53,4),	(-67,5),	(-64,6),	(-55,7),	(-74,8),	(-62,9),	(-54,10),	(-70,11)]  // add (0,0)

  Step 5:  [(-74,8), (-70,11), (-67,5), (-64,6), (-62,9), (-55,7), (-54,10), (-53,4), (-49,3), (-45,1), (-38,2), (0,0)] //sort by prefixes

  Step 6: [8, 11, 5, 6, 9, 7, 10, 4, 3, 1, 2, 0]    //we remove prefixes, we keep only indexes

  Step 7: we do a left to right swap. 
          A. We start with min=8 and maxDif = 0. 
          B. 8<11, so maxDif=(11-8)=3 and min 8. 
          C. 8>5 so min=5
          D. 5<6, but maxDif = 3 (6-5 = 1 < 3)
          and so on

          We will have min 5<10 and maxDif= 10-5 = 5. So 5 is our final answer.

*/

% *@@@@@@@@@@@@@@@@@@- 1. Parse the file -@@@@@@@@@@@@@@@@@@*
% Based on: https://courses.softlab.ntua.gr/pl1/2019a/Exercises/read_colors_SWI.pl

% Main clause. Reads two lines and separates their elements
readInput(File, Days, Hospitals, Discharges) :-
    open(File, read, Stream),               % open the file
    readLine(Stream, [Days, Hospitals]),   % read first line
    readLine(Stream, Discharges).          % read second line

% Auxilary clause. Reads a line and seperates its elements. Returns a list.
readLine(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).



% *@@@@@@@@@@@@@@@@@@-  2. Minus Hospitals -@@@@@@@@@@@@@@@@@@*
% A function that takes a list L1 and the Hospitals number 
% and returns a list L2 where L2[i]=-L1[i]-Hospitals

minusHospitals(_,[],[]). 
minusHospitals(Hospitals,[Head1|Tail1],[Head2|Tail2]):-
    minusHospitals(Hospitals,Tail1,Tail2),
    Head2 is (-Head1-Hospitals).

% *@@@@@@@@@@@@@@@@@@- 3. Prefix and Index -@@@@@@@@@@@@@@@@@@*
%  A clause that takes a list and returns a tuple with prefix list and the index of this list 
% -- 
% ex. [12, 9, 3] -> [(12,1), (21, 2), (24, 3)]. We start indexing from 1 (we will later add an (0,0) manually)

indexAndPrefix(_,_,[],[]).
indexAndPrefix(Index,Sum,[X|More1],[[NewSum,Index]|More2]):-
    NewSum is (Sum+X),
    Newindex is (Index+1),
    indexAndPrefix(Newindex,NewSum,More1,More2).

% *@@@@@@@@@@@@@@@@@@- 4. Add zero -@@@@@@@@@@@@@@@@@@*
% Add [0,0] as the first element of the list.

addZero(A,[[0,0]|A]).

% *@@@@@@@@@@@@@@@@@@- 5. Sort -@@@@@@@@@@@@@@@@@@*
% Sort by the value of the prefixes.

% Auxilary clause to compare two tuples
myCompare(<,[A1,_],[A2,_]) :- A1 < A2.
myCompare(>, _, _).

% Main sorting clause, sorts a list of lists.
mySort(Unsorted,Sorted):-
    predsort(myCompare, Unsorted, Sorted),!. %predsort is a library clause 

% *@@@@@@@@@@@@@@@@@@- 6. Remove Prefix -@@@@@@@@@@@@@@@@@@*
% from tuple to single list

removePrefix([],[]).
removePrefix([[_,Index]|More1],[Index|More2]):-
    removePrefix(More1,More2).

% *@@@@@@@@@@@@@@@@@@- Min Max Auxilaries -@@@@@@@@@@@@@@@@@@*

% clause that returns Minumum of two values
giveMin(A,B,C):-
    A<B,
    C=A.
giveMin(_,B,C):-
    C=B.

% clause that returns Maximum of two values

giveMax(A,B,C):-
    A>B,
    C=A.
giveMax(_,B,C):-
    C=B.

% *@@@@@@@@@@@@@@@@@@- 7. Find max Dif -@@@@@@@@@@@@@@@@@@*
/* A clause that takes a list and returns the maximum positive difference of the current minimum value from the current value. 
We do a left-to-right swap, updating each step the current minimum value. 
  We subtract that minimum from our current value. If that difference is larger than our current maxDif we update it. 
  The output of this is a list of every maxDif we found on each step. 
Initial value for min is list[0] and maxDif=0.
--
Attention! There is a difference from the SML approach. Here we don't just return the final value.
There were some problems with that. Instead, we return a list with all the current results we get as we swap the list.
Later we will only keep the last element of that list (see below).s
*/


findMaxDif([],_,_,[]).
findMaxDif([A|Rest],Min,MaxDif,[X|Rest2]):-
    giveMin(A,Min,NewMin),
    Dif is (A-Min),
    giveMax(MaxDif,Dif,NewMaxDif),
    X=NewMaxDif,
    findMaxDif(Rest,NewMin,NewMaxDif,Rest2),!.


% @@@@@@@@@@@@@@@@@@@@@@@@- MAIN FUNCTION -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
longest(File, Answer) :-
    readInput(File, _, Hospitals, Discharges),             % 1. Parse the file
    minusHospitals(Hospitals,Discharges,MinusDischarges),   % 2. Create opposite array and subtract the hospitals
    indexAndPrefix(1,0,MinusDischarges,IndexedDischarges),  % 3. Create prefix array and add indexes
    addZero(IndexedDischarges,ZeroIndexedDischarges),       % 4. Add (0,0) as element of the list
    mySort(ZeroIndexedDischarges,SortedDischarges),         % 5. Sort prefix array according to its prefixes
    removePrefix(SortedDischarges,SortedIndexes),           % 6. Remove prefixes and create a list only with indexes.
    SortedIndexes = [First|_],                              % create first min value (first element of the list)
    findMaxDif(SortedIndexes,First,0,Results),              % 7. Find the maximum difference.
    last(Results,Answer),!.                                 % keep only the last (maximum) of the differences

% --Check the Answer
% longest('tests\\longest.in1', Answer), writeln(Answer), fail.