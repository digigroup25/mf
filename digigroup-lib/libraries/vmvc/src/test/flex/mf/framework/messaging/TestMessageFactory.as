package mf.framework.messaging
{
	import mf.framework.Message;
	
	public class TestMessageFactory
	{
		public static function createTestMessageA(sender:Object):Message {
			return new Message("testA", sender, {a:"a"});
		}
		
		public static function createTestMessageB(sender:Object):Message {
			return new Message("testB", sender, {a:"a"});
		}
	}
}