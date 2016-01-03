package wprolog
{
	public class TermFactory
	{
		/** create a term with  a given functor and arity.
		@param s - the functor
		@param a - the arity
		*/
		public static function create(functor:String="", arity:int=-1, varnum:int=-1):Term {
			var res:Term = new Term(null);
				if (functor=="") { 
					res.bound = false; 
					res.deref = false; 
					res.varid=varnum++;
				}
				else { 
					res.functor = functor; 
					res.arity = arity; 
					res.bound = true; 
					res.deref = false;
					res.args = new Array();
				}
				if (varnum!=-1) res.varid = varnum;
			return res;
		}

	}
}