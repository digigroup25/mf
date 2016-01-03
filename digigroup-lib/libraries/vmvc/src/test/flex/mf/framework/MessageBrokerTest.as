package mf.framework
{
	import mx.collections.ArrayCollection;
	
	import org.flexunit.asserts.*;

	public class MessageBrokerTest
	{
		private var mb:MessageBroker;
		private var testMessage:Message;
		private var loggingReceiver:LoggingReceiver;
		private var testReceiveQueue:ArrayCollection = new ArrayCollection();
		
		public function MessageBrokerTest()
		{
		}

		[Before]
		public function setUp():void {
			mb = new MessageBroker();
			loggingReceiver = new LoggingReceiver();
			testMessage = new Message("test", this);
		}

		[Test]
		public function testSubscribe():void {
			mb.subscribe(loggingReceiver);
			
			mb.send(testMessage);
			
			assertEquals(1, loggingReceiver.numMessages);
		}
		
		[Test]
		public function test_subscribeTwice():void {
			mb.subscribe(loggingReceiver);
			mb.subscribe(loggingReceiver);
			
			assertEquals(1, mb.subscribers.length);
		}
		
		[Test]
		public function test_subscribeMessageHandler():void {
			var r:IReceiver = new Receiver(this.testReceive);
			mb.subscribe(r);
			
			mb.send(testMessage);
			
			assertEquals(1, testReceiveQueue.length);
		}
		
		private function testReceive(m:Message):void {
			testReceiveQueue.addItem(m);
		}
		
		[Test]
		public function test_unsubscribe():void {
			mb.subscribe(loggingReceiver);
			mb.unsubscribe(loggingReceiver);
			
			assertEquals(0, mb.subscribers.length);
		}
		
		[Test]
		public function test_unsubscribeNonexistentSubscriber():void {
			mb.unsubscribe(loggingReceiver);
			
			assertEquals(0, mb.subscribers.length);
		}
		
		[Test]
		public function test_destroyMessageBeforeSending():void {
			var r:IReceiver = new Receiver(this.testReceive);
			mb.subscribe(r);
			
			testMessage.destroy();
			mb.send(testMessage);
			
			assertEquals(0, testReceiveQueue.length);
		}
		
		[Test]
		public function test_destroyMessageIn1stReceiver():void {
			var messageDestroyingReceiver:IReceiver = new Receiver(function (m:Message):void { m.destroy(); });
			mb.subscribe(messageDestroyingReceiver);
			
			var r:IReceiver = new Receiver(this.testReceive);
			mb.subscribe(r);
			
			mb.send(testMessage);
			
			assertEquals(0, testReceiveQueue.length);
		}
		
		[Test]
		public function test_connect2MessageBrokers():void {
			var mb2:MessageLogBroker = new MessageLogBroker();
			mb.connect(mb2, true, true);
			
			mb.send(testMessage);
			
			assertEquals(1, mb2.numMessages);
		}
		
		[Test]
		public function test_connect2MessageBrokersAddsConnector():void {
			var mb2:MessageLogBroker = new MessageLogBroker();
			mb.connect(mb2, true, true);
			
			assertEquals(1, mb.connectors.length);
			assertEquals(1, mb2.connectors.length);
			assertEquals(mb.connectors[0], mb2.connectors[0]);
		}
		
		[Test]
		public function test_disconnect2MessageBrokers():void {
			var mb2:MessageLogBroker = new MessageLogBroker();
			mb.connect(mb2, true, true);
			mb.disconnect(mb2);
			
			mb.send(testMessage);
			
			assertNoConnector(mb2);
		}
		
		[Test]
		public function test_disconnect2MessageBrokersRemovesConnector():void {
			var mb2:MessageLogBroker = new MessageLogBroker();
			mb.connect(mb2, true, true);
			mb.disconnect(mb2);
			
			assertNoConnector(mb);
			assertNoConnector(mb2);
		}
		
		[Test]
		public function test_connectItself():void {
			mb.connect(mb, true, true);
			
			assertNoConnector(mb);
		}
		
		[Test]
		public function test_connectTwice():void {
			var mb2:MessageLogBroker = new MessageLogBroker();
			mb.connect(mb2, true, true);
			mb.connect(mb2, true, true);
			
			assertConnector(mb);
		}
		
		[Test]
		public function test_connectTwiceReverseOrder():void {
			var mb2:MessageLogBroker = new MessageLogBroker();
			mb.connect(mb2, true, true);
			mb2.connect(mb, true, true);
			
			assertConnector(mb);
		}
		
		[Test]
		public function test_disconnectNonExistingConnector():void {
			var mb2:MessageLogBroker = new MessageLogBroker();
			mb.disconnect(mb2);
			
			assertNoConnector(mb);
		}
		
		[Test]
		public function test_disconnectAllConnectors():void {
			var mb2:MessageLogBroker = new MessageLogBroker();
			var mb3:MessageLogBroker = new MessageLogBroker();
			mb.connect(mb2);
			mb.connect(mb3);
			
			mb2.disconnectAll();
			
			assertNoConnector(mb2);
			assertConnector(mb);
			assertConnector(mb3);
		}
		
		[Test]
		public function test_disconnectAllConnectorsMultiple():void {
			var mb2:MessageLogBroker = new MessageLogBroker();
			var mb3:MessageLogBroker = new MessageLogBroker();
			mb.connect(mb2);
			mb.connect(mb3);
			
			mb.disconnectAll();
			
			assertNoConnector(mb2);
			assertNoConnector(mb);
			assertNoConnector(mb3);
		}
		
		private function assertNoConnector(mb:MessageBroker):void {
			assertEquals("no connector", 0, mb.numConnectors);
		}
		
		private function assertConnector(mb:MessageBroker):void {
			assertEquals("connector", 1, mb.numConnectors);
		}
	}
}