import 'dart:math';

void main() {
  // instantiate the machine with two gumballs.
  var gumballMachine = GumballMachine(2);
  // use callback actions to modify the state of the machine.
	// modifying the state of the machine changes the callback actions.
  gumballMachine.insertQuarter();
  gumballMachine.turnCrank();
}

class GumballMachine {
  // This object contains many callback actions that modify the state conditionally.
  late State soldOutState;
  late State noQuarterState;
  late State hasQuarterState;
  late State soldState;
  late State winnerState;
  // The state of the machine is stored in this variable.
  late State state;
  // The number of gumballs in the machine.
  int count = 0;

  // Constructor. GumballMachine class takes in the number of gumballs in the machine.
  GumballMachine(this.count) {
    // Constructor. these callbacks are for each state of the machine. 
		// They contain actions that can conditionally modify state.
    soldOutState = SoldOutState(this);
    noQuarterState = NoQuarterState(this);
    hasQuarterState = HasQuarterState(this);
    winnerState = WinnerState(this);
    soldState = SoldState(this);
		// Constructor. Set the initial state.
    if (count > 0) {
      state = noQuarterState;
      return;
    } else {
      state = soldOutState;
    }
  }

// setter and getters
  void setState(State state) {
    this.state = state;
  }

  getQuarterState() => hasQuarterState;
  getNoQuarterState() => noQuarterState;
  getSoldState() => soldState;
  getSoldOutState() => soldOutState;
  getWinnerState() => winnerState;
  getCount() => count;

  // methods that call the actions of the appropriate interfaced state.
  void insertQuarter() => state.insertQuarter();
  void ejectQuarter() => state.ejectQuarter();
  void turnCrank() {
    state.turnCrank();
    state.dispense();
  }

// method that does not deal with the state variable, but instead handles
// the gumball variable. 
  void releaseBall() {
    print("A gumball comes rolling out the slot...");
    if (count != 0) {
      count = count - 1;
    }
  }
}

// 1) an interface of state class with action methods ultimately replaced 
// else-if statements.
// each new class contains a callback method to change the state class.
// every action of the system are represented by this methods.
 
abstract class State {
  insertQuarter();
  ejectQuarter();
  turnCrank();
  dispense();
}

// The gumballMachine is the master of the state which is acted upon 
// by the callback methods contained in the state classes.
// Each state class contains the logic for the actions that affect 
// the state of the machine.

class NoQuarterState implements State {
  GumballMachine gumballMachine;

  NoQuarterState(this.gumballMachine);

  @override
  void insertQuarter() {
    print("You inserted a quarter");
    gumballMachine.setState(gumballMachine.getQuarterState());
  }

  @override
  void ejectQuarter() {
    print("You haven't inserted a quarter");
  }

  @override
  void turnCrank() {
    print("You turned, but there's no quarter");
  }

  @override
  void dispense() {
    print("You need to pay first");
  }
}

class HasQuarterState implements State {
  //random number generator between 1 and 10.
  int random = Random().nextInt(10) + 1;

  GumballMachine gumballMachine;

  HasQuarterState(this.gumballMachine);

  @override
  void insertQuarter() {
    print("You can't insert another quarter");
  }

  @override
  void ejectQuarter() {
    print("Quarter returned");
    gumballMachine.setState(gumballMachine.getNoQuarterState());
  }

  @override
  void turnCrank() {
    print("You turned...");
    int winner = Random().nextInt(10) + 1;
    if (winner == random) {
      gumballMachine.setState(gumballMachine.getWinnerState());
    } else {
      gumballMachine.setState(gumballMachine.getSoldState());
    }
  }

  @override
  void dispense() {
    print("No gumball dispensed");
  }
}

class SoldState implements State {
  GumballMachine gumballMachine;

  SoldState(this.gumballMachine);

  @override
  void insertQuarter() {
    print("Please wait, we're already giving you a gumball");
  }

  @override
  void ejectQuarter() {
    print("Sorry, you already turned the crank");
  }

  @override
  void turnCrank() {
    print("Turning twice doesn't get you another gumball!");
  }

  @override
  void dispense() {
    gumballMachine.releaseBall();
    if (gumballMachine.getCount() > 0) {
      gumballMachine.setState(gumballMachine.getNoQuarterState());
      return;
    }
    print("Oops, out of gumballs!");
    gumballMachine.setState(gumballMachine.getSoldOutState());
  }
}

class SoldOutState implements State {
  GumballMachine gumballMachine;

  SoldOutState(this.gumballMachine);

  @override
  void insertQuarter() {
    print("You can't insert a quarter, the machine is sold out");
  }

  @override
  void ejectQuarter() {
    print("You can't eject, you haven't inserted a quarter yet");
  }

  @override
  void turnCrank() {
    print("You turned, but there are no gumballs");
  }

  @override
  void dispense() {
    print("No gumball dispensed");
  }
}

class WinnerState implements State {
  GumballMachine gumballMachine;

  WinnerState(this.gumballMachine);

  @override
  void insertQuarter() {
    print("Please wait, we're already giving you a gumball");
  }

  @override
  void ejectQuarter() {
    print("Sorry, you already turned the crank");
  }

  @override
  void turnCrank() {
    print("Turning twice doesn't get you another gumball!");
  }

  @override
  void dispense() {
    print("YOU'RE A WINNER! You get two gumballs for your quarter");
    gumballMachine.releaseBall();
    if (gumballMachine.getCount() > 0) {
      gumballMachine.releaseBall();
      if (gumballMachine.getCount() > 0) {
        gumballMachine.setState(gumballMachine.getNoQuarterState());
        return;
      }
    }
    print("Oops, out of gumballs!");
    gumballMachine.setState(gumballMachine.getSoldOutState());
  }
}