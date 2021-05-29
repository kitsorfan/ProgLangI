"""
********************************************************************************
  Project     : Programming Languages 1 - Assignment 2 - Exercise qssort
  Authors     : Stylianos Kandylakis el17088, 
                Kitsos Orfanopoulos el17025
  -----------
 ProgLangI 2021, ECE-NTUA
 *******************************************************************************


>> Sources: https://www.geeksforgeeks.org/python-program-to-convert-a-list-to-string/
            https://courses.softlab.ntua.gr/pl1/2021a/Labs/lab-python.pdf (solution to wolf, goat, cabbage problem)
 

>> Solution
---------------------------------
    Our solution is based on the solution to the famous Wolf, goat and cabbage problem.
    We represent as nodes the state of the queue and the stack. 
    We model the allowed moves (Q and S), the success condition and the methods to 
    determine whether we have visited again a node.
    We run the BFS and every time we keep the previous step to a string.
    
    Attention:  Our solution is exhaustive, we will search all the states, until the desirable one. 
                Given that every state can produce 1, or often 2 other states, we conclude that 
                in general we produce states exponentially (2^n). Our solution can work for small inputs.
                This is the Way. 

>> Steps:

    1. Parse the file.
    2. Create initial state with a queu, an empty stack and empty previous steps (string).
    3. Sort initial stack to find the success condition.
    4. Set the allowed moves.
    5. Run the BFS, creating state nodes, till find the desirale one.
    6. Return the previous steps string. 
"""




from collections import deque           # we will use deque, as it has better average complexities
import sys                              # to take the call parameters




# @@@@@@@@@@@@@@@@@@@@@@@@- CLASS STATE -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

class state:                                    # we create a class to create objects
    
    def __init__(self,ourQueu, ourStack, prev):  # initial parameters
        self.prev=prev
        self.ourQueu = ourQueu
        self.ourStack = ourStack

    # def Qmove(self):
    #     newQ = self.ourQueu[1:]
    #     newS = self.ourStack[:]
    #     newS.append(self.ourQueu[0])
    # def Smove(self):
    #     newQ = self.ourQueu[:]
    #     newS = self.ourStack[:-1]
    #     newQ.append(self.ourStack[-1])

    def accessible(self):   # create accessible states from our current state
        # S & Q allowed
        lenQueue=len(self.ourQueu)
        lenStack=len(self.ourStack)
        if (lenQueue!=0) and (lenStack!=0):   # if both queu and stack are not empty the S and Q alloweds
            #initial=copy.deepcopy(self)             # create a copy of the state (we will make two moves  so we need a copy)
            initialStack=self.ourStack[:]
            initialQueue=self.ourQueu[:]
            initialPrev=self.prev[:]
            # print(initialQueue,initialStack,initialPrev)

            # Q MOVE
            Qmove=self.ourQueu.pop(0)            # pop an element from Queu (left side)
            self.ourStack.append(Qmove)         # push an element to stack (left side)
            self.prev=self.prev+"Q"                 # add Q to our prev string
            yield state(self.ourQueu, self.ourStack,self.prev) # yield the state

            # print(initialQueue,initialStack,initialPrev)
            # time.sleep(0.01)
            # S Move
            Smove=initialStack.pop()        # pop an element from Stack
            initialQueue.append(Smove)           # push an element to Queue (left side)
            initialPrev=initialPrev+"S"           # add S to our prev string (right side)
            yield state(initialQueue, initialStack, initialPrev) # yield the state

        # only Q allowed
        elif(lenQueue!=0):                          # Only Q move is allowed (Stack is empty). We do not need to create a copy
            Qmove=self.ourQueu.pop(0)            # pop an element from Queu (left side)
            self.ourStack.append(Qmove)         # push an element to Stack (left side)
            self.prev=self.prev+"Q"                 # add Q to our prev string
            yield state(self.ourQueu, self.ourStack,self.prev) # yield the state

        # only S allowed
        else:
            Smove=self.ourStack.pop()           # Only S move is allowed (Queue is empty). We do not need to create a copy
            self.ourQueu.append(Smove)              # pop an element from Stack (left side)
            self.prev=self.prev+"S"                 # push an element to Queu (right side)
            yield state(self.ourQueu, self.ourStack,self.prev) # yield the state
            

    def __str__(self):      # print the state
        # listToStr=self.prev # take the string (perhaps useless)
        # if (listToStr==""): return "empty"  # if empty string 
        # else: 
        return self.prev



    def success(self, finalQueu):      # success condition, if stack == sorted stack
        
        return (list(self.ourQueu)==finalQueu)


    def __eq__(self,other): # compare two statess to find if they are the same
        # x=tuple(self.ourStack)
        # y=tuple(self.ourQueu)
        return (self.prev is other.prev) 


    def __hash__(self): # hashing the object
        # y=list(zip(self.ourQueu, self.ourStack))
        # x="".join([str(x) for x in self.ourQueu])
        # y="".join([str(x) for x in self.ourStack])
        # return (hash(x+y))
        x=tuple(self.ourQueu)
        y=tuple(self.ourStack)
        # return(hash(x))
        # y=list(enumerate(self.ourQueu))#+list((self.ourList)
        # y=list((self.ourQueu))#+list((self.ourList)
        return(hash((x,y)))
        # x=''.join(self.ourQueu)
        # # # print(x)
        
        # return hash(x)  # we hash the prev string (is always different for every state)
        # return hash(frozenset(y))
        

# @@@@@@@@@@@@@@@@@@@@@@@@- SOLVE FUNCTION -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# This is the main function that runs the BFS to calculate the minimum
# movements required to reach the final state.
# We add states to a Q queu in order to traverse them.
# We create a set of states that we already have visit in order to avoid repetition.

def solve(initState,finalState): #BFS 
    Q=deque([initState])  # queue to add new state to traverse
    seen=set([initState]) # set to add the visited nodes
    # if s.success(finalState): # if is the final the return the final state (it contains the prev string = the path to reach it)
    #     return s              # we need that if the initial state == final state (already sorted stack)
    while Q:                # while Q is not empty
        s=Q.popleft()       # pop a state from it
        for t in s.accessible():  # add the two accessible states to our queu (if they are not already visited)
            if t.success(finalState):
                seen.add(t)
                print(len(seen))
                return t        # return it, because of success (the main source of success)
            if t not in seen:   # if not success, add to the Seen set, and to the Q queue
                seen.add(t)
                Q.append(t)

# @@@@@@@@@@@@@@@@@@@@@@@@- MAIN FUNCTION -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

if __name__ == "__main__":
    with open(sys.argv[1], "rt") as inputFile:                       # take call parameters and open the file 
        N = int(inputFile.readline())                                # read N
        ourStack=[]                                             # create empty stack
        ourQueu = list(map(int, inputFile.readline().split()))      # fill the queue
        finalQueu=ourQueu[:]                                     # copy the stack to a new list
        finalQueu.sort()                                             # sort that list
        # finalQueu="".join([str(x) for x in finalQueu])
        # ourQueu = "".join([str(x) for x in inputList])
        # print(ourQueu)
        # print(finalQueu)
    
        if (finalQueu==ourQueu): 
            print("empty")
        else:
            prev=""                                                      # create the previous strings (empty)
            init = state(ourQueu,ourStack,prev)                          # create initial state 
            print(solve(init,finalQueu))                                 # run the BFS and print the result

            

            