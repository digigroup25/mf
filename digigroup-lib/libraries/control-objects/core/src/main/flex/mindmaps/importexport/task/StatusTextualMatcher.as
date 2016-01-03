package mindmaps.importexport.task
{
	import assertions.Require;
	
	import mindmaps.importexport.CommonMatcher;
	import mindmaps.importexport.CompositeMatch;
	import mindmaps.importexport.IMatcher;
	import mindmaps.importexport.Match;
	
	import mx.utils.StringUtil;

	public class StatusTextualMatcher implements IMatcher
	{
		private static const committedToken:String 	= "c";
		private static const doneToken:String 		= "x";
		private static const reviewedToken:String	= "r";
		
		private static const commonMatcher:CommonMatcher = new CommonMatcher();
		
		public function StatusTextualMatcher() 
		{
		}
		
		public function match(inputValue:*):Match {
			Require.instanceOf(inputValue, String, "inputValue");
			
			var inputText:String = inputValue as String;
			
			var result:CompositeMatch = new CompositeMatch([]);

			var containsInvalidToken:Boolean = false;
			
			if (inputText.length>0 && inputText.length<=3) {
				for (var i:uint=0; i<inputText.length; i++) {
					var char:String = inputText.charAt(i);
					switch (char) {
						case committedToken:
							var committedMatch:Match = new Match("committed", true).setScore(1).setInputValue(char);
							result.addMatch(committedMatch);
							result.setScore(1);
							break;
						case doneToken:
							var doneMatch:Match = new Match("done", 1).setScore(1).setInputValue(char);
							result.addMatch(doneMatch);
							result.setScore(1);
							break;
						case reviewedToken:
							var reviewedMatch:Match = new Match("reviewed", true).setScore(1).setInputValue(char);
							result.addMatch(reviewedMatch);
							result.setScore(1);
							break;
						default:
							containsInvalidToken = true;
							break;
					}
				}
			}
			
			return (containsInvalidToken) ? new CompositeMatch([]) : result;
		}
	}
}