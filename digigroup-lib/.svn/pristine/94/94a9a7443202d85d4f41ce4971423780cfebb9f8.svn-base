package mf.framework
{
import flash.system.System;

import org.flexunit.asserts.*;
	
	import mf.framework.messaging.ControllerFake;
	
	public class Container2Test
	{
		private var m:Message;
		private var mb:MessageLogBroker;
		private var mb2:MessageLogBroker;
		private var parentContainer:Container2;
		private var childContainer:Container2;
		private var controller:ControllerFake;

		public function Container2Test()
		{
		}

		[Before]
		public function setUp():void {
			m = createTestMessage();
			
			mb = new MessageLogBroker();
			parentContainer = new Container2(mb);
			
			mb2 = new MessageLogBroker();
			childContainer = new Container2(mb2);
			
			controller = new ControllerFake();
		}
		
		private function createTestMessage():Message {
			return new Message("test", this);	
		}
		
		private function assertNoMessage(mb:IMessageBroker):void {
			assertEquals("no messages", 0, MessageLogBroker(mb).numMessages);
		}
		
		private function assertMessage(mb:IMessageBroker):void {
			assertEquals("1 message", 1, MessageLogBroker(mb).numMessages);
		}
		
		private function assertNoChildContainers(c:Container2):void {
			assertEquals(0, c.containers.length);
		}
		
		private function assertChildContainer(c:Container2):void {
			assertEquals(1, c.containers.length);
		}
		
		private function assertNoConnector(c:Container2):void {
			assertEquals("no connectors", 0, c.mb.connectors.length);
		}

		[Test]
		public function testInitializeShouldSetContainerOnControllers():void {
			var c:Container2Fake = new Container2Fake();
			c.controllers = [controller];
			assertEquals(null, controller.container);
			
			c.initialize();
			
			assertEquals(c, controller.container);
		}
		
		[Test]
		public function test_uninitializeShouldNullContainerOnControllers():void {
			var c:Container2Fake = new Container2Fake();
			c.controllers = [controller];
			c.initialize();
			
			c.uninitialize();
			assertEquals(null, controller.container);
		}
		
		[Test]
		public function test_initializeShouldExecuteOnlyOnce():void {
			var c:Container2Fake = new Container2Fake();
			c.initialize();
			c.initialize();
			assertEquals(1, c.numDoInitializeExecuted);
		}
		
		[Test]
		public function test_uninitializeShouldExecuteOnlyOnce():void {
			var c:Container2Fake = new Container2Fake();
			c.uninitialize();
			c.uninitialize();
			assertEquals(1, c.numDoUninitializeExecuted);
		}
		
		[Test]
		public function test_addContainer():void {
			parentContainer.addContainer(childContainer);
			
			assertChildContainer(parentContainer);
		}
		
		[Test]
		public function test_addContainerTwice():void {
			parentContainer.addContainer(childContainer);
			parentContainer.addContainer(childContainer);
			
			assertChildContainer(parentContainer);
		}
		
		[Test]
		public function test_addContainerDoesNotSubscribeToParentMessageBroker():void {
			parentContainer.addContainer(childContainer);
			
			parentContainer.send(m);
			assertNoMessage(mb2);
		}
		
		[Test]
		public function test_addContainerAfterInitializeShouldInitializeIt():void {
			parentContainer.initialize();
			assertFalse(childContainer.initialized);
			
			parentContainer.addContainer(childContainer);
			
			assertTrue(childContainer.initialized);
		}
		
		[Test]
		public function test_addContainerAfterInitializeShouldReceiveMessages():void {
			parentContainer.initialize();
			
			parentContainer.addContainer(childContainer);
			
			parentContainer.send(m);
			assertMessage(childContainer.mb);
		}
		
		[Test]
		public function test_addContainerBeforeInitializeShouldNotInitializeIt():void {
			assertFalse(childContainer.initialized);
			
			parentContainer.addContainer(childContainer);
			
			assertFalse(childContainer.initialized);
		}
		
		[Test]
		public function test_removeContainer():void {
			parentContainer.addContainer(childContainer);
			parentContainer.removeContainer(childContainer);
			
			assertNoChildContainers(parentContainer);
		}
		
		[Test]
		public function test_removeNonExistentContainer():void {
			parentContainer.removeContainer(childContainer);
			
			assertNoChildContainers(parentContainer);
		}
		
		[Test]
		public function test_connectParentWithChildContainer():void {
			parentContainer.addContainer(childContainer);
			parentContainer.mb.connect(childContainer.mb, true, true);
			
			parentContainer.send(m);
			
			assertMessage(childContainer.mb);
		}
		
		[Test]
		public function test_disconnectParentWithChildContainer():void {
			parentContainer.addContainer(childContainer);
			parentContainer.mb.connect(childContainer.mb, true, true);
			parentContainer.mb.disconnect(childContainer.mb);
			
			parentContainer.send(m);
			
			assertNoMessage(childContainer.mb);
		}
		
		/* public function test_uninitializeShouldDisconnectAllConnectors():void {
			parentContainer.addContainer(childContainer);
			parentContainer.mb.connect(childContainer.mb, true, true);
			parentContainer.initialize();
			assertEquals(1, parentContainer.mb.connectors.length);
			
			parentContainer.uninitialize();
			
			assertNoConnector(parentContainer);
			assertNoConnector(childContainer);
		} */
		
		[Test]
		public function test_sendMessagesChildrenToParentOnly():void {
			var child2mb:MessageLogBroker = new MessageLogBroker();
			var child2Container:Container2 = new Container2(child2mb);
			
			parentContainer.mb.connect(childContainer.mb, false, true);
			parentContainer.mb.connect(child2Container.mb, false, true);
			
			parentContainer.addContainer(childContainer);
			parentContainer.addContainer(child2Container);
			parentContainer.initialize();
			
			var m1:Message = createTestMessage();
			parentContainer.send(m1, true);
			
			assertMessage(parentContainer.mb);
			assertNoMessage(childContainer.mb);
			assertNoMessage(child2Container.mb);
			
			MessageLogBroker(parentContainer.mb).clearLog();
			
			var m2:Message = createTestMessage();
			childContainer.send(m2, true);
			assertMessage(parentContainer.mb);
			assertMessage(childContainer.mb);
			assertNoMessage(child2Container.mb);
			
			MessageLogBroker(parentContainer.mb).clearLog();
			MessageLogBroker(childContainer.mb).clearLog();
			
			var m3:Message = createTestMessage();
			child2Container.send(m3, true);
			assertMessage(parentContainer.mb);
			assertNoMessage(childContainer.mb);
			assertMessage(child2Container.mb);
		}
		
		[Ignore]
		[Test]
		public function _test_uninitializeShouldRemoveConnectors():void {
			parentContainer.addContainer(childContainer);
			parentContainer.mb.connect(childContainer.mb);
			parentContainer.initialize();
			
			childContainer.uninitialize();
			assertEquals(0, parentContainer.mb.numConnectors);
		}
	}
}