package mf.framework.messaging
{
	import mf.framework.Message;
	
	import org.flexunit.asserts.*;
	
	public class MessageFilterTest
	{
		private function get messageA():Message {
			return MessageFactory.createTestMessageA(null);
		}
		
		private function get messageB():Message {
			return MessageFactory.createTestMessageB(null);
		}

		[Test]
		public function testIncludeAll():void
		{
			var filter:IMessageFilter = MessageFilterFactory.includeAll();
			var res:Boolean = filter.canPass(messageA);
			assertTrue("any message should pass", res);
		}
		
		[Test]
		public function test_ExcludeAll():void
		{
			var filter:IMessageFilter = MessageFilterFactory.excludeAll();
			var resA:Boolean = filter.canPass(messageA);
			var resB:Boolean = filter.canPass(messageB);
			assertFalse("no message should pass", resA);
			assertFalse("no message should pass", resB);
		}
		
		[Test]
		public function test_Include_1message():void
		{
			var messageAName:String = messageA.name;
			var messageBName:String = messageB.name;
			var filter:IMessageFilter = MessageFilterFactory.includeOnly([messageAName]);
			var resA:Boolean = filter.canPass(messageA);
			var resB:Boolean = filter.canPass(messageB);
			assertTrue("messageA should pass", resA);
			assertFalse("messageB should not pass", resB);
		}
		
		[Test]
		public function test_Exclude_1message():void
		{
			var messageAName:String = messageA.name;
			var messageBName:String = messageB.name;
			var filter:IMessageFilter = MessageFilterFactory.excludeOnly([messageAName]);
			var resA:Boolean = filter.canPass(messageA);
			var resB:Boolean = filter.canPass(messageB);
			assertFalse("messageA should not pass", resA);
			assertTrue("messageB should pass", resB);
		}

	}
}