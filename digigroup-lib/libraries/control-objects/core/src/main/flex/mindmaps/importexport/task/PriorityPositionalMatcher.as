package mindmaps.importexport.task
{
	import assertions.Require;
	
	import mindmaps.importexport.IMatcher;
	import mindmaps.importexport.Match;

	public class PriorityPositionalMatcher implements IMatcher
	{
		public static const type:String = "priority";
		
		public function match(val:*):Match {
			Require.instanceOf(val, Array, "val");
			Require.collectionSize(val as Array, "val", 2);
			
			var result:Match = new Match(type, null).setInputValue(val);
			
			var left:Match = Match((val as Array)[0]);
			var right:Match = Match((val as Array)[1]);
			
			if (left.type == PriorityTextualMatcher.type && right.type != PriorityTextualMatcher.type) {
				result.value = left.value;
				result.score = 1;
			} else if (left.type != PriorityTextualMatcher.type && right.type == PriorityTextualMatcher.type) {
				result.value = right.value;
				result.score = 1;
			}
			return result;
		}
	}
}