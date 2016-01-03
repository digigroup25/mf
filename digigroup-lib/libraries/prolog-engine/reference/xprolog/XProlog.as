//////////////////////////////////////////////////////
//
//  XProlog.java: the successor to Winikoff's WProlog
//  =================================================
//  Jean Vaucher
//  Email:  vaucher@iro.umontreal.ca
//  WWW:    www.iro.umontreal.ca/~vaucher/
// ------------------------------------------------------------------------
//  This work was carried out at CIRANO, the Center for Interuniversity
//  Research and Analysis on Organizations [www.cirano.qc.ca] during the
//  author's sabbatical year
// -----------------------------------------------------------------------
// 
//  This Prolog was developped to be used the handle the knowledge
//  and reasoning needs of Java based Agents.  It should be reasonably
//  fast and compact so that every agent could have its own KB and
//  inference engine.
//
//  Compared to several other "freeware" Prologs, WProlog turned out
//  to be remarkably fast.  However, it was weak in several areas:
//    - no assert/retract
//    - no arithmetic
//    - primitive syntax with no operators... not even the cut "!"
//    - it was wasteful of memory
//
//  Modifications:  Version 1.0  (april 2002)
//    - changed Parser to use one generated by JavaCC
//    - implemented the CUT (and "!" operator)
//    - added assert/retract
//    - added integer arithmetic:  +, -, *, /, mod
//      and comparisons:  ==, !=, >, <, >=, =<
//    - reduced memory use and improved running speed
//
// -----------------------------------------------------------------------
// WProlog : the original software by Michael Winikoff 
//           URL: http://goanna.cs.rmit.edu.au/~winikoff/wp/
//
// Version 1.0: 27/9/96 - 16/10/96
// Version 1.1: 20 January 1997
// Version 1.2:  2 April 1997
// Version 1.2.1: 19 August 1999 (fixed bug with unification of variable
//          to itself.
/////////////////////////////////////////////////////////////////
//  Benchmark results:  "path.pro" ==>   ?- solve(p(2,2),L).
//   started at 150 sec.
//    86 sec - Mac G4 with OsX & java 1.3.1
//    46 sec - Linux PC & java 1.3.1
// -------------------------------------------------------------
// May 6:  - added primitive "var(X)" 
//         - fixed "null reference" problem when backtracking to 
//             undefined predicate.
// -------------------------------------------------------------
// May 31:  - Added "sequences" to grammar, i.e.:  "  a,(b,c,d),x ,
//          - as well as IF and OR:
//     ...( a,b ; c,d,f )  ==> or([a,b],[c,d,f])
//     ...( tests -> true_part ; false_part )  ==>  if( [tests],[true_parft],[f_part])
// -------------------------------------------------------------
// To Do:
//   - handle commands when consulting files, i.e. print & consult
//   - check out behaviour for "not ( sequence of goals )"
//   - assert of rules (now is just facts)
//   - GET and SET


package xprolog {
	public class XProlog {

    public static function main(args:Array):void {
        // insert code here...
        System.out.println("Hello World!");
    }
    
    public static var VERSION:String= "XProlog v.1.3, May 2002";
}



/** This is a simple record. A choicepoint contains the continuation
(a goal list) and the next clause to be tried. */

final class ChoicePoint  
{
    var goal:TermList;
    var clause:Clause;

    public function ChoicePoint(g:TermList, c:Clause) {
        goal = g; clause = c;
    }

    public final function toString():String {
        return ("  ||" + clause + "||   ");
    }
}

/** An engine is what executes prolog queries.
* @author Michael Winikoff
*/

final class Engine extends Thread 
{
    public var fini:Boolean= false;

    var parser:Parser;
    var inq:LinkedList= new LinkedList();
            
/** The stack holds choicepoints and a list of variables
which need to be un-bound upon backtracking.
*/
    private var stack:Stack; 
    var agent_id:int= 0;

/** We use a KnowledgeBase to store the program */

    private var db:KnowledgeBase; 
    private var goal_list:TermList;
    private var call:TermList;

/** This governs whether tracing is done */
    public var trace:Boolean= false;
    public var stepFlag:Boolean= false;

/** Used to time how long queries take */
    private var time:Number;

/** Variables to handle backtrackable "retract" without
    growing the stack  */

    private var retractClause:Clause;
    private var cp:ChoicePoint;
    
//------------------------ Enquiry Methods -------------------

    public function answer():TermList {
        return call;
    }

    public function getTime():Number {
        return System.currentTimeMillis() - time;
    }


//------------------------------------------------------------
    public function Engine()
//------------------------------------------------------------
    {
	agent_id = PostOffice.register( inq );
        db = new KnowledgeBase();

        parser = new Parser( new StringReader(

                 "    !      := 1. " 
               + "call(X)    := 2 ." 
               + "fail       := 3 ." 
               + "consult(X) := 4 ." 
               + "assert(X)  := 5 ." 
               + "asserta(X) := 6 ." 
               + "retract(X) := 7 . retract(X) :- retract(X)." 
    //         + "retractall(X/Y) := 29 ." 

               + "listing    := 8 ." 
               + "listing(X/Y) := 9 ." 
               + "listing([])." 
               + "listing([A|Tail]):- listing(A), listing(Tail)." 
               + "print(X)   := 10 ."  
               + "println(X) := 11." 
               + "nl       := 12." 
               + "trace    := 13."
               + "notrace  := 13."
               + "step     := 14."
               + "nostep   := 14."
               + "X is Y   := 15."
               + "X > Y    := 16."
               + "X < Y    := 17."
               + "X == Y   := 18."
               + "X >= Y   := 19."
               + "X <= Y   := 20."
               + "X != Y   := 21."
               + "quit     := 22."
               + "var(C)   := 23."
               + "self(S)  := 24."
               + "send(D,M)    := 25."
               + "shout(M)     := 26."
               + "broadcast(M) := 26."
               + "receive(S,M) := 27."
               + "dumpQ        := 28."

               + "retractall(X/Y) := 29 ." 
               + "seq(X)        := 30 ." 
               
               + "set(X,Y)      := 31 ." 
               + "get(X,Y)      := 32 ." 
               + "gensym(X)     := 33 ." 

               + "X=X.  eq(X,X). true." 
               + "not(X) :- X, !, fail.  not(X). "
               + "if(X, Yes, _ ) :- seq(X), !, seq(Yes)."
               + "if(X, _  , No) :- seq(No)."
               + "if(X, Yes) :- seq(X), !, seq(Yes)."
               + "if(X, _  )."
               + "or(X,Y) :- seq(X). or(X,Y) :- seq(Y)." 
               + "once(X) :- X , !." 
               ));
        // Parser.primitives( db );
        parser.primitives( db );

        stack  = new Stack(); 
        retractClause = Clause(db.get("retract/1"));

        setPriority(2);

    }

    public function Engine(pgm:String)
    {
        this();
        // Parser.ReInit( new StringReader( pgm ));
        // Parser.Program( db );
        new Parser( new StringReader( pgm )).Program( db );
    }

    public function Engine(file:Reader)
    {
        this();
        //Parser.ReInit( file );
        //Parser.Program( db );
        new Parser( file ).Program( db );
    }

    public function consult( fName:String):void 
    {
        try {
            new Parser( new FileReader(fName)).Program( db );
        }
        catch (e:FileNotFoundException) {
          IO.fatalerror("consult", fName+ " NOT Found!");
        }
        // db.dump();
    }

    public function setQuery( query:String):Boolean 
    {
        // goal_list = Parser.getList( query );
        goal_list = parser.getList( query );
        call = goal_list;
        goal_list.resolve(db);
        stack.clear();
        return solve();
    }

final public function run():void { 
    solve();
}

    // int stackTop = 0;

/** run does the actual work. */
final public function solve():Boolean { 
    var stack2:Stack= new Stack();
    var stackTop:int= 0;

    var func:String;
    var arity:int;
    var clause:TermList=null, 
             nextclause;
    var    vars:Array=null;

    time = System.currentTimeMillis();

    while (true) 
    {
        stackTop = stack.size(); 

        if (goal_list instanceof Step) {
            goal_list = goal_list.next;
	    if (goal_list!=null) goal_list.lookupIn(db);	    
	    stepFlag = trace = true;
        }
        if (trace){
            // System.out.println("\nSTACK: " + stack);
            dumpGoal() ;
        }
        if (stepFlag) step();

        if (goal_list==null) {
            return true;
        }

        if (goal_list.term==null) {
            IO.fatalerror("Engine.run","goal.term is null!");
        }

        func = goal_list.term.getfunctor();
        arity = goal_list.term.getarity(); // is this needed?

        if (goal_list.nextClause==null) 
        {
            if (trace) 
                IO.diagnostic( goal_list.term.getfunctor() + "/" + 
                           goal_list.term.getarity() + " undefined!");
            if ( !backtrack() ) 
		return false;
	    else
		continue;
        }

	clause = goal_list.nextClause;
	if (clause.nextClause != null) 
	    stack.push( cp=new ChoicePoint(goal_list, clause.nextClause));

        vars = new Term[ Parser.maxVarnum ]; 
        var xxx:Term= clause.term.refresh(vars); 

        if (xxx.unify(goal_list.term, stack)) 
        {
            clause = clause.next;

            if (clause instanceof Primitive) 
            {
                if (!doPrimitive( goal_list.term, clause )
                        && !backtrack()) 
		        return false;
            }
            else if (clause == null) // matching against fact ...
	        {
                goal_list = goal_list.next;
                if (goal_list != null) goal_list.lookupIn(db);
            }

            else  // replace goal by clause body
            {   
                var p:TermList, p1=null, ptail=null; 

                for (var i:int=1; clause != null; i++) {
                    if (clause.term == Term.CUT)
                        p = new TermList(new Cut(stackTop));
                    else
                        p = new TermList( clause.term.refresh(vars));
                    if (i==1)
                        p1 = ptail = p;
                    else {
                        ptail.next = p;
                        ptail = p;
                    }
                    clause = clause.next;
                }
                // System.out.println("Refreshed clause: " + p1);
                ptail.next = goal_list.next;
                goal_list = p1;
                goal_list.lookupIn(db);
            }
        }

        else {                   // unify failed - backtrack ...

            if (! backtrack()) {
                return false;
            }
        }

    } // while
} // run


function backtrack():Boolean // returns TRUE if choice point was found
{
    var o:Object;
    var cp:ChoicePoint;
    var t:Term;
    var found:Boolean= false;

    if (trace) System.out.println(" <<== Backtrack: " );
    while (! stack.empty()) 
    {
        o = stack.pop(); // System.out.println("      Pop: " + o);

        if (o instanceof Term) {
            t = Term(o);
            t.unbind();
        } else if (o instanceof ChoicePoint) {
            cp = ChoicePoint(o);
            goal_list = cp.goal;
            goal_list.nextClause = cp.clause;
            found = true;
            // System.out.println("      CP: " + cp);
            break;
        } 
    }
    return found;
}

/* --------------------------------------------------------------------
   Primitives:
     1: cut
     2: call
     3: fail
     4: consult
     5: assert
     6: asserta
     7: retract
     8: listing
     9: listing(full) or listing( <functor>/<arity> )
    10: print
    11: println
        etc...
*/

static var gensymInt:int= 0;

function doPrimitive( term:Term, c:TermList):Boolean // returns false if FAIL
{
    // Primitive p = (Primitive) c;
    var t2:Term;

    switch( (Primitive(c)).ID )
    {
    case 1:      // CUT
        removeChoices( term.varid ); 
        break;

    case 2:      // call
        goal_list = new TermList(term.getarg(0),goal_list.next);
        goal_list.resolve(db);
        return true;

    case 3:      // fail
        return false;

    case 4:      // consult
        var fName:String=  term.getarg(0).getfunctor();
        try {
            db.consult( fName );
            break;
        }
        catch (e:FileNotFoundException) {
          IO.fatalerror("consult", fName+ " NOT Found!");
	  return false;
        }
        catch (e:ParseException){
            IO.error("Consult","parseException");
            return false;
        }
        
    case 5:      // assert
        db.assert(term.getarg(0));
        break;

    case 6:      // asserta
        db.asserta(term.getarg(0));
        break;

    case 7:      // retract
        var r:Boolean= db.retract(term.getarg(0),stack);
        if (!r) {
            backtrack();
            return false;
        }
        else
            cp.clause = retractClause;
        break ;

    case 29:      // retractall
	    t2 = term.getarg(0);
        if ( t2.getfunctor().equals("/") && t2.getarity()== 2){
            db.retractall(t2.getarg(0),t2.getarg(1));
	}
        else
            return false;
        break ;

    case 8:      // listing
        db.dump(false);
        break ;

    case 9:      // listing(Term)
	    t2 = term.getarg(0);
        if ( t2.getfunctor().equals("/") && t2.getarity()== 2){
            db.list(t2.getarg(0),t2.getarg(1));
	    }
        else
            db.dump(true);
        break ;

    case 10:      // print
        IO.prologprint(term.getarg(0).toString());
        break ;

    case 11:      // println
        IO.prologprint(term.getarg(0).toString()+"\n");
        break ;

    case 12:      // nl
        IO.prologprint("\n");
        break ;

    case 13:      // trace      
        trace = term.getfunctor().equals("trace");;
        System.out.println("Trace " + (trace? "ON" : "OFF"));
        break ;

    case 14:      // step
        stepFlag = term.getfunctor().equals("step");
	trace = stepFlag;
        System.out.println(" => Step: " + (stepFlag? "ON" : "OFF"));
        break ;

    case 15:      // is
        var rhs:Term= term.getarg(0).deref();
        var lhs:int= term.getarg(1).value();
        if (rhs.isBound()) return false;
        rhs.bind(new Number(lhs));   stack.push(rhs);
        break ;

    case 16:      // >
        if( term.getarg(0).value() > term.getarg(1).value())
            break;
        return false ;

    case 17:      // <
        if( term.getarg(0).value() < term.getarg(1).value())
            break;
        return false ;

    case 18:      // ==
        if( term.getarg(0).value() == term.getarg(1).value())
            break;
        return false ;

    case 19:      // >=
        if( term.getarg(0).value() >= term.getarg(1).value())
            break;
        return false ;

    case 20:      // <=
        if( term.getarg(0).value() <= term.getarg(1).value())
            break;
        return false ;

    case 21:      // !=
        if( term.getarg(0).value() != term.getarg(1).value())
            break;
        return false ;

    case 22:      // quit
        fini = true;
        break;

    case 23:      // var
	// System.out.println( "Term: " + term.getarg(0));
        if (term.getarg(0).bound()) return false ;
        break;

    case 24:      // self
        lhs = agent_id;
        rhs = term.getarg(0);
        if (rhs.isBound()) return false;
        rhs.bind(new Number(lhs));   stack.push(rhs);
        break ;

    case 25:      // send(D,M)
	var a1:Term=  term.getarg(0).deref();
	var a2:Term=  term.getarg(1);

	if (! (a1 instanceof Number)) return false;
	PostOffice.send( agent_id, a1.value(), a2.cleanUp() );
	break;

    case 26:      // broadcast( Msg )
	PostOffice.broadcast( agent_id, term.getarg(0).cleanUp() );
        break ;

    case 27:      // receive( Src, Msg)
	if ( inq.size()<1) return false;  //  Empty queue -> fail
	var m:Message= Message(inq.removeFirst());
	       a1 =  term.getarg(0);
	       a2 =  term.getarg(1);

        if ( a1.unify( new Number(m.source), stack) 
          && a2.unify( m.content, stack) ) 
	    break;
	return false;

    case 28:      // dumpq

	System.out.println("INQ:" + inq + " " );
        break ;

    case 30:      // seq( <list> )
    
    	splice_goal_list( term );
    	return true;
    	
    case 31:      // set(X,Y)
        db.set( term.getarg(0), term.getarg(1));
        break;

    case 32:      // get(X)
    
    	t2 = Term(db.get( term.getarg(0) ));
    	
    	if (t2==null) return false;

        var xxx:Term= t2.refresh(new Term[ Parser.maxVarnum ]); 

        if (xxx.unify(term.getarg(1), stack)) break;
        return false;

    case 33:      // gensym(X)

    	t2 = new Term("v" + gensymInt++,0);
    	
        if (t2.unify(term.getarg(0), stack)) 
	    break;
        else return false;


    default :
        IO.diagnostic("Unknown builtin: " + term);
        return false;
    }
    goal_list = goal_list.next;
    if (goal_list != null) goal_list.lookupIn(db);
    return true;
}

function removeChoices(n:int):void {
    var o:Object;
    var stack2:Stack= new Stack();
    var i:int= stack.size();
    while ( i > n ) {
        o = stack.pop();
        if (! (o instanceof ChoicePoint)) stack2.push(o);
        i--;
    }        
    while (! (stack2.empty())) 
        stack.push(stack2.pop());
}

//--------------------------------------------------
    function splice_goal_list( term:Term):void //--------------------------------------------------
	{	var t2:Term;
		var p:TermList, p1=null, ptail=null; 
        // Term vars[]  = new Term[ Parser.maxVarnum ]; 
		var i:int=0;

    	term = term.getarg(0); 
		while (term.getfunctor() != "null")
		{
			t2 = term.getarg(0); 
			if (t2 == Term.CUT)
				p = new TermList(new Cut( stack.size() ));
			else
				// p = new TermList( t2.refresh(vars));
				p = new TermList( t2 );
			if (i++ == 0)
				p1 = ptail = p;
			else {
				ptail.next = p;
				ptail = p;
			}
			term = term.getarg(1);
		}
		
		ptail.next = goal_list.next;
		goal_list = p1;
		goal_list.lookupIn(db);
	}

function dumpGoal():void {
    System.out.println();
    System.out.println(     "= Goals: " + goal_list);
    if (goal_list!= null) 
    {
        System.out.println( "==> Try:  " + goal_list.nextClause);
    }
}    


/** Used from the GUI when the user hits <em>more</em>. All it does is add 
<tt>fail</tt> to the goal and lets the engine do the rest. */

final public function more():Boolean {
    time = System.currentTimeMillis();
    if (!backtrack()) return false;
    return solve();
}

var MoreF:BufferedReader=null;

function step():void {
    System.out.print("More:"); System.out.flush();
    var F:BufferedReader;
    try {
        if (MoreF==null)
            MoreF = new BufferedReader(null/* 
                      new InputStreamReader( System.in ) */) ;
        var s:String= MoreF.readLine().trim();
        if (s.equals("")) return;
        else if (s.equals("q")) 
	    stepFlag=false; 
        else if (s.trim().equals("s")) {
	    stepFlag=false; trace=false;
	    new Step(goal_list);
	} 
        else if (s.trim().equals("a")) {
	    goal_list=null;
	    stepFlag=trace=false;
	} else {
	    System.out.println(
              "   <CR>, 'q': Quit, 's': Skip, 'a': Abort");
	    step();
	}
    }
    catch(e:IOException)  { }
}
    

} ////////////////////////// Engine //////////////////////////////


/** The class IO simply centralises all IO for easy modification */
class IO {

    public final static function error(caller:String,mesg:String):void {
        System.out.print(
            "ERROR: in " + caller + " : " + mesg + "\n");
    }

    // fatal error ...
    public final static function fatalerror(caller:String,mesg:String):void {
        System.out.print(
            "FATAL ERROR: in " + caller + " : " + mesg + "\n");
        System.exit(1);
    }

    public final static function result(s:String):void {
        System.out.print(s+"\n");
    }

    public final static function diagnostic(s:String):void {
        System.out.print("*** "+s+"\n");
    }

    public final static function trace(s:String):void {
        System.out.print(s+"\n");
    }

    public final static function prologprint(s:String):void {
        System.out.print(s);
    }
}
}
