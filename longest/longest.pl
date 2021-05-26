

% *@@@@@@@@@@@@@@@@@@- 1. Parse the file -@@@@@@@@@@@@@@@@@@*
% Based on: https://courses.softlab.ntua.gr/pl1/2019a/Exercises/read_colors_SWI.pl

read_input(File, Days, Hospitals, Discharges) :-
    open(File, read, Stream),
    read_line(Stream, [Days, Hospitals]),
    read_line(Stream, Discharges).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).



% *@@@@@@@@@@@@@@@@@@-  Minus Hospitals -@@@@@@@@@@@@@@@@@@*
% A function that takes a list L1 and the Hospitals number 
% and returns a list L2 where L2[i]=-L1[i]-Hospitals

minusHospitals(_,[],[]). 
minusHospitals(Hospitals,[Head1|Tail1],[Head2|Tail2]):-
    minusHospitals(Hospitals,Tail1,Tail2),
    Head2 is (-Head1-Hospitals).

% *@@@@@@@@@@@@@@@@@@- 2. Prefix and Index -@@@@@@@@@@@@@@@@@@*
%  A function that takes a list and returns a tuple with prefix list and the index of this list 
% -- 
% ex. [12, 9, 3] -> [(12,1), (21, 2), (24, 3)]. We start indexing from 1 (we will add an (0,0) manually)

indexAndPrefix(_,_,[],[]).
indexAndPrefix(Index,Sum,[X|More1],[[NewSum,Index]|More2]):-
    NewSum is (Sum+X),
    Newindex is (Index+1),
    indexAndPrefix(Newindex,NewSum,More1,More2).

% *@@@@@@@@@@@@@@@@@@- Add zero -@@@@@@@@@@@@@@@@@@*

addZero(A,[[0,0]|A]).

% *@@@@@@@@@@@@@@@@@@- Sort -@@@@@@@@@@@@@@@@@@*

mycompare(<,[A1,_],[A2,_]) :- A1 < A2.
mycompare(>, _, _).

mySort(Unsorted,Sorted):-
    predsort(mycompare, Unsorted, Sorted),!.

% *@@@@@@@@@@@@@@@@@@- Remove Prefix -@@@@@@@@@@@@@@@@@@*
% from tuple to single list


removePrefix([],[]).
removePrefix([[_,Index]|More1],[Index|More2]):-
    removePrefix(More1,More2).

% *@@@@@@@@@@@@@@@@@@- Find max Dif -@@@@@@@@@@@@@@@@@@*

findMaxDif([],_,_).
findMaxDif([A|Rest],Min,MaxDif):-
    write('Min is '),
    write(Min),
    write(' and MaxDif is '),
    writeln(MaxDif),
    A<Min,
    NewMin = A,
    Dif is (A-Min),
    Dif>MaxDif,
    NewMaxDif = Dif,
    findMaxDif(Rest,NewMin,NewMaxDif).
findMaxDif([A|Rest],Min,MaxDif):-
    A<Min,
    NewMin = A,
    Dif is (A-Min),
    Dif=<MaxDif,
    NewMaxDif = MaxDif,
    findMaxDif(Rest,NewMin,NewMaxDif).
findMaxDif([A|Rest],Min,MaxDif):-
    A>=Min,
    NewMin = Min,
    Dif is (A-Min),
    Dif>MaxDif,
    NewMaxDif = Dif,
    findMaxDif(Rest,NewMin,NewMaxDif).
findMaxDif([A|Rest],Min,MaxDif):-
    A>=Min,
    NewMin = Min,
    Dif is (A-Min),
    Dif=<MaxDif,
    NewMaxDif = MaxDif,
    findMaxDif(Rest,NewMin,NewMaxDif).


% @@@@@@@@@@@@@@@@@@@@@@@@- MAIN FUNCTION -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
longest(File, Answer) :-
    read_input(File, Days, Hospitals, Discharges),
    minusHospitals(Hospitals,Discharges,MinusDischarges),
    indexAndPrefix(1,0,MinusDischarges,IndexedDischarges),
    addZero(IndexedDischarges,ZeroIndexedDischarges),
    mySort(ZeroIndexedDischarges,SortedDischarges),
    removePrefix(SortedDischarges,SortedIndexes),
    writeln(SortedIndexes),
    SortedIndexes = [First|_],
    writeln(First),
    Answer is 0,
    findMaxDif(SortedIndexes,First,Answer),
    writeln('Answer is '),
    fail.


% longest('longest.in1', Answer), writeln(Answer), fail.