package wprolog
{
	/** This is a simple record. A choicepoint contains the continuation
	(a goal list) and the next clause to be tried. */
	internal final class ChoicePoint  {
		internal var clausenum:int;
		internal var goal:TermList;
	
		public function ChoicePoint(cn:int, g:TermList) {
			clausenum = cn; goal = g;
		}
	
		public final function toString():String {
			return ("<<" + clausenum + " : " + goal + ">>");
		}
	}
}