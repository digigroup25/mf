package mindmaps.importexport
{
	import mx.utils.StringUtil;

	public class StringTokenizer
	{
		public function StringTokenizer()
		{
		}
		
		public function tokenize(value:String, delimiter:*):Array {
			if (value==null) return [];
			
			var splitStrings:Array = value.split(delimiter);
			var tokens:Array = [];
			for each (var splitString:String in splitStrings) {
				var tokenValue:String = StringUtil.trim(splitString);
				if (tokenValue.length==0) continue;
				tokens.push(tokenValue);
			}
			return tokens;
		}
	}
}