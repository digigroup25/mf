package wprolog
{
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	
	
/** Parsing library */

public final class ParseString  {

	private var str:String;

	private var posn:int;
	private var start:int;
	private var varnum:int;

/** source stores a pointer to the TextField (for the query) or the 
TextArea (for the program) so if an error occurs in parsing we can highlight
the correct part of GUI.
*/

	private var source:TextArea /*TextComponent*/;
/** The hashtable stores indeces for variables that have been encountered.
It isn't automatically reset since we want to have variables common 
in a clause */

	private var vardict:Hashtable;

	final public function toString():String {
		return "{" + str.substring(0,posn) + " ^ " + 

			str.substring(posn) + " | " + vardict + " }";

	}

/** Initialise variables */

	public function ParseString(s:String, tc:TextArea) {
		str = s; source = tc;
		posn = 0; start = 0; varnum = 0;
		vardict = new Hashtable();
	}

/** Get the current character */

	final public /* char */ function current():String {

		if (this.empty()) return '#'; //  can't be space

		else return str.charAt(posn);

	}

/** Is the parsestring empty? */
	final public function empty():Boolean {
		return posn == (str.length);
	}

/** Move a character forward */
	final public function advance():void {
		posn ++;
		if (posn >= str.length) 
			posn = str.length;
	}



	// all three get methods must be called before advance.

/** Recognise a name (sequence of alphanumerics) */
	final public function getname():String {
		var s:String;
		start = posn; posn ++;
		while ( Character.isDigit(this.current()) ||
			Character.isLowerCase(this.current()) ||
			Character.isUpperCase(this.current())) 
			posn++;

		s = str.substring(start,posn);
		if (posn >= str.length) 
			posn = str.length; 
		return s;
	}

/** Recognise a number */
	public function getnum():String {
		var s:String;
		start = posn; posn ++;
		while (Character.isDigit(this.current())) 
			posn++;

		s = str.substring(start,posn);
		if (posn >= str.length) posn = str.length ; 
		return s;
	}



/** Get the Term corresponding to a name. If the name is new, then create a 
new variable */

	final public function getvar():Term {
		var s:String; 
		var t:Term;
		s = this.getname();
		t = Term (vardict.get_(s));

		if (t==null) {
			t = TermFactory.create("", -1, varnum++); // XXXX wrong varnum??
			vardict.put(s,t);
		}
		return t;

	}

/** Handle errors in one place */
	final public function parseerror(s:String):void {
		IO.diagnostic("Unexpected character : " + s);
		
		source.setFocus();
		source.selectionBeginIndex = posn;
		source.selectionEndIndex = posn+1;
		//select(posn,posn+1);
		throw new Error();
	}



/** Skip spaces. Also skips Prolog comments */
	final public function skipspace():void {
		while (Character.isSpace(this.current()))
			this.advance();
		skipcomment();
	}

	final private function skipcomment():void {
		if (current() == '%')  {
			while (current() != '\n' && current() != '#') advance();
			skipspace();
		}

		if (current() =='/') {
			advance();
			if (current() !='*') parseerror("expecting ``*''");
			else {
				advance();
				while (current() != '*' && current() != '#')
					advance();
				advance();
				if (current() !='/') 
					parseerror("expecting ``/''");
				advance();
			}
			skipspace();
		}
	}

/** This resets the variable dictionary. */
	final public function nextclause():void {
		// create new variables for next clause
		vardict = new Hashtable();
		varnum = 0;
	}

/** This takes a hashtable and extends it with the clauses in the string. 
@param db - an initial program, it is augmented with the clauses parsed.
@param s - a string representing a Prolog program 
*/

	public static function consult(s:String, db:Hashtable, /*TextComponent */tc:TextArea):Hashtable {
		var ps:ParseString = new ParseString(s,tc); 
		var func:String;
		var prevfunc:String;
		var index:String;
		var clausenum:int;
		var arity:int;
		var prevarity:int;
		var tls:TermList;

		ps.skipspace();
		prevfunc = ""; prevarity = -1;
		clausenum = 1;

		while (! ps.empty()) {
			tls = new TermList(ps);
			func = tls.term.getfunctor();
			arity = tls.term.getarity();

			if (func==prevfunc && arity==prevarity) 
				clausenum++;
			else {
				clausenum = 1;
				prevfunc = func;
				prevarity = arity;
			}

			index = func + "/" + arity + "-" + clausenum;
			db[index] = tls;
			ps.skipspace();
			ps.nextclause(); // new set of vars
		}
		return db;
	} // consult



	public static function resolve(db:Hashtable):void {
		// We now resolve all references.
		/* for (var e:Enumeration = db.elements() ; e.hasMoreElements() ;) {
			(TermList (e.nextElement()).resolve(db));
		} */
		
		for each(var e:TermList in db) {
			e.resolve(db);
		}
	}
}
}