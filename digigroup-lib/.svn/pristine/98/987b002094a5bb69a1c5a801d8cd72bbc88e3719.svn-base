package mindmaps.importexport {
	import mx.utils.StringUtil;

	public class CommonMatcher {

		private static const acceptableSpecialCharacters:Array = [ "(", ")", "{", "}" ];

		public function CommonMatcher() {
		}

		public function isWord(value:String):Boolean {
			/*var res:RegExp = /\b[a-z]+\b/gi;*/
			if (value == null)
				return false;

			var res:Boolean = true;
			value = StringUtil.trim(value);
			if (value.length == 0)
				return false;

			for (var i:uint = 0; i < value.length; i++) {
				var char:String = value.charAt(i);
				if (isAcceptableSpecialCharacter(char) && (i == 0 || i == value.length - 1)) {
					if (value.length == 1) {
						return false; //
					} else
						continue; //ignore quotes in the beginning or end of the word
				}
				if (!isLetter(char))
					return false;
			}
			return true;
		}

		public function isNumber(value:String):Boolean {
			return !(isNaN(parseFloat(value)));
		}

		public function isLetter(value:String):Boolean {
			if (value == null)
				return false;
			if (value.length > 1)
				return false;
			var res:Array = value.match(/[a-z]{1}/gi);
			return (res.length == 1);
		}

		public function hasLetters(value:String):Boolean {
			var res:Array = value.match(/[a-z]/i);

			return !(res == null || res.length == 0);
		}

		public function isQuote(char:String):Boolean {
			return char == "'" || char == "\"";
		}

		private function isAcceptableSpecialCharacter(char:String):Boolean {
			return isQuote(char) || (acceptableSpecialCharacters.indexOf(char) != -1);
		}
	}
}
