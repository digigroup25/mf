package actions
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class AbstractUserActionTest extends TestCase
	{
		private const factory:ActionFactory = new ActionFactory();
		
		private var eventQueue:Array;

		[Before]
		override public function setUp():void {
			super.setUp();
			eventQueue = [];
		}
		
		
		
		private function createSuccessUserAction(userInvocationOnly:Boolean=false, repeatCount:int=1):AbstractUserAction {
			var a:AbstractUserAction = new SuccessUserSyncAction("", repeatCount);
			a.userInvocationOnly = userInvocationOnly;
			return a;
		}

		[Test]
		public function test_executeActionNotRequiringDirectUserInvocation():void {
			var a:AbstractUserAction = createSuccessUserAction(false);
			a.initialize();
			
			a.execute();
			
			assertEquals("done", SuccessUserSyncAction(a).result);
		}

		[Test]
		public function test_executeActionRequiringDirectUserInvocation():void {
			var a:AbstractUserAction = createSuccessUserAction(true);
			a.initialize();
			a.addEventListener(ActionEvent.UNABLE_TO_EXECUTE, addToEventQueue);
			a.execute();
			
			assertEquals("not done", SuccessUserSyncAction(a).result);
			assertUnableToExecuteEventDispatched();
		}
		
		private function addToEventQueue(event:ActionEvent):void {
			this.eventQueue.push(event);
		}

		[Test]
		public function test_userExecuteActionRequiringDirectUserInvocation():void {
			var a:AbstractUserAction = createSuccessUserAction(true);
			a.initialize();
			
			a.userExecute();
			
			assertEquals("done", SuccessUserSyncAction(a).result);
		}
		
		private function assertUnableToExecuteEventDispatched():void {
			assertEquals("should receive ActionEvent.UNABLE_TO_EXECUTE", 1, eventQueue.length);
		}

		[Test]
		public function test_stopForUserAction():void {
			var parent:AbstractAction = new AbstractAction();
			
			var ua1:AbstractUserAction = createSuccessUserAction(true);
			var a2:AbstractAction = new SuccessSyncAction();
			parent.addChildren([ua1, a2]);
			parent.initialize();
			parent.addEventListener(ActionEvent.UNABLE_TO_EXECUTE, addToEventQueue);
			
			parent.execute();
			
			assertEquals(ActionStatus.COMPLETING, parent.status);
			assertEquals(ActionStatus.NOT_STARTED, ua1.status);
			assertEquals(ActionStatus.NOT_STARTED, a2.status);
			assertUnableToExecuteEventDispatched();
			
			ua1.userExecute();
			assertEquals(ActionStatus.COMPLETED, parent.status);
			assertEquals(ActionStatus.COMPLETED, ua1.status);
			assertEquals(ActionStatus.COMPLETED, a2.status);
		}

		[Test]
		public function test_userInvocationOnlyFlagIsCopiedToRepeatableChildren():void {
			var a:AbstractUserAction = createSuccessUserAction(true, 2);
			a.initialize();
			
			assertTrue(a.userInvocationOnly);
			assertTrue("child should get a copy of userInvocationOnly flag", a.children[0].userInvocationOnly);
		}

		[Test]
		public function test_userExecute_UserRepeatableAction():void {
			var a:AbstractUserAction = createSuccessUserAction(true, 2);
			a.initialize();
			
			a.userExecute();
			
			assertEquals(ActionStatus.COMPLETED, a.status);
			assertEquals(ActionStatus.COMPLETED, a.children[0].status);
			assertEquals(ActionStatus.NOT_STARTED, a.children[1].status);
		}

		[Test]
		public function test_stopForUserRepeatableAction():void {
			var parent:AbstractAction = new AbstractAction();
			
			var ua1:AbstractUserAction = createSuccessUserAction(true, 2);
			var a2:AbstractAction = new SuccessSyncAction();
			parent.addChildren([ua1, a2]);
			parent.initialize();
			parent.addEventListener(ActionEvent.UNABLE_TO_EXECUTE, addToEventQueue);
			
			parent.execute();
			
			assertEquals(ActionStatus.COMPLETING, parent.status);
			assertEquals(ActionStatus.NOT_STARTED, ua1.status);
			assertEquals(ActionStatus.NOT_STARTED, a2.status);
			assertUnableToExecuteEventDispatched();
			
			ua1.userExecute();
			assertEquals(ActionStatus.COMPLETED, parent.status);
			assertEquals(ActionStatus.COMPLETED, ua1.status);
			assertEquals(ActionStatus.COMPLETED, a2.status);
			
			assertEquals(2, ua1.numChildren);
			assertEquals(ActionStatus.COMPLETED, ua1.children[0].status);
			assertEquals("child0 should not have any children", 0, ua1.children[0].numChildren);
			
			assertEquals(ActionStatus.NOT_STARTED, ua1.children[1].status);
			assertEquals("child1 should not have any children", 0, ua1.children[1].numChildren);
		}
	}
}