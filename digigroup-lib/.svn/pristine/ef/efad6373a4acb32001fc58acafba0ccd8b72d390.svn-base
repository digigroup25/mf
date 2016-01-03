package mf.framework
{
	import org.flexunit.asserts.*;

	public class ViewContainerDecoratorTest
	{
		[Test]
		public function testShouldReceiveMessageOnlyOnce():void {
			var mb:MessageLogBroker = new MessageLogBroker();
			var c:Container2 = new Container2(mb);
			var vc:ViewContainerDecorator = new ViewContainerDecorator(c, null);
			vc.initialize();
			
			vc.send(new Message("a", new Object(), null));
			
			assertEquals("Should receive 1 message only", 1, mb.numMessages);			
			
		}
		
		[Test]
		public function test_shouldReceiveMessageOnlyOnce_subclass():void {
			var mb:MessageLogBroker = new MessageLogBroker();
			var c:Container2 = new Container2(mb);
			var vc:MockViewContainerDecorator = new MockViewContainerDecorator(mb);
			vc.initialize();
			
			vc.send(new Message("a", new Object(), null));
			
			assertEquals("Should receive 1 message only", 1, mb.numMessages);
			assertEquals(1, vc.messagesReceived.length);	
			
		}
		
	}
}