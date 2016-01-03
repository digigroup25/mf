import java.util.*; 

///////////////////////////////////////////////////////////////////////
   class Term 
///////////////////////////////////////////////////////////////////////
{
    public static var CUT:Term= new Cut(0);
    //    public static Term CUT = new Term("!",0);

    static var rnd:Random= new Random();
    public static var trace:Boolean= false;
    
    private var functor:String; 
    private var arity:int; 
    private var args:Array;
    
    // private static int varnum=1;
    static var varnum:int=1;
    
    // If bound is false then term is a free variable
    private var bound:Boolean; 
            var varid:int;
    
    // If bound is true and deref is true then the term is 
    // a reference to ``ref''
    private var deref:Boolean; private var ref:Term;

    public function deref():Term {
        var t:Term= this;
        while (t.bound && t.deref) t=t.ref;
        return t;
    }


    public function bound():Boolean {
        var t:Term= this;
        while (t.bound && t.deref) t=t.ref;
        return t.bound;
    }


/** Controls whether occurcheck is used in unification.
Note that in version 1.0 the occurcheck was always performed
which accounted for the lower performance.
*/
    static public var occurcheck:Boolean= false;

/**
prettyprint controls printing of lists as <tt>[a,b]</tt>
rather than <tt>cons(a,cons(b,null))</tt>
*/
    static public var prettyprint:Boolean= true;

/**
Controls whether predicates can begin with an underscore.
Beginning a system with an underscore makes in inaccessible 
to the user.
*/
    static public var internalparse:Boolean= false;

/** create fresh var */
    public function Term()
    { 
        varid = varnum++;  //  JV??? Necessary ???
        bound = false;
        deref = false;
    }

/** create var with specified varid */
    public function Term(i:int) { 
        varid = i;
        bound = false;
        deref = false;
    }

/** create a term with  a given functor and arity.
@param s - the functor
@param a - the arity
*/
    public function Term(s:String, a:int) {
        functor = s; arity = a;
        bound = true; deref = false;
        args = new Term[arity];
    }

    public function Term(s:String, a:Array) {
        functor = s; arity = a.length ;
        bound = true; deref = false;
        args = a;
    }

    public function Term(op:String, a1:Term, a2:Term)  // Binary Operator
    {
        functor = op; arity = 2;
        bound = true; deref = false;
        args = new Term[2];
        args[0] = a1;
        args[1] = a2;
    }


/** Binds a variable to a term */
    public final function bind(t:Term):void {
        if (this==t) return; // XXXX binding to self should have no effect
        if (!bound) {
            bound = true; deref = true;
            ref = t;
        } 
	else { 
	    error("Term.bind(" + this + ")" ,"Can't bind nonvar!"); 
	    new Throwable().printStackTrace();
	}
    }

/** Unbinds a term -- ie. resets it to a variable */
    public final function unbind():void {
        bound = false; ref=null;
    }

/** Used to set specific arguments. A primitive way of 
constructing terms is to create them with Term(s,f) and then 
build up the arguments. Using the parser is much simpler */
    final public function setarg(pos:int,val:Term):void {
        // only to be used on bound terms
        if (bound & (!deref)) args[pos] = val;
        else  error("Term.setarg(" + pos + "," + val + ")",
                "Can't setarg on variables!");
    }

/** Retrieves an argument of a term */
    public final function getarg(pos:int):Term {
        // should check if pos is valid
        if (bound) {
            if (deref) {return ref.getarg(pos);}
            else {return args[pos];}
        } else {
            fatalerror("FATAL: Term.getarg", 
                      "Error - lookup on unbound term!");
            return null; // dummy ... never reached 
        }
    }

/** Gets the functor of a term */
    public final function getfunctor():String {
        if (bound) {
            if (deref) {return ref.getfunctor();}
            else return functor;
        } else return "";
    }

/** Gets the arity of a term */
    public final function getarity():int {
        if (bound) {
            if (deref) {return ref.getarity();}
            else return arity;
        } else return 0;
    }

/** Checks whether a variable occurs in the term */
// XXXX Since a variable is not considered to occur in itself 
// XXXX added occurs1 and a new front end called occurs.
    final function occurs(var_:int):Boolean {
        if (varid==var_) return false; 
        else return occurs1(var_);
    }

    final function occurs1(var_:int):Boolean {
        if (bound) {
        if (deref) return ref.occurs1(var_);
        else { // bound and not deref
                for (var i:int=0; i < arity ; i++) 
                    if (args[i].occurs1(var_)) return true;
                return false;
            }
        } else // unbound
          return (varid==var_);
    }

/** Unification is the basic primitive operation in logic programming. 
* @param s - the stack is used to store the addresses of variables which are 
bound by the unification. This is needed when backtracking.
*/
    final public function unify(t:Term,s:Stack):Boolean {
        if (bound & deref) return ref.unify(t,s);
        if (t.bound & t.deref) return unify(t.ref,s);
        if (bound & t.bound) { // bound and not deref
            if (functor.equals(t.getfunctor()) & (arity==t.getarity()))
            {
                for (var i:int=0; i<arity ; i++) 
                    if (!args[i].unify(t.getarg(i),s)) 
                        return false;
                return true;

            } 
            else  
                return false; // functor/arity don't match ...

        }  // at least one arg not bound ...
        if (bound) {
        // return t.unify(this,s);
            // XXXX Added missing occur check
            if (occurcheck) {if (this.occurs(t.varid)) return false;}  // XXXX
            t.bind(this);
            s.push(t);
            return true;
        } 
        // Do occurcheck if turned on ...
        if (occurcheck) {if (t.occurs(varid)) return false;}
        this.bind(t);
        s.push(this); // save for backtracking
        return true;
    }

/** refresh creates new variables. If the variables allready exist in 
its argument then they are used - this is used when parsing a clause so 
that variables throught the clause are shared.  Includes a copy operation */

    public final function refresh(l:Array):Term {
        var t:Term;
        if (bound) {
            if (deref) { 
                return ref.refresh(l);
	    }
            else // bound & not deref

		if (arity==0) { 
			return this;     //  JV Idea !!
		    }
            else { // bound & not deref
                t = dup();
                // t = new Term(functor,arity);
                // t.bound = true; t.deref = false; 
                // t.functor = functor; t.arity = arity;
                for (var i:int=0;i<arity;i++) 
                    t.args[i] = args[i].refresh(l);
                return t;
            }
        } else //unbound
            return getvar(l,varid);
    }

    private final function getvar(l:Array, v:int):Term {
        if (l[v]==null) 
            l[v] = new Term();
        return l[v];
    }

// ----------------------------------------------------------
//	Copy a term to put in the database
//	   - with new variables (freshly renumbered)
// ----------------------------------------------------------	
    static var cvdict:Hashtable= new Hashtable();
    static var cvn:int;

    public final function cleanUp():Term {
    	cvdict.clear();
    	cvn = 0;
    	return this.cleanUp2();
    }
    
    public final function cleanUp2():Term {
        var t:Term;
        if (bound) 
        {
            if (deref) 
                return ref.cleanUp2();
            else if (arity==0) return this;    
            else { 
                t = dup();
                // t = new Term(functor,arity);
                for (var i:int=0;i<arity;i++) 
                    t.args[i] = args[i].cleanUp2();
            }
	} 
	else //unbound
        {
            t = Term(cvdict.get( this ));
			if (t==null) {
				t = new Term( cvn++ );
				cvdict.put( this, t);
			}
		}
		return t;
	}

// ----------------------------------------------------------	
    public  function dup():Term // to copy correctly CUT & Number terms
// ----------------------------------------------------------	
    { 
       return new Term(functor,arity); }

// ----------------------------------------------------------	
    public  function toString():String // ----------------------------------------------------------	
    {
        var s:String;
        if (bound) {
          // if (deref) return "v" + varid + "->" + ref.toString();
          if (deref) return ref.toString();
          else {
            if (functor.equals("null") & arity==0& prettyprint)
                return "[]";
            if (functor.equals("cons") & arity==2& prettyprint) {
                var t:Term; 
                s = "[" + args[0];
                t = args[1];

                while (t.getfunctor().equals("cons") &
                    t.getarity() == 2) {
                    s = s + "," + t.getarg(0);
                    t = t.getarg(1);
                }

                if (t.getfunctor().equals("null") &
                    t.getarity() == 0) 
                    s = s + "]";
                else s = s + "|" + t + "]";

                return s;
            } else {
                s = functor;
                if (arity > 0) {
                    s = s + "(";
                    for (var i:int=0; i < (arity - 1); i++) 
                        s =s + args[i].toString() + ",";
                    s = s + args[arity-1].toString() + ")";
                }
            }
            return s;
          }
        } else return ("_" + varid);
    }


    public function value():int {
	var i:int, res = 0;

	if (!bound) IO.error("Term.value","unbound term");
	else if (deref) return ref.value();
	else if (functor == "rnd" && arity==1) 
	    return rnd.nextInt( args[0].value() ); 
	else if (arity<2) 
	    IO.error("Term.value","not-binary");
	else if (functor == "+") 
	    return args[0].value()+args[1].value(); 
	else if (functor == "-") 
	    return args[0].value()-args[1].value(); 
	else if (functor == "*") 
	    return args[0].value()*args[1].value(); 
	else if (functor == "/") 
	    return args[0].value()/args[1].value(); 
	else if (functor == "mod") 
	    return args[0].value() % args[1].value(); 
	else 
	    IO.error("Term.value","unknown operator: " + functor);

	return 0;
    }

    public function isBound():Boolean { return bound(); }

    public final static function error(caller:String,mesg:String):void {
        System.out.print(
            "ERROR: in " + caller + " : " + mesg + "\n");
    }
    
    public final static function fatalerror(caller:String,mesg:String):void {
        System.out.print(
            "FATAL ERROR: in " + caller + " : " + mesg + "\n");
        System.exit(1);
    }

    static function traceln(msg:String):void {
        if (trace) System.out.println(msg);
    }

    public function dump():String {
	return " - Term: " + functor + "/" + arity + ", "
            + (bound? "bound, " : "")
            + (deref? "ref, " : "")
            + varid ;
    }

}

///////////////////////////////////////////////////////////////////////

final class Number extends Term
{
    public function Number( s:String) {
        super(s,0);
        try {
            varid = Integer.parseInt(s);
        } catch (e:Exception) 
            { varid = 0; }
    }
    public function Number( n:int) {
        super(Integer.toString(n).intern(),0);
         varid = n; 
    }

    public function value():int { return varid; }

    public  function dup():Term // to copy correctly CUT & Number terms
    {  
	return new Number( varid ); }
}

   final class Cut extends Term      
//-------------------------------
{    
    
    public function Cut( stackTop:int) 
    {
        super("!",0);
        varid = stackTop;
    }    
    public function toString():String {
        return "Cut->" + varid ;
    }

    public  function dup():Term // to copy correctly CUT & Number terms
    {  
       return new Cut( varid ); }
}




///////////////////////////////////////////////////////////////////////
class TermList 
///////////////////////////////////////////////////////////////////////
{
    var term:Term;
    var next:TermList= null;
    var nextClause:Clause;       // serves 2 purposes: either links clauses in database 
                            //   or points to defining clause for goals

    public function TermList() {}        // for Clause

    public function TermList(t:Term)
    {
            term = t; 
    }
    
    public function TermList(t:Term, n:TermList) {
            term = t; next = n;
    }


    public function toString():String {
	var i:int=0;
        var s:String; var tl:TermList;
        s = new String("[" + term.toString());
        tl = next;
        while (tl != null && ++i < 3) {
            s = s + ", " + tl.term.toString();
            tl = tl.next;
        }
	if(tl!=null) s += ",....";
        s += "]";

        return s ;
    }

    public function resolve(db:KnowledgeBase):void {
	nextClause = Clause(db.get( term.getfunctor() 
                                      + "/" + term.getarity() ));
    }
    public function lookupIn(db:KnowledgeBase):void {
	nextClause = Clause(db.get( term.getfunctor() 
                                      + "/" + term.getarity() ));
    }

}

///////////////////////////////////////////////////////////////////////
final class Clause extends TermList
///////////////////////////////////////////////////////////////////////
{

/*    public Clause(Term t) 
    {
        super(t, null);
    }
*/

    public function Clause(t:Term, body:TermList) 
    {
        super(t, body);
    }


    public final function toString():String {
        return term + " :- " + next;
    }
}

///////////////////////////////////////////////////////////////////////
final  class Primitive extends TermList 
///////////////////////////////////////////////////////////////////////
{
    var ID:int= 0;


    public function Primitive(n:String)
    {
        try {
            ID = Integer.parseInt( n );
        }
        catch (e:Exception) {}
    }
    
    public function toString():String {
        return " <" + ID + "> " ;
    }

}

///////////////////////////////////////////////////////////////////////
final  class Step extends TermList 
///////////////////////////////////////////////////////////////////////
{
    public function Step( t:TermList){
	super();
	next = t.next;
	t.next=this;
	term = new Term("STEP",0);
    }
}