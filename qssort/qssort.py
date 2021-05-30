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

class state:                                
    
    def __init__(self,ourQueu, ourStack, prev):  # initial parameters
        self.prev=prev
        self.ourQueu = ourQueu
        self.ourStack = ourStack

    def accessible(self):   # create accessible states from our current state
        # S & Q allowed
        if (self.ourQueu) and (self.ourStack):   # if both queu and stack are not empty the S and Q alloweds

            # Q MOVE
            newQ=self.ourQueu[1:]           # pop an element from Queue (left side)
            newS=self.ourStack[:]           # copy
            newS=newS+(self.ourQueu[0],)
            prev=self.prev[:]+"Q"
            yield state(newQ, newS,prev) # yield the state
            
            # print("Q1 move | Q ",self.ourQueu," goes to -> ",newQ," and S ",self.ourStack," --> ",newS)
            # time.sleep(0.05)

            # S MOVE
            newQ=self.ourQueu[:]           # pop an element from Queue (left side)
            newS=self.ourStack[:-1]           # copy
            newQ=newQ+(self.ourStack[-1],)
            prev=self.prev[:]+"S"
            # print("S1 Move | Q ",self.ourQueu," goes to -> ",newQ," and S ",self.ourStack," --> ",newS)

            yield state(newQ, newS,prev) # yield the state


        # only Q allowed
        elif(self.ourQueu):                          # Only Q move is allowed (Stack is empty). We do not need to create a copy
            newQ=self.ourQueu[1:]           # pop an element from Queue (left side)
            newS=self.ourStack[:]           # copy
            newS=newS+(self.ourQueu[0],)
            prev=self.prev[:]+"Q"
            # print("Q2 move | Q ",self.ourQueu," goes to -> ",newQ," and S ",self.ourStack," --> ",newS)

            yield state(newQ, newS,prev) # yield the state

        # only S allowed
        else:
            newQ=self.ourQueu[:]           # pop an element from Queue (left side)
            newS=self.ourStack[:-1]           # copy
            newQ=newQ+(self.ourStack[-1],)
            prev=self.prev[:]+"S"
            # print("S2 Move | Q ",self.ourQueu," goes to -> ",newQ," and S ",self.ourStack," --> ",newS)

            yield state(newQ, newS,prev) # yield the state
            

    def __str__(self):      # print the state
        # listToStr=self.prev # take the string (perhaps useless)
        # if (listToStr==""): return "empty"  # if empty string 
        # else: 
        return self.prev



    def success(self, finalQueu):      # success condition, if stack == sorted stack
        
        return (self.ourQueu==finalQueu)


    def __eq__(self, other): # compare two statess to find if they are the same
        # x=tuple(self.ourStack)
        # y=tuple(self.ourQueu)
        return isinstance(other, state) and (self.ourQueu is other.ourQueu) 


    def __hash__(self): # hashing the object
        # y=list(zip(self.ourQueu, self.ourStack))
        # x="".join([str(x) for x in self.ourQueu])
        # y="".join([str(x) for x in self.ourStack])
        # return (hash(x+y))
        x=(self.ourQueu)
        y=(self.ourStack)
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
                # seen.add(t)
                # print(len(seen))
                return t        # return it, because of success (the main source of success)
            if hash(t) not in seen:   # if not success, add to the Seen set, and to the Q queue
                Q.append(t)
                seen.add(hash(t))

# @@@@@@@@@@@@@@@@@@@@@@@@- MAIN FUNCTION -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

if __name__ == "__main__":
    with open(sys.argv[1], "rt") as inputFile:                       # take call parameters and open the file 
        N = int(inputFile.readline())                                # read N
        ourStack=tuple()                                             # create empty stack
        ourQueu = list(map(int, inputFile.readline().split()))      # fill the queue
        finalQueu=ourQueu[:]                                     # copy the stack to a new list
        finalQueu.sort()                                             # sort that list
        # finalQueu="".join([str(x) for x in finalQueu])
        # ourQueu = "".join([str(x) for x in inputList])
        ourQueu=tuple(ourQueu)
        finalQueu=tuple(finalQueu)
        # print(ourQueu)
        # print(finalQueu)
    
        if (finalQueu==ourQueu): 
            print("empty")
        else:
            prev=""                                                      # create the previous strings (empty)
            init = state(ourQueu,ourStack,prev)                          # create initial state 
            print(solve(init,finalQueu))                                 # run the BFS and print the result

            

            