import java.util.*;

// Most important class
public class ZSState implements State {

    // data
    ArrayList<Integer> stack = new ArrayList<Integer>();
    ArrayList<Integer> queue = new ArrayList<>();
    String response;
    ArrayList<Integer> finalQueue = new ArrayList<Integer>(); 
    
    // The previous state.
    private State previous;


    // constructor
  public ZSState(ArrayList<Integer> s, ArrayList<Integer> fq, ArrayList<Integer> q, String r, State p) {
    stack = s; 
    finalQueue = fq; 
    queue = q; 
    response = r;
    previous = p;
  }

  // is Final
  @Override
  public boolean isFinal() {
    return queue.equals(finalQueue); // we have to use equals to compare two ArrayLists
  }


  // most important method. Returns an ArrayList of states
  @Override
  public Collection<State> next() {
    
    Collection<State> states = new ArrayList<>(); 
    Integer temp,temp2; // for elements

    // Both moves are eligible 
    if ((stack.size()>0) && (queue.size()>0)){
      // Q move
      ArrayList<Integer> newStack1 = (ArrayList<Integer>)stack.clone();
      ArrayList<Integer> newQueue1 = (ArrayList<Integer>)queue.clone();
      temp = newQueue1.remove(0);
      newStack1.add(temp);
      String newResponse1 = response+"Q";
      states.add(new ZSState(newStack1, finalQueue, newQueue1, newResponse1, this));

      // S move
      ArrayList<Integer> newStack2 = (ArrayList<Integer>)stack.clone();
      ArrayList<Integer> newQueue2 = (ArrayList<Integer>)queue.clone();
      temp2 = newStack2.remove(newStack2.size()-1);
      newQueue2.add(temp2);
      String newResponse2 = response+"S";
      // optimization
      if (temp!=temp2) states.add(new ZSState(newStack2, finalQueue, newQueue2, newResponse2, this));
    }
    else if (queue.size()>0){
      // Q move
      ArrayList<Integer> newStack1 = (ArrayList<Integer>)stack.clone();
      ArrayList<Integer> newQueue1 = (ArrayList<Integer>)queue.clone();
      temp = newQueue1.remove(0);
      newStack1.add(temp);
      String newResponse1 = response+"Q";
      states.add(new ZSState(newStack1, finalQueue, newQueue1, newResponse1, this));

    }
    else {
      // S move
      ArrayList<Integer> newStack2 = (ArrayList<Integer>)stack.clone();
      ArrayList<Integer> newQueue2 = (ArrayList<Integer>)queue.clone();
      temp = newStack2.remove(newStack2.size()-1);
      newQueue2.add(temp);
      String newResponse2 = response+"S";
 
       states.add(new ZSState(newStack2, finalQueue, newQueue2, newResponse2, this));
    
    }
    return states;
  }

  // remained the same
  @Override
  public State getPrevious() {
    return previous;
  }


  @Override
  public String toString() {
    return response;
  }

  // Two states are equal if all four are on the same shore.
  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    ZSState other = (ZSState) o;
    return ((stack.equals(other.stack))&&(queue.equals(other.queue)));
  }

  // Hashing: consider only the positions of the four players.
  @Override
    public int hashCode() {
    return (Objects.hash(queue,stack));
  }
}
