package wprolog
{
	public class TermListFactory
	{
		/* public function TermList(t:Term, n:TermList) {
                term = t; next = n;
        } */

        /* public function TermList(t:Term, n:TermList, d:TermList) {
            term = t; next = n;
			definer = d.definer;
			numclauses = d.numclauses;
        } */
        
		public static function create(t:Term, n:TermList, d:TermList=null):TermList {
			var res:TermList = new TermList();
			res.term = t;
			res.next = n;
			if (d!=null) {
				res.definer = d.definer;
				res.numclauses = d.numclauses;
			}
			return res;
		}
	}
}