package mindmaps.importexport.task
{
	import assertions.Require;
	
	import mindmaps.importexport.CommonMatcher;
	import mindmaps.importexport.IMatcher;
	import mindmaps.importexport.Match;
	
	import mx.utils.StringUtil;
	
	/***
	 *  Matches last word in the string
	 **/
	public class AssignedToTextualMatcher implements IMatcher
	{
		private static const commonMatcher:CommonMatcher = new CommonMatcher();
		
		public static const type:String = "assignedTo";
		
		public function match(value:*):Match {
			Require.instanceOf(value, String, "value");
			
			var inputValue:String = value as String;
			var result:Match = new Match(type, null).setInputValue(inputValue).setScore(0);
			inputValue = StringUtil.trim(inputValue);
			if (inputValue==null || inputValue.length==0)
				return result;
			
			var words:Array = inputValue.split(",");
			var assignees:Array = [];
			var found:Boolean = false;
			for each (var word:String in words) {
				word = StringUtil.trim(word);
				if (commonMatcher.isWord(word)) {
					assignees.push(word);
					found = true;
				}
			}
			if (found) {
				result.score = 1;
				result.setValue(assignees.join(","));
			}
			
			return result;
		}
	}
}