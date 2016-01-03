package commonutils {
	import mx.utils.StringUtil;

	public class StringUtil {
		public static function isNullOrEmpty(value:String):Boolean {
			return value == null || mx.utils.StringUtil.trim(value) == "";
		}
	}
}
