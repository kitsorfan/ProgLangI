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
readInput(File, N, InitialQueue) :-
    open(File, read, Stream),               % open the file
    readLine(Stream, [N]),                    % read first line
    readLine(Stream, InitialQueue).         % read second line

% Auxilary clause. Reads a line and seperates its elements. Returns a list.
readLine(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).



qmove(Queue,Stack,Prev,NewQueue,NewStack,NewPrev):-
    Queue=[Head|_],
    select(Head,Queue,NewQueue),
    append(Stack,[Head],New),
    NewStack=New,
    atom_concat(Prev, "Q", NewPrev).


smove(Queue,Stack,Prev,NewQueue,NewStack,NewPrev):-
    last(Stack,X),
    select(X,Stack,NewStack),
    Tail=[X],
    append(Queue,Tail,NewQueue),
    atom_concat(Prev, "S", NewPrev).

success(Queue,FinalQueue):-
    Queue=FinalQueue.


solution([Move|_],FinalQueue,Moves):-
    Move=[Queue,_,Prev],
    success(Queue,FinalQueue),
    Moves=Prev.

solution([Move|Rest],FinalQueue,Moves):-
    Move=[Queue,Stack,Prev],
    not(Stack = []),
    not(Queue = []),
    qmove(Queue,Stack,Prev,NewQueu1,NewStack1,NewPrev1),
    smove(Queue,Stack,Prev,NewQueu2,NewStack2,NewPrev2),
    TempMove1=[NewQueu1,NewStack1,NewPrev1],
    Move1=[TempMove1],
    TempMove2=[NewQueu2,NewStack2,NewPrev2],
    Move2=[TempMove2],
    append(Rest,Move1,TempRest),
    append(TempRest,Move2,NewRest),
    solution(NewRest,FinalQueue,Moves).

solution([Move|Rest],FinalQueue,Moves):-
    Move=[Queue,Stack,Prev],
    not(Queue = []),
    qmove(Queue,Stack,Prev,NewQueu,NewStack,NewPrev),
    TempMove=[NewQueu,NewStack,NewPrev],
    NewMove=[TempMove],
    append(Rest,NewMove,NewRest),
    solution(NewRest,FinalQueue,Moves).


solution([Move|Rest],FinalQueue,Moves):-
    Move=[Queue,Stack,Prev],
    smove(Queue,Stack,Prev,NewQueu,NewStack,NewPrev),
    TempMove=[NewQueu,NewStack,NewPrev],
    NewMove=[TempMove],
    append(Rest,NewMove,NewRest),
    solution(NewRest,FinalQueue,Moves).


giveAnswer(A,"empty"):-
    A = "".
giveAnswer(A,A).

msort(List, Sorted)     :- sort(0,  @=<, List,  Sorted).

% @@@@@@@@@@@@@@@@@@@@@@@@- MAIN FUNCTION -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
qssort(File, Answer) :-
    readInput(File, _, InitialQueue),
    msort(InitialQueue,FinalQueue),
    % writeln(InitialQueue),
    % writeln(FinalQueue),
    % qmove(InitialQueue,[],"",NewQueue,NewStack,Prev),
    % smove(NewQueue,NewStack,Prev,NQ,NS,NP),
    Move=[InitialQueue,[],""],
    ListMove=[Move],
    solution(ListMove,FinalQueue,Result),
    giveAnswer(Result,Answer),!.

    % --Check the Answer
    % qssort('tests\\qs1.txt', Answer), writeln(Answer), fail.
    
    