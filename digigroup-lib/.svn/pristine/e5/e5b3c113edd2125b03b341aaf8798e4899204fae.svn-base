package wprolog
{
	import mx.controls.List;
	
	/** An engine is what executes prolog queries.
* @author Michael Winikoff
*/

public final class Engine /* extends Thread */ {
/** The stack holds choicepoints and a list of variables
which need to be un-bound upon backtracking.
*/

	private var stack:Stack; 
/** We use a hashtable to store the program */
	private var db:Hashtable; 
	private var goal:TermList;
	private var call:Term;

/** This governs whether tracing is done */
	public var enableTracing:Boolean = true;
/** Used to time how long queries take */
	private var time:Number;

/** A bookmark to the fail predicate */
	private var failgoal:TermList;
/** 

* @param prog An initial program - this will be extended
* @param g The query to be executed
*/

public function Engine(g:Term, prog:Hashtable) {
		var t:Term;
		var t2:Term;
		var tl:TermList;
		stack = new Stack(); 
		goal = TermListFactory.create(g,null);
		call = g;
		// enable underscore as first character of term
		Term.internalparse = true; 
		try {

		db = ParseString.consult(
		   ("eq(X,X). fail :- eq(c,d). print(X) :- _print(X)." +
		    "if(X,Y,Z) :- once(wprologtest(X,R)) , wprologcase(R,Y,Z)."+
		    "wprologtest(X,yes) :- call(X). wprologtest(X,no). " +
		    "wprologcase(yes,X,Y) :- call(X). " +
		    "wprologcase(no,X,Y) :- call(Y)." +
		    "not(X) :- if(X,fail,true). or(X,Y) :- call(X). "+
		    "or(X,Y) :- call(Y)." +
		    "true. call(X) :- _call(X). " +
		    "nl :- _nl. once(X) :- _onceenter , call(X) , _onceleave.")
			,prog,null);
		ParseString.resolve(db);
		} catch (e:Error) {
		  IO.fatalerror("Engine.init","Can't parse default program!");
		}
		Term.internalparse = false; 
		goal.resolve(db);
		failgoal = TermListFactory.create(TermFactory.create("fail",0), null);
		failgoal.resolve(db);
		//setPriority(2);
		//time = System.currentTimeMillis();
	}



final private function dump(clausenum:int):void {
	if (enableTracing) {
		IO.trace_("Goal: " + goal + " clausenum = " + clausenum);
	}
}


final public function runAll():void { 
	var r:String;
	r = run(false); 
	IO.result(r);
}

/** run does the actual work. */
public final function run(embed:Boolean):String { 
	var found:Boolean;
	var func:String;
	var arity:int;
	var clausenum:int;
	var clause:TermList;
	var nextclause:TermList;
	var ts1:TermList;
	var ts2:TermList;
	var t:Term;
	var o:Object;
	var cp:ChoicePoint;
	var vars:Stack;
	clausenum = 1;

	while (true) {
		if (goal==null) {
			return "Yes: "+call;
			/* var r:Runtime = Runtime.getRuntime();
			r.gc();
			var totalmem:Number = r.totalMemory();
			var currentmem:Number = r.freeMemory();
		
			var percent:Number = (100 * (totalmem - currentmem)) / totalmem;
			totalmem = totalmem / 1000000.0;
		
			return ("Yes: " + call +  "\n(approx. " + 
				(System.currentTimeMillis() - time) + " ms., memory used: " +
				percent + "% out of " + totalmem + " Mb)"); */
		}
		
		if (goal.term==null) {
			IO.fatalerror("Engine.run","goal.term is null!");
		}
			func = goal.term.getfunctor();
			arity = goal.term.getarity(); // is this needed?
			dump(clausenum);
		
			if (func.charAt(0) != '_') { 
			// ie the goal is not a system predicate AAA
				// if there is an alternative clause push choicepoint:
				if (goal.numclauses > clausenum)
					stack.push(new ChoicePoint(clausenum +1, goal));
		
				if (clausenum > goal.numclauses) {
					clause = failgoal;
					IO.diagnostic(func + "/" + arity + " undefined!");
					clause = TermListFactory.create(TermFactory.create("fail",0), goal);
					clause.resolve(db);
				} else 
					clause = goal.definer[clausenum];
		
				clausenum = 1; // reset ...
				// check unification ...
				vars = new Stack(); // XXX arbitrary limit
				if (clause.term.refresh(vars).unify(goal.term,stack)) {
					clause = clause.next;
					// refresh clause -- need to also copy definer 
					if (clause != null) {
						ts1 = TermListFactory.create(clause.term.refresh(vars), null,clause);
						ts2 = ts1;
						clause = clause.next;
		
					while (clause != null) {
						ts1.next = TermListFactory.create(clause.term.refresh(vars), null,clause);
						ts1 = ts1.next;
						clause = clause.next;
					}
		
					// splice together refreshed clause and other goals
					ts1.next = goal.next;
					goal = ts2;
		
					// For GC purposes drop references to data that is not 
					// needed 
					 t = null; ts1 = null; ts2 = null; vars = null; 
					 clause = null; nextclause = null; func = null;
					} else { // matching against fact ...
					goal = goal.next;
					}
				} else { // unify failed - backtrack ...
					goal = goal.next;
					found = false;
					while (! stack.empty()) {
						o = stack.pop();
						if (o is Term) {
							t = Term (o);
							t.unbind();
						} else if (o is ChoicePoint) {
							cp = ChoicePoint(o);
							goal = cp.goal;
							clausenum = cp.clausenum;
							found = true;
							break;
						} // else if integer .. iterative deepening 
						// not implemented yet
					    }
					    // stack is empty and we have not found a choice 
					    // point ... fail ...
					    if (!found) {
						    return "No."; // IO.result("No.");
					    }
				}
		
			} // AAA
			else if (func=="_print" && arity==1) {
				IO.prologprint(goal.term.getarg(0).toString());
				goal = goal.next;
			}
			else if (func=="_nl" && arity==0) {
				IO.prologprint("\n");
				goal = goal.next;
			}
			else if (func == "_call" && arity==1) {
				var templist:TermList = TermListFactory.create(goal.term.getarg(0),null);
				templist.resolve(db);
				templist.next = goal.next;
				goal = templist;
			}
		
			// The next two together implement once/1
			else if (func == "_onceenter" && arity==0) {
				stack.push(new OnceMark());
				goal = goal.next;
			}
		
			else if (func == "_onceleave" && arity==0) {
				// find mark, remove mark and all choicepoints above it.
				var tempstack:Stack = new Stack();
				o = stack.pop();
		
				while (! (o is OnceMark))  {
					// forget choicepoints
					if (! (o is ChoicePoint)) tempstack.push(o);
					o = stack.pop();
				}
		
				while (! (tempstack.empty())) 
					stack.push(tempstack.pop());
		
				tempstack = null;
				goal = goal.next;
			}
			else {
			IO.diagnostic("Unknown builtin: " + func + "/" + arity);
			goal = goal.next;
			}
	} // while
	return null;
} // run



/** Used from the GUI when the user hits <em>more</em>. All it does is add 
<tt>fail</tt> to the goal and lets the engine do the rest. */
final public function more():void {
	goal = TermListFactory.create(TermFactory.create("fail",0), goal);
	goal.resolve(db);
	//time = System.currentTimeMillis();
	this.runAll();
}
} // Engine
}