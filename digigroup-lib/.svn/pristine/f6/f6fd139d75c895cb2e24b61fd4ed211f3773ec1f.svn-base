package mindmaps.importexport.task
{
	import assertions.Require;
	
	import mindmaps.importexport.IMatcher;
	import mindmaps.importexport.Match;
	
	import mx.utils.StringUtil;

	public class PriorityTextualMatcher implements IMatcher
	{
		public static const type:String = "priority";
		
		public function PriorityTextualMatcher()
		{
		}
		
		public function match(val:*):Match {
			Require.instanceOf(val, String, "value");
			
			var value:String = val as String;
			var result:Match = new Match(type, null).setInputValue(value);
			value = StringUtil.trim(value);
			var number:Number = parseInt(value);
			if (!isNaN(number)) {
				result.value = number;
				result.score = 1;
				return result;
			}
			if (value!=null && value.length>=1) {
				var numericCandidateString:String = value.substr(1);
				var numericCandidateValue:Number = parseInt(numericCandidateString);
				if (!isNaN(numericCandidateValue)) {
					result.value = numericCandidateValue;
					result.score = 1;
					return result;
				}
			}
			return result;
		}
	}
}