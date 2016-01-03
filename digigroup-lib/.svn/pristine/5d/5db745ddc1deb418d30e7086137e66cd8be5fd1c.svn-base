package commonutils {
	import commonutils.TimeSpan;

	import mx.formatters.Formatter;
	import mx.utils.StringUtil;

	public class TimeSpanFormatter extends Formatter {
		public function TimeSpanFormatter() {
			super();
		}

		override public function format(value:Object):String {
			// Reset any previous errors.
			if (error)
				error = null;

			// If value is null, or not TimeSpan just return "" 
			// but treat it as an error for consistency.
			// Users will ignore it anyway.
			if (!value || !(value is TimeSpan)) {
				error = defaultInvalidValueError;
				return "";
			}

			var timeSpan:TimeSpan = TimeSpan(value);

			var formatString:String = "";
			if (timeSpan.hours > 0)
				formatString += "{0}h ";
			if (timeSpan.minutes > 0)
				formatString += "{1}m";
			if (timeSpan.hours == 0 && timeSpan.minutes == 0)
				formatString = "{1}m";
			var res:String =  mx.utils.StringUtil.substitute(formatString, timeSpan.hours, timeSpan.minutes);
			return mx.utils.StringUtil.trim(res);

		}
	}
}
