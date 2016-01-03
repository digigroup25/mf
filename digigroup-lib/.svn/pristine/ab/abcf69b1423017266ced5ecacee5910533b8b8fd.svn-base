package mf.framework.messaging
{
	public class MessageFilterFactory
	{
		public static function includeOnly(... messages):IMessageFilter {
			return new IncludeMessageFilter(messages);
		}
		
		public static function includeAll():IMessageFilter {
			return new ExcludeMessageFilter(null);
		}
		
		public static function excludeOnly(... messages):IMessageFilter {
			return new ExcludeMessageFilter(messages);
		}
		
		public static function excludeAll():IMessageFilter {
			return new IncludeMessageFilter(null);
		}
	}
}