

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


% % halve from: https://stackoverflow.com/questions/10063838/understanding-the-splitting-in-swi-prolog
% halve(List,A,B) :- halve(List,List,A,B), !.
% halve(B,[],[],B).
% halve(B,[_],[],B).
% halve([H|T],[_,_|T2],[H|A],B) :-halve(T,T2,A,B). 

% % https://stackoverflow.com/questions/15926034/how-to-merge-lists-in-prolog/15926279

% m2([A|As], [B|Bs], [A,B|Rs]) :-
%     A=[A1,_],
%     B=[B1,_],
%     A1=<B1,
%     !, m2(As, Bs, Rs).
% m2([A|As], [B|Bs], [B,A|Rs]) :-
%     !, m2(As, Bs, Rs).
% m2([], Bs, Bs) :- !.
% m2(As, [], As).

% mergesort(Unsorted, Sorted):-
%     halve(Unsorted,X,Y),
%     writeln('Inside the matrix'),
%     writeln(X),
%     writeln(Y),
%     mergesort(X,Sorted1),
%     % mergesort(Y,Sorted2),   
%     % mergesort(Y,Sorted2),
%     m2(Sorted1,Y,Sorted),!.
% mergesort([],[]).
% % mergesort(A,A).
% % m2([A|As], [B|Bs], [B,A|Rs]) :-
% %     nth0(A1,A,0),
% %     nth0(B1,B,0),
% %     A1>B1,
% %     !, m2(As, Bs, Rs).

/* merge_sort(Xs, Ys) is true if Ys is a sorted permutation of the list Xs.*/
% merge_sort(List, SortedList):-
%     lengthy(List, Length),
%     merge_sort_1(Length, List, SortedList, []).
   
  /* merge_sort_1(N, Xs, Ys, Zs) is true if Ys is a sorted permutation of    */
  /*  the first N elements of the list Xs, and Zs are the remaining elements */
%   /*  of Xs.                                                                 */
%   merge_sort_1(0, Rest, [], Rest):-!.
%   merge_sort_1(1, [A|Rest], [A], Rest):-!.
%   merge_sort_1(2, [A,B|Rest], C, Rest):-

%     A=<B,
%      !,C = [A,B].
%   merge_sort_1(2, [A,B|Rest], C, Rest):- !,C = [B,A].
%   merge_sort_1(N, List, Sorted, Rest):-
%     N1 = N div 2, N2 = N - N1,
%     merge_sort_1(N1, List, SortedLeft, TempList),
%     merge_sort_1(N2, TempList, SortedRight, Rest),
%     ordered_merge(SortedLeft, SortedRight, Sorted).
   
%   /* ordered_merge(Xs, Ys, Zs) is true if Zs is an ordered list obtained     */
%   /*   from merging the ordered lists Xs and Ys.                             */
%   ordered_merge([X|Xs], [Y|Ys], [Y|Zs]):-
%     Y=[Y1,_],
%     X=[X1,_],
%     Y1 =< X1, 
%     ordered_merge([X|Xs], Ys, Zs).
% ordered_merge([X|Xs], Ys, [X|Zs]):-
% ordered_merge(Xs, Ys, Zs).
% ordered_merge([], Ys, Ys).

%   /* length(Xs, L) is true if L is the number of elements in the list Xs.    */
%   lengthy(Xs, L):-length_1(Xs, 0, L).
  
%   /* length_1(Xs, L0, L) is true if L is equal to L0 plus the number of      */
%   /*   elements in the list Xs.                                              */
%   length_1([], L, L).
%   length_1([_|Xs], L0, L):-L1 = L0 + 1, length_1(Xs, L1, L).

% merge([],[],[]).
% merge([],A,A).
% merge(B,[],B).
% merge([A|Arest],[B|Brest],Merged):-
%     nth0(X,A,0),
%     nth0(Y,B,0),
%     X<Y,
%     merge(Arest,Brest,Merged).


% mergesort([],[]).
% mergesort(A,A).
% mergesort(Unsorted,Sorted):-
    
            
%         fun merge (nil, a) = a 
%         |   merge (b , nil) = b
%         |   merge (x::xs, y::ys) =
%             if tupleMin(x,y) then x::merge(xs, y::ys) 
%             else y::merge(ys, x::xs);

            
%             val (x,y) = halve merge_list
%        in
%             merge(mergesort x, mergesort y)
%         end;


mycompare(<,[A1,_],[A2,_]) :- A1 < A2.
mycompare(>, _, _).

mySort(Unsorted,Sorted):-
predsort(mycompare, Unsorted, Sorted),!.


% @@@@@@@@@@@@@@@@@@@@@@@@- MAIN FUNCTION -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
longest(File, Answer) :-
    read_input(File, Days, Hospitals, Discharges),
    minusHospitals(Hospitals,Discharges,MinusDischarges),
    indexAndPrefix(1,0,MinusDischarges,IndexedDischarges),
    addZero(IndexedDischarges,ZeroIndexedDischarges),
    mySort(ZeroIndexedDischarges,SortedDischarges),
    writeln(SortedDischarges),
    fail.


% longest('longest.in1', Answer), writeln(Answer), fail.