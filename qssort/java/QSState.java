import java.util.*;
import java.io.*;

/* A class implementing the state of the well-known problem with the
 * wolf, the goat and the cabbage.
 */
public class QSState implements State {


    ArrayList<Integer> stack = new ArrayList<Integer>();
    ArrayList<Integer> queue = new ArrayList<>();
    String response;

    ArrayList<Integer> finalQueue = new ArrayList<Integer>(); 


  // The previous state.
  private State previous;

  public QSState(ArrayList<Integer> s, ArrayList<Integer> fq, ArrayList<Integer> q, String r, State p) {
    stack = s; finalQueue = fq; queue = q; 
    response = r;
    previous = p;
    System.out.print(q+" "+s+" ");

    System.out.println(r);
  }

  @Override
  public boolean isFinal() {
    return stack.equals(finalQueue);
  }

  @Override
  public boolean isBad() {
    return false;
  }

  @Override
  public Collection<State> next() {
    Collection<State> states = new ArrayList<>();
    Integer temp;
    if ((stack.size()>0) && (queue.size()>0)){
      System.out.println("Both move: ");
      // Q move
      // ArrayList<Integer> newStack1 = new ArrayList<Integer>();
      ArrayList<Integer> newStack1 = (ArrayList<Integer>)stack.clone();
      // newStack1 = stack;
      // ArrayList<Integer> newQueue1 = new ArrayList<Integer>();
      ArrayList<Integer> newQueue1 = (ArrayList<Integer>)queue.clone();
      // newQueue1 = queue;
      temp = newQueue1.remove(0);
      newStack1.add(temp);
      String newResponse1 = response+"Q";
      states.add(new QSState(newStack1, finalQueue, newQueue1, newResponse1, this));

      // S move
      // ArrayList<Integer> newStack2 = new ArrayList<Integer>();
      ArrayList<Integer> newStack2 = (ArrayList<Integer>)stack.clone();
      // newStack2 = stack;
      // ArrayList<Integer> newQueue2 = new ArrayList<>();
      ArrayList<Integer> newQueue2 = (ArrayList<Integer>)queue.clone();
      // newQueue2 = queue;
      temp = newStack2.remove(newStack2.size()-1);
      newQueue2.add(temp);
      String newResponse2 = response+"S";

      states.add(new QSState(newStack2, finalQueue, newQueue2, newResponse2, this));
    }
    else if (queue.size()>0){
            // Q move
      // ArrayList<Integer> newStack1 = new ArrayList<Integer>();
      ArrayList<Integer> newStack1 = (ArrayList<Integer>)stack.clone();
      // newStack1 = stack;
      // ArrayList<Integer> newQueue1 = new ArrayList<Integer>();
      ArrayList<Integer> newQueue1 = (ArrayList<Integer>)queue.clone();
      // newQueue1 = queue;
      temp = newQueue1.remove(0);
      newStack1.add(temp);
      String newResponse1 = response+"Q";
      states.add(new QSState(newStack1, finalQueue, newQueue1, newResponse1, this));

    }
    else {
      // S move
      // ArrayList<Integer> newStack2 = new ArrayList<Integer>();
      ArrayList<Integer> newStack2 = (ArrayList<Integer>)stack.clone();
      // newStack2 = stack;
      // ArrayList<Integer> newQueue2 = new ArrayList<>();
      ArrayList<Integer> newQueue2 = (ArrayList<Integer>)queue.clone();
      // newQueue2 = queue;
      temp = newStack2.remove(newStack2.size()-1);
      newQueue2.add(temp);
      String newResponse2 = response+"S";
 
       states.add(new QSState(newStack2, finalQueue, newQueue2, newResponse2, this));
    
    }
    // states.add(new QSState(!man, wolf, goat, cabbage, this));
    // if (man == wolf)
    //   states.add(new QSState(!man, !wolf, goat, cabbage, this));
    // if (man == goat)
    //   states.add(new QSState(!man, wolf, !goat, cabbage, this));
    // if (man == cabbage)
    //   states.add(new QSState(!man, wolf, goat, !cabbage, this));
    return states;
  }

  @Override
  public State getPrevious() {
    return previous;
  }

  @Override
  public String toString() {
    // StringBuilder sb = new StringBuilder("State: ");
    // sb.append("man=").append(man ? "e" : "w");
    // sb.append(", wolf=").append(wolf ? "e" : "w");
    // sb.append(", goat=").append(goat ? "e" : "w");
    // sb.append(", cabbage=").append(cabbage ? "e" : "w");
    return response;
  }

  // Two states are equal if all four are on the same shore.
  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    QSState other = (QSState) o;
    // return ((stack==other.stack) && (queue==other.queue));
    return ((stack.equals(other.stack))&&(queue.equals(other.queue)));
    // return man == other.man && wolf == other.wolf && goat == other.goat
    //   && cabbage == other.cabbage;
  }

  // Hashing: consider only the positions of the four players.
  @Override
  public int hashCode() {

    return (Objects.hash(queue,stack));
  }
}
