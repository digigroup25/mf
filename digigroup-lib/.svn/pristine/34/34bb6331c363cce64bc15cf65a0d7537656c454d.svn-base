package wprolog
{
	import mx.utils.StringUtil;
	
	// Var is a type of Term. 

/** A Term is the basic data structure in Prolog. 
There are three types of terms:
<ol>
<li> Values (ie. have a functor and arguments) </li>
<li> Variables (ie. unbound) </li>
<li>  References (bound to another variable) </li>
</ol>
*/

public final class Term {
	internal var functor:String; 
	internal var arity:int; 
	internal var args:Array;
	internal static var varnum:int=1;
	// If bound is false then term is a free variable
	internal var bound:Boolean; 
	internal var varid:int;
	// If bound is true and deref is true then the term is 
	// a reference to ``ref''
	internal var deref:Boolean; 
	internal var ref:Term;


/** Controls whether occurcheck is used in unification.
Note that in version 1.0 the occurcheck was always performed
which accounted for the lower performance.
*/
	static public var occurcheck:Boolean = false;

/**
prettyprint controls printing of lists as <tt>[a,b]</tt>
rather than <tt>cons(a,cons(b,null))</tt>
*/
	static public var prettyprint:Boolean = true;

/**

Controls whether predicates can begin with an underscore.
Beginning a system with an underscore makes in inaccessible 
to the user.
*/

	static public var internalparse:Boolean = false;



/** create fresh var */
/* 	public function Term() { 
		varid = varnum++;
		bound = false;
		deref = false;
	} */

/** create var with specified varid */
	/* public function Term(i:int) { 
		varid = i;
		bound = false;
		deref = false;
	} */



/** Binds a variable to a term */
	public final function bind(t:Term):void {
		if (this==t) return; // XXXX binding to self should have no effect
		if (!bound) {
			bound = true; deref = true;
			ref = t;
		} else IO.error("Term.bind(" + this + ")" ,
			     "Can't bind nonvar!"); 
	}

/** Unbinds a term -- ie. resets it to a variable */
	public final function unbind():void {
		bound = false; ref=null;
		// XXXX Now possible for a bind to have had no effect so ignore safety test
		// XXXX if (bound) bound = false;
		// XXXX else IO.error("Term.unbind","Can't unbind var!");
	}

/** Used to set specific arguments. A primitive way of 
constructing terms is to create them with Term(s,f) and then 
build up the arguments. Using the parser is much simpler */
	final public function setarg(pos:int, val:Term):void {
		// only to be used on bound terms

		if (bound && (!deref)) 
			args[pos] = val;

		else  IO.error("Term.setarg(" + pos + "," + val + ")",

			    "Can't setarg on variables!");

	}



/** Retrieves an argument of a term */

	public final function getarg(pos:int):Term {

		// should check if pos is valid

		if (bound) {

			if (deref) {return ref.getarg(pos);}

			else {return args[pos];}

		} else {

			IO.fatalerror("Term.getarg", 

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
	private final function occurs(var_:int):Boolean {
		if (varid==var_) return false; 
		else return occurs1(var_);
	}


	private final function occurs1(var_:int):Boolean {
		if (bound) {
			if (deref) return ref.occurs1(var_);
			else { // bound and not deref
					for (var i:int=0 ; i < arity ; i++) 
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

	final public function unify(t:Term, s:Stack):Boolean {
		if (bound && deref) return ref.unify(t,s);
		if (t.bound && t.deref) return unify(t.ref,s);
		if (bound && t.bound) { // bound and not deref
			if (functor == t.getfunctor() && (arity==t.getarity()))
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

	public function refresh(l:Array):Term {
		var t:Term;
		if (bound) {
			if (deref) 
				return ref.refresh(l);
			else { // bound & not deref
				t = TermFactory.create(functor,arity);
				// t.bound = true; t.deref = false; 
				// t.functor = functor; t.arity = arity;
				for (var i:int=0;i<arity;i++) 
					t.args[i] = args[i].refresh(l);
				return t;
			}
		} 
		else //unbound
			return getvar(l,varid);
	}

	private function getvar(l:Array, index:int):Term {
		if (l.length<(index-1) || l[index]==undefined) //3,4, 3,3, 4,3
			l[index] = TermFactory.create();
		return l[index];
	}

/** Displays a term in standard notation */
	public final function toString():String {
		var s:String;
		if (bound) {
		  if (deref) return ref.toString();
		  else {
			if (functor == "null" && arity==0 && prettyprint)
				return "[]";
			if (functor == "cons" && arity==2 && prettyprint) {
				var t:Term; 
				s = "[" + args[0];
				t = args[1];

				while (t.getfunctor() == "cons" &&
					t.getarity() == 2) {
					s = s + "," + t.getarg(0);
					t = t.getarg(1);
				}

				if (t.getfunctor() == "null" &&
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



/** This constructor is the simplest way to construct a term. The term is 
given in standard notation. 
Example <tt>Term(new ParseString("p(1,a(X,b))"))</tt>
@see ParseString
*/

	public function Term(ps:ParseString) {
		if (ps==null) return;
		
		var ts:Array; 
		var i:int=0; 
		var t:Term;
		ts = new Array(); // arbitrary 

		if (Character.isLowerCase(ps.current()) || 
			(internalparse && ps.current() == '_') ) {
			functor = ps.getname();
			bound = true; deref = false;

			if (ps.current() == '(') {
				ps.advance(); ps.skipspace();
				ts[i++] = new Term(ps);
				ps.skipspace();

				while (ps.current() == ',') {
					ps.advance(); ps.skipspace();
					ts[i++] = new Term(ps);
					ps.skipspace();
				}

				if (ps.current() != ')') 
					ps.parseerror("Expecting: ``)''");
				ps.advance();
				args = new Array();
				for (var j:int=0 ; j < i ; j++)
					args[j] = ts[j];
				arity = i;
			} else arity = 0;
		} else

		if (Character.isUpperCase(ps.current())) {
			bound = true; deref = true;
			ref = ps.getvar();
		} else

		if (Character.isDigit(ps.current())) {
			functor = ps.getnum();
			arity = 0;
			bound = true ; deref = false;
		} else

		if (ps.current() =='[') {
			ps.advance();
			if (ps.current() == ']') {
				ps.advance();
				functor = "null"; arity = 0;
				bound = true; deref = false;
			} else {
				ps.skipspace();
				ts[i++] = new Term(ps);
				ps.skipspace();

				while (ps.current()==',') {
					ps.advance(); ps.skipspace();
					ts[i++] = new Term(ps);
					ps.skipspace();
				}


				if (ps.current() == '|') {
					ps.advance(); ps.skipspace();
					ts[i++] = new Term(ps);
					ps.skipspace();
				} else ts[i++] = TermFactory.create("null",0);

				if (ps.current() != ']') 
					ps.parseerror("Expecting ``]''");
				ps.advance();
				bound = true; deref = false;
				functor = "cons"; arity = 2;
				args = new Array();

				for (j=i-2; j>0 ; j--) {
					t = TermFactory.create("cons",2);
					t.setarg(0,ts[j]);
					t.setarg(1,ts[j+1]);
					ts[j] = t;
				}
				args[0] = ts[0]; args[1] = ts[1];
			}
		} else ps.parseerror(
			"Term should begin with a letter, a digit or ``[''");
	}
}
}