package mindmaps.importexport
{
	import collections.Set;

	public class CompositeMatch extends Match
	{
		private var matchesSet:Set = new Set(true);
		
		public override function get type():String {
			return "composite";
		}
		
		public function CompositeMatch(matches:Array)
		{
			super(type, null);
			matchesSet.fromArray(matches);
		}
		
		public function addMatch(match:Match):void {
			matchesSet.add(match);
		}
		
		public function get matches():Array {
			var matches:Array = matchesSet.toArray();
			var res:Array = [];
			for each (var match:Match in matches) {
				if (match is CompositeMatch) {
					res = res.concat(CompositeMatch(match).matches);
				}
				else {
					res.push(match);
				}
			}
			return res;
		}
	}
}