"""
********************************************************************************
  Project     : Programming Languages 1 - Assignment 2 - Exercise LoopRooms
  Authors     : Stylianos Kandylakis el17088, 
                Kitsos Orfanopoulos el17025
  -----------
 ProgLangI 2021, ECE-NTUA
 *******************************************************************************


 Sources:   https://www.geeksforgeeks.org/python-program-to-convert-a-list-to-string/
            https://courses.softlab.ntua.gr/pl1/2021a/Labs/lab-python.pdf
 

>> 
---------------------------------

>> STEPS:
----------------------------
# 🔵Read the input (easy)
# 🔵Sort the data (easy)
# 🔵Create nodes (queue, stack, pointerQ, pointerS) (medium)
# 🔵Add nodes creating graph till find the desirable One (check if node already exists in the graph) (hard x2)
# 🔵Find minimum path to that node (medium)
"""




from collections import deque
import sys
import copy



class state:
    def __init__(self,ourQueu, ourList, prev):
        self.prev=prev
        self.ourQueu = ourQueu
        self.ourList = ourList

    def accessible(self):
        if (len(self.ourQueu)!=0) and (len(self.ourList)!=0):
            initial=copy.deepcopy(self)

            Qmove=self.ourQueu.popleft()
            self.ourList.appendleft(Qmove)
            self.prev.append("Q")
            yield state(self.ourQueu, self.ourList,self.prev)
            
            Smove=initial.ourList.popleft()
            initial.ourQueu.append(Smove)
            initial.prev.append("S")
            yield state(initial.ourQueu, initial.ourList,initial.prev)

        elif(len(self.ourQueu)!=0):
            Qmove=self.ourQueu.popleft()
            self.ourList.appendleft(Qmove)
            self.prev.append("Q")
            yield state(self.ourQueu, self.ourList,self.prev)

        else:
            Smove=self.ourList.popleft()
            self.ourQueu.append(Smove)
            self.prev.append("S")
            yield state(self.ourQueu, self.ourList,self.prev)
            

    def __str__(self):
        #return "Queu: {} List: {}".format(self.ourQueu,self.ourList)
        listToStr = ''.join(map(str, list(self.prev)))
        if (listToStr==""): return "empty"
        else: return listToStr
        # else: return "{}. Queu: {} | List: {} | Moves: {}".format(len(self.prev),self.ourQueu,self.ourList,self.prev) # listToStr

    def success(self, finalQueu):
        return (list(self.ourQueu)==finalQueu)

    def __eq__(self,other):
        return (isinstance(other,state) and (self.ourQueu)==(other.ourQueu) ) #maybe remove lasts: and (self.ourList)==(other.ourList)

    def __hash__(self):
        y=list(enumerate(self.ourQueu))+list((self.ourList))#+list((self.ourList)
        return hash(frozenset(y))
        

def solve(initState,finalState): #bfs
    Q=deque([initState])
    seen= set([initState])
    while Q:
        s=Q.popleft()
        # print(s)
        if s.success(finalState): 
            return s
        for t in s.accessible():
            if t.success(finalState):
                seen.add(t)
                return t
            if t not in seen:
                seen.add(t)
                Q.append(t)

if __name__ == "__main__":
    with open(sys.argv[1], "rt") as inputFile:
        N = int(inputFile.readline())
        ourStack=deque()
        ourQueu = deque(map(int, inputFile.readline().split()))
        finalQueu=list(ourQueu)
        finalQueu.sort()
        prev=deque()
        
        init = state(ourQueu,ourStack,prev)
        print(solve(init,finalQueu))

            

            