package commonutils {

	public class CharCode {
		public static function isEqual(charCode:uint, char:String, ignoreCase:Boolean = false):Boolean {
			if (!char || char.length == 0)
				return false;
			if (ignoreCase) {
				return String.fromCharCode(charCode).toUpperCase() == char.charAt(0).toUpperCase();
			} else {
				return charCode == char.charCodeAt(0);
			}
		}

		public static function getCharCode(value:String):uint {
			return value.charCodeAt(0);
		}
	}
}
