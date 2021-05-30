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
    
    def __init__(self,ourQueue, ourStack, prev):  # initial parameters
        self.prev=prev
        self.ourQueue = ourQueue
        self.ourStack = ourStack

    def accessible(self):   # create accessible states from our current state
        # S & Q allowed
        if (self.ourQueue) and (self.ourStack):   # if both queu and stack are not empty the S and Q allowed

            # Q MOVE
            # pop from Queue, push to Stack 
            newQ=self.ourQueue[1:]              # create a tuple slice excluding first element (it will be popped out)
            newS=self.ourStack[:]               # copy tuple
            newS=newS+(self.ourQueue[0],)       # add first element from the Queue to copied Stack tuple
            prev=self.prev[:]+"Q"               # update prev
            yield state(newQ, newS,prev)        # yield the state
            
            # S MOVE
            # pop from Stack, push to Queue
            newS=self.ourStack[:-1]             # create a tuple slice excluding last element (it will be popped out)
            newQ=self.ourQueue[:]               # copy tuple
            newQ=newQ+(self.ourStack[-1],)      # add last element from the Stack to copied Queue tuple
            prev=self.prev[:]+"S"               # update prev
            yield state(newQ, newS,prev)        # yield the state


        # only Q allowed
        elif(self.ourQueue):                          # Only Q move is allowed (Stack is empty). We do not need to create a copy
            # BEWARE: CODE REPETITION AHEAD

            # Q MOVE
            # pop from Queue, push to Stack 
            newQ=self.ourQueue[1:]              # create a tuple slice excluding first element (it will be popped out)
            newS=self.ourStack[:]               # copy tuple
            newS=newS+(self.ourQueue[0],)       # add first element from the Queue to copied Stack tuple
            prev=self.prev[:]+"Q"               # update prev
            yield state(newQ, newS,prev)        # yield the state
            

            yield state(newQ, newS,prev) # yield the state

        # only S allowed
        else:
            # S MOVE
            # pop from Stack, push to Queue
            newS=self.ourStack[:-1]             # create a tuple slice excluding last element (it will be popped out)
            newQ=self.ourQueue[:]               # copy tuple
            newQ=newQ+(self.ourStack[-1],)      # add last element from the Stack to copied Queue tuple
            prev=self.prev[:]+"S"               # update prev
            yield state(newQ, newS,prev)        # yield the state
            

    def __str__(self):      # to the state
        return self.prev



    def success(self, finalQueu):      # success condition, if stack == sorted stack
        return (self.ourQueue==finalQueu)


    def __eq__(self, other): # compare two statess to find if they are the same. Not very important
        return isinstance(other, state) and (self.ourQueue is other.ourQueue) 


    def __hash__(self): # hashing the object
        # We will use tuple, which are immutables and thus hashables. We will hash the tuple (x,y), where x and y are also tuples.
        x=(self.ourQueue)
        y=(self.ourStack)
        return(hash((x,y)))
        

# @@@@@@@@@@@@@@@@@@@@@@@@- SOLVE FUNCTION -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# This is the main function that runs the BFS to calculate the minimum
# movements required to reach the final state.
# We add states to a Q queu in order to traverse them.
# We create a set of states that we already have visit in order to avoid repetition.

def solve(initState,finalState): #BFS 
    Q=deque([initState])                # queue to add new state to traverse
    seen=set([initState])               # set to add the visited nodes
    while Q:                            # while Q is not empty
        s=Q.popleft()                   # pop a state from it
        for t in s.accessible():        # add the two accessible states to our queu (if they are not already visited)
            if t.success(finalState):
                # seen.add(t)           # adding the last state won't change anything
                # print(len(seen))      # see the number of all states (helpful for debugging)
                return t                
            if hash(t) not in seen:     # note that we do not parse the whole object to the seen, but the
                seen.add(hash(t))       # hash of that object. Thus we save time+space.
                Q.append(t)             # note also that we search for the hash of that object in the seen

# @@@@@@@@@@@@@@@@@@@@@@@@- MAIN FUNCTION -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

if __name__ == "__main__":
    with open(sys.argv[1], "rt") as inputFile:                       # take call parameters and open the file 
        N = int(inputFile.readline())                                # read N
        ourStack=tuple()                                             # create empty Stack tuple
        ourQueue = list(map(int, inputFile.readline().split()))      # fill the queue. We return a list, so we can be able to sort it.
        finalQueu=ourQueue[:]                                        # copy the Queue to a new list
        finalQueu.sort()                                             # sort that list
        ourQueue=tuple(ourQueue)                                     # convert lists to tuples (which are hashables)
        finalQueu=tuple(finalQueu)

        if (finalQueu==ourQueue):                                   
            print("empty")
        else:
            prev=""                                                  # create the previous strings (empty)
            init = state(ourQueue,ourStack,prev)                     # create initial state 
            print(solve(init,finalQueu))                             # run the BFS and print the result

            

            