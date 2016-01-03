package mindmaps.importexport.task {
	import assertions.Require;

	import mindmaps.importexport.CommonMatcher;
	import mindmaps.importexport.CompositeMatch;
	import mindmaps.importexport.IMatcher;
	import mindmaps.importexport.Match;
	import mindmaps.importexport.TimeSpanMatcher;

	import mx.utils.StringUtil;

	public class ExecutionPeriodTextualMatcher implements IMatcher {
		private static const separator:String = "/";

		private static const commonMatcher:CommonMatcher = new CommonMatcher();

		private static const timeSpanMatcher:TimeSpanMatcher = new TimeSpanMatcher();

		public function ExecutionPeriodTextualMatcher() {
		}

		public function match(inputValue:*):Match {
			Require.instanceOf(inputValue, String, "inputValue");

			var inputText:String = inputValue as String;

			var separatorIndex:int = inputText.indexOf(separator);

			var estimatedHoursCandidate:String;
			var actualHoursCandidate:String;

			if (separatorIndex == -1) {
				estimatedHoursCandidate = inputText;
			} else {
				var separatedValues:Array = inputText.split(separator, 2);
				estimatedHoursCandidate = separatedValues[0];
				actualHoursCandidate = separatedValues[1];
			}
			var result:CompositeMatch = new CompositeMatch([]);

			matchHoursCandidate(estimatedHoursCandidate, "estimatedHours", result);
			matchHoursCandidate(actualHoursCandidate, "actualHours", result);

			return result;
		}

		private function matchHoursCandidate(hoursCandidate:String, estimateType:String, match:CompositeMatch):void {
			if (hoursCandidate != null) {
				hoursCandidate = removeSpecialCharacters(hoursCandidate);
				/*if (commonMatcher.isNumber(hoursCandidate)) {
					var hoursValue:Number = parseFloat(hoursCandidate);
					var hoursMatch:Match = new Match(estimateType, hoursValue).setScore(1);
					match.addMatch(hoursMatch);
					match.score++;
				}*/
				var timeSpanMatch:Match = timeSpanMatcher.match(hoursCandidate).setType(estimateType);
				if (timeSpanMatch.score > 0) {
					match.addMatch(timeSpanMatch);
					match.score++;
				}
			}
		}

		private function removeSpecialCharacters(value:String):String {
			var result:String = value.replace(/[\(\)]/g, "");
			result = StringUtil.trim(result);
			return result;
		}
	}
}
