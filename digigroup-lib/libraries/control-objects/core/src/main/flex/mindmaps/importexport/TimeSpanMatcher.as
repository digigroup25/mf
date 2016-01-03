package mindmaps.importexport {
	import assertions.Require;

	import commonutils.TimeSpan;

	public class TimeSpanMatcher implements IMatcher {
		public static const type:String = "timeSpan";

		private static const hoursRegExp:RegExp = /(\d*(\.\d*)?)\s*(?=h|hr|hour)/;

		private static const minutesRegExp:RegExp = /(\d*)\s*(?:m|min|minute)/;

		private static const commonMatcher:CommonMatcher = new CommonMatcher();

		public function match(inputValue:*):Match {
			Require.instanceOf(inputValue, String, "inputValue");

			var inputText:String = inputValue as String;

			var result:Match = new Match(type, null).setInputValue(inputValue);

			var hours:Number = NaN;
			if (inputText.indexOf(":") == -1 && !commonMatcher.hasLetters(inputText))
				hours = parseFloat(inputText);
			var timeSpan:TimeSpan = null;

			if (!(isNaN(hours))) {
				timeSpan = TimeSpan.fromHours(hours);
			} else {
				timeSpan = parseTimeSpan(inputText);
			}

			result.value = timeSpan;
			result.score = timeSpan != null ? 1 : 0;

			return result;
		}

		private function parseTimeSpan(value:String):TimeSpan {
			var millis:Number = Date.parse(value);
			var result:TimeSpan = null;
			var hours:Number = -1;
			var minutes:int = -1;
			if (millis > 0) {
				var date:Date = new Date(millis);
				hours = date.hours as uint;
				minutes = date.minutes as uint;
				result = TimeSpan.fromMinutes(hours * 60 + minutes);
			} else {
				hours = parseHours(value);
				minutes = parseMinutes(value);
				if (hours == -1 && minutes == -1) {
					return result;
				} else if (hours == -1) {
					hours = 0;
				} else if (minutes == -1) {
					minutes = 0;
				}
				result = TimeSpan.fromMinutes(hours * 60 + minutes);
			}
			return result;
		}

		//allow hours to be expressed as decimal point number
		private function parseHours(value:String):Number {
			var result:Array = value.match(hoursRegExp);
			if (result == null || result.length == 0)
				return -1;
			return parseFloat(result[0]);
		}

		private function parseMinutes(value:String):int {
			var result:Array = value.match(minutesRegExp);
			if (result == null || result.length == 0)
				return -1;
			return parseInt(result[0]);
		}
	}
}
