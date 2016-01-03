package wprolog
{
	

/** Simple a list of terms. */

public final class TermList {
        internal var term:Term;
        internal var next:TermList;
		// The next two are initialised in ParseString.consult
		public var definer:Array = null;  // where is this atom defined?
		public var numclauses:int=0; 	   // How many clauses define this atom?
		
        /* public function TermList(t:Term, n:TermList) {
                term = t; next = n;
        } */

        /* public function TermList(t:Term, n:TermList, d:TermList) {
            term = t; next = n;
			definer = d.definer;
			numclauses = d.numclauses;
        } */

	public final function toString():String {
		var s:String; 
		var tl:TermList;
		s = new String("[" + term.toString());
		tl = next;
		while (tl != null) {
			s = s + ", " + tl.term.toString();
			tl = tl.next;
		}

		if (definer != null) s = s + "( " + numclauses + " clauses)";
		return s + "]";
	}

/** Looks up which clauses define atoms once and for all */
	public function resolve(db:Hashtable):void {
	    if (definer == null) {
		numclauses = 0;
		while (db.get_(
			term.getfunctor() + "/" + term.getarity() + "-"
			+ (1+numclauses)) != null) numclauses++;

		definer = new Array();//[numclauses+1]; // start numbering at 1

		for (var i:int=1; i <= numclauses ;i++) {
			definer[i] = TermList (db.get_(
					term.getfunctor() + "/" + 
					term.getarity() + "-" + (i)));
		//	IO.trace("resolve: " + term.getfunctor() + "/" +
		//			term.getarity() + "-" + i +
		//			" = " + definer[i]);
		}
		if (next != null) next.resolve(db);
	    }
	}

/** Used for parsing  clauses. */
	public function TermList(ps:ParseString=null) {
		if (ps==null) return;
		
		var ts:Array; 
		var i:int=0; 
		var tsl:Array;
		ts = new Array();
		tsl = new Array(); // arbitrary
		ts[i++] = new Term(ps); 
		ps.skipspace();

		if (ps.current() == ':') {
			ps.advance();
			if (ps.current() != '-') 
				ps.parseerror("Expecting ``-'' after ``:''");
			ps.advance(); ps.skipspace();
			ts[i++] = new Term(ps);
			ps.skipspace();
			while (ps.current() == ',') {
				ps.advance(); ps.skipspace();
				ts[i++] = new Term(ps);
				ps.skipspace();
			}

			tsl[i] = null;

			for (var j:int = i - 1 ; j > 0 ; j--)
				tsl[j] = TermListFactory.create(ts[j], tsl[j+1]);

			term = ts[0];
			next = tsl[1];
		} else {
			term = ts[0]; next = null;
		}

		if (ps.current() != '.')
			ps.parseerror("Expecting ``.''");

		ps.advance();
	}
}
}