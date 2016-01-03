package wprolog
{
	import mx.utils.StringUtil;
	
	public class Character
	{
		/** Determines if a string is upper case */ 
		public static function isUpperCase(value : String) : Boolean {
			return isValidCode(value, 65, 90);
		}
		
		/** Determines if a string is lower case */
		public static function isLowerCase(value : String) : Boolean {
		return isValidCode(value, 97, 122);
		}
		
		/** Determines if a string is digit */
		public static function isDigit(value : String) : Boolean {
			return isValidCode(value, 48, 57);
		}
		
		/** Determines if a string is letter */
		public static function isLetter(value : String) : Boolean {
			return (isLowerCase(value) || isUpperCase(value));
		}
		
		/** The meat of the functions which checks the values */
		private static function isValidCode(value : String, minCode : Number, maxCode : Number) : Boolean {
			if ((value == null) || (StringUtil.trim(value).length < 1))
				return false;
		
			for (var i : int=value.length-1;i >= 0; i--) {
				var code : Number = value.charCodeAt(i);
				if ((code < minCode) || (code > maxCode))
				return false;
			}
			
			return true;
		}
		
		public static function isSpace(value:String):Boolean {
			return StringUtil.isWhitespace(value);
		}

	}
}