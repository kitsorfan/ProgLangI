 /*
********************************************************************************
  Project     : Programming Languages 1 - Assignment 3 - Exercise QSsort
  Authors     : Stylianos Kandylakis el17088, 
                Kitsos Orfanopoulos el17025
  -----------
 ProgLangI 2021, ECE-NTUA
 *******************************************************************************

 Solution based on the famous gabbage, goat, wolf problem: https://courses.softlab.ntua.gr/pl1/2019a/Labs/goat.tgz

 See also our Python version.
    
 Our solution is based on the solution to the famous Wolf, goat and cabbage problem.
  We represent as nodes the state of the queue and the stack. 
  We model the allowed moves (Q and S), the success condition and the methods to 
  determine whether we have visited again a node.
  We run the BFS and every time we keep the previous step to a string.
  
Attention:  Our solution is exhaustive, we will search all the states, until the desirable one. 
            Given that every state can produce 1, or often 2 other states, we conclude that 
            in general we produce states exponentially (2^n). Our solution can work for small inputs.
            We manage to eliminate some states by noticing (with some help) that if the first element of the 
            queue and the last element of  the stack are the same there is no need  to do an S move.
            This is the Way. 
            */

import java.io.*;     // for I/O methods
import java.util.*;

// This is our main class. It has to be the first, in alphabetical order, in order to be accepted by the Grader. 
public class QSsort {
  // The main function.
  public static void main(String args[]) {
    String inputArg = args[0];
      
		try {
        // reading the input
		    BufferedReader in = new BufferedReader(new FileReader(inputArg));
        String line = in.readLine ();
        String [] a = line.split (" ");
        int N = Integer.parseInt(a[0]); // first line (N)

        line = in.readLine ();  // second line (the initial queue)
        a = line.split (" ");

        // data structures. We use ArrayLists for everything
        ArrayList<Integer> queue = new ArrayList<Integer>();
        ArrayList<Integer> stack = new ArrayList<Integer>();
        ArrayList<Integer> sortedQueue = (ArrayList<Integer>)queue.clone(); // note that we have to use clone. 
        String response = "";


        // Parse the initial queue to the ArrayList
        for (int i = 0; i < N; i++)
            queue.add(Integer.parseInt(a[i]));
        in.close (); //close the buffer
        
        // sortedQueue=queue;
        Collections.sort(sortedQueue);  // Sort the queue

      // ---------

        Solver solver = new ZBFSolver(); //BFS solver 
        State initial = new ZSState(stack, sortedQueue, queue, response, null); //create initial state
        State result = solver.solve(initial); // call the solver

      // check result
        if (result.toString() == "") {
          System.out.println("empty");
        } else {
          System.out.println(result);
        }
		} catch (IOException e) {
			e.printStackTrace();
		}
  }
}
