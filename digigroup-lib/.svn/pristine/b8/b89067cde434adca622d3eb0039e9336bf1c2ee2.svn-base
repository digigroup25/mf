package mf.framework.messaging
{
	import mf.framework.*;
	
	import mx.collections.ArrayCollection;
	
	import org.flexunit.asserts.*;
	
	
	public class ConnectorTest
	{
		[Test]
		public function test():void {}
		
		//VR 6/5/11 Somehow uncommenting tests below and running results in flash player running for long time and not closing
		/*private var mb:MessageLogBroker;
		
		private var containerA:LoggingContainer;
		private var containerB:LoggingContainer;
		private var containerC:LoggingContainer;
		
		public function ConnectorTest()
		{
		}
		
		private function get messageA():Message {
			return MessageFactory.createTestMessageA(null);
		}
		
		private function get messageB():Message {
			return MessageFactory.createTestMessageB(null);
		}
		
		private function sendTestMessageFrom(sender:ISender):void {
			var a:Message = messageA;
			a.sender = sender;
			sender.send(a);
		}
		
		private function sendTestMessageBFrom(sender:ISender):void {
			sender.send(messageB);
		}
		
		private function setupLoggingContainer():LoggingContainer {
			var result:LoggingContainer = new LoggingContainer();
			result.initialize();
			return result;
		}
		
		[Before]
		public function setUp():void {
			mb =  new MessageLogBroker();
			
			containerA = setupLoggingContainer();
			containerB = setupLoggingContainer();
			containerC = setupLoggingContainer();
		}
		
		[Test]	
		public function test_noforwarding_AtoB():void {
			assertResults(false, false);
		}
		
		[Test]
		public function test_AforwardsToB_allMessages():void {
			assertResults(true, false);
		}
		
		private function setupConnector(mbA:IMessageBroker, mbB:IMessageBroker, abFilter:Object,
										baFilter:Object):Connector {
			var connector:Connector = new Connector (mbA, mbB, abFilter, baFilter);
			connector.initialize();
			return connector;
		}
		
		[Test]
		public function test_AforwardsToB_messageAonly():void {
			setupConnector(containerA.mb, containerB.mb, MessageFilterFactory.includeOnly(
				messageA.name), MessageFilterFactory.excludeAll());
			
			sendTestMessageFrom(containerA);
			
			assertMessageDelivery(true, containerB, "B", messageA);
			assertMessageDelivery(false, containerA, "A", messageA);
			
			var m:Message = messageB;
			m.sender = containerA;
			containerA.send(m);
			
			assertMessageDelivery(false, containerB, "B", messageB);
			assertMessageDelivery(false, containerA, "A", messageB);
			
		}
		
		[Test]
		public function test_BforwardsToA():void {
			assertResults(false, true);
		}
		
		[Test]
		public function test_AB_mutualForwarding():void {
			assertResults(true, true);
		}
		
		[Ignore("need to setup relationship between containers")]
		[Test]
		public function test_childToChild_propagate():void {
			setupConnector(containerA.mb, containerB.mb, false, true);
			setupConnector(containerB.mb, containerC.mb, true, true);
			
			//c sends to b, b forwards to a
			sendTestMessageFrom(containerC);
			
			assertMessageDelivery(true, containerB, "B", messageA);
			assertMessageDelivery(true, containerA, "A", messageA);
			
		}
		
		[Test]
		public function test_childToChild_nopropagate():void {
			setupConnector(containerA.mb, containerB.mb, false, false);
			setupConnector(containerB.mb, containerC.mb, true, true);
			
			sendTestMessageFrom(containerC);
			
			assertMessageDelivery(true, containerB, "B", messageA);
			assertMessageDelivery(false, containerA, "A", messageA);
			
		}
		
		[Ignore("need to setup relationship between containers")]
		[Test]
		public function test_parent_children_propagate():void {
			setupConnector(containerA.mb, containerB.mb, false, true);
			setupConnector(containerB.mb, containerC.mb, true, true);
			
			sendTestMessageFrom(containerB);
			
			assertMessageDelivery(true, containerA, "A", messageA);
			assertMessageDelivery(true, containerC, "C", messageA);
			
		}
		
		private function getMessageFilter(includeAll:Boolean):IMessageFilter {
			return includeAll ? MessageFilterFactory.includeAll() : MessageFilterFactory.excludeAll();
		}
		
		private function assertResults(AtoB:Boolean, BtoA:Boolean):void {
			
			var connector:Connector = new Connector(containerA.mb, containerB.mb, 
				getMessageFilter(AtoB), getMessageFilter(BtoA));
			connector.initialize(); 
			
			sendTestMessageFrom(containerA);
			
			assertMessageDelivery(AtoB, containerB, "B", messageA);
			
			
			sendTestMessageFrom(containerB);
			assertMessageDelivery(BtoA, containerA, "A", messageA);
		}
		
		private function assertMessageDelivery(shouldReceiveMessage:Boolean, container:LoggingContainer, 
											   containerName:String, message:Message):void {
			var containsMessage:Boolean = containsMessage(container.incomingMessages, message);
			
			var assertMessage:String = (shouldReceiveMessage) ? "1 message received by " + containerName : "0 messages received by " + containerName;
			assertEquals(assertMessage, shouldReceiveMessage, containsMessage);
		}
		
		
		private function containsMessage(messages:ArrayCollection, message:Message):Boolean {
			for each (var m:Message in messages) {
				if (m.name==message.name) return true;
			}
			return false;
		}*/
	}
}