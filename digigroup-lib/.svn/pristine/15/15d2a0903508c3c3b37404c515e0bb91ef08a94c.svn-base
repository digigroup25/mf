package actions
{


	import actions.TestActionFactory;

	import flash.events.Event;

	import mx.binding.utils.*;
	import mx.collections.ArrayCollection;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;


	public class AbstractActionTest extends ActionTestCase
	{
		private const factory:ActionFactory = new ActionFactory();
		protected const testFactory:TestActionFactory = new TestActionFactory();


		public var status:String = "";


		private function clearEvents():void
		{
			this.events = new Array();
		}


		[After]
		public function tearDown():void
		{
			a = null;
		}


		[Test]
		public function test_ctor():void
		{
			a = new AbstractAction("a");
			assertEquals("a", a.name);
			assertEquals(ActionStatus.NOT_STARTED, a.status);
		}


		[Test]
		public function test_bindingToStatus():void
		{
			a = new AbstractAction();
			assertEquals(a.status, ActionStatus.NOT_STARTED);

			var w:ChangeWatcher = BindingUtils.bindProperty(this, "status", a, "status");
			a.setCompleting();
			assertEquals(ActionStatus.COMPLETING, status);
			w.unwatch();
		}


		[Test]
		public function test_allowedStatusTransitions_success():void
		{
			a = new AbstractAction();
			assertEquals(ActionStatus.NOT_STARTED, a.status);

			a.status = ActionStatus.COMPLETING;
			assertEquals(ActionStatus.COMPLETING, a.status);

			a.status = ActionStatus.COMPLETED;
			assertEquals(ActionStatus.COMPLETED, a.status);
		}


		[Test]
		public function test_allowedStatusTransitions_failure():void
		{
			a = new AbstractAction();

			a.status = ActionStatus.COMPLETING;
			assertEquals(ActionStatus.COMPLETING, a.status);

			a.status = ActionStatus.FAILING;
			assertEquals(ActionStatus.FAILING, a.status);

			a.status = ActionStatus.FAILED;
			assertEquals(ActionStatus.FAILED, a.status);
		}


		[Test]
		public function test_illegalStatusTransitions_NS_FI():void
		{
			a = new AbstractAction();
			a.initialize(); //has to initialize to enforce correct status state transition
			assertEquals(ActionStatus.NOT_STARTED, a.status);

			try
			{
				a.status = ActionStatus.FAILING;
				fail("Illegal status assignment");
			}
			catch (e:ActionError)
			{
			}
		}


		[Test]
		public function test_illegalStatusTransitions_CI_NS():void
		{
			a = new AbstractAction();
			a.initialize();
			assertEquals(ActionStatus.NOT_STARTED, a.status);
			a.status = ActionStatus.COMPLETING;

			try
			{
				a.status = ActionStatus.NOT_STARTED;
				fail("Illegal status assignment");
			}
			catch (e:ActionError)
			{
			}
		}


		[Test]
		public function test_preconditionsPass():void
		{
			a = new AbstractAction();
			a.preconditions = [function():void
							   {
								   ;
							   }];
			a.initialize();

			a.execute();
		}


		[Test]
		public function test_preconditionsFail():void
		{
			a = new AbstractAction();
			a.preconditions = [function():void
							   {
								   throw new Error("fail");
							   }];
			a.initialize();

			try
			{
				a.execute();
				fail("preconditions should fail");
			}
			catch (e:Error)
			{
				assertEquals(ActionStatus.NOT_STARTED, a.status);
			}
		}


		[Test]
		public function test_copy_parentReferenceIsNotCopied():void
		{
			a = new AbstractAction("a");
			var b:AbstractAction = new AbstractAction("b");
			a.addChild(b);
			assertEquals(a, b.parent);

			var copyB:AbstractAction = AbstractAction(b.copy());

			assertEquals(null, copyB.parent);
		}


		[Test]
		public function test_copy_inChildrenParentReferenceIsCopied():void
		{
			a = new AbstractAction("a");
			var b:AbstractAction = new AbstractAction("b");
			a.addChild(b);
			assertEquals(a, b.parent);

			var copyA:AbstractAction = AbstractAction(a.copy());

			assertEquals(copyA, copyA.children[0].parent);
		}


		[Test]
		public function test_copy_noChildren():void
		{
			a = new SuccessSyncAction("test");

			var copy:AbstractAction = AbstractAction(a.copy());

			assertEquals(a.name, copy.name);
			assertEquals(a.type, copy.type);
			assertEquals(a.logicType, copy.logicType);
		}


		[Test]
		public function test_copy_children():void
		{
			var o:Object = testFactory.seqAND_2children();
			a = AbstractAction(o.result);

			var copy:AbstractAction = AbstractAction(a.copy());

			assertEquals(a.name, copy.name);
			assertEquals(a.type, copy.type);
			assertEquals(a.logicType, copy.logicType);
			assertEquals(a.numChildren, copy.numChildren);
		}


		[Test]
		public function test_copy_doExecuteFunctionShouldBeCopied():void
		{
			a = new AbstractAction();
			var executeFunction:Function = function(action:AbstractAction):void
			{
			};
			a.doExecuteFunction = executeFunction;

			var copyA:AbstractAction = AbstractAction(a.copy());
			assertEquals("Should copy doExecuteFunction", executeFunction, copyA.doExecuteFunction);
		}


		[Test]
		public function test_executeActionNotInitialized():void
		{
			a = new AbstractAction();
			try
			{
				a.execute();
				fail("AbstractAction should have thrown an error");
			}
			catch (e:Error)
			{
				assertTrue(e is ActionError);
			}
		}


		[Test(async)]
		public function test_complete_syncSingleAction():void
		{
			var o:Object = testFactory.syncSuccessAction();
			executeFactoryObject(o, selfValidate);
		}


		[Test(async)]
		public function test_complete_asyncSingleAction():void
		{
			var o:Object = testFactory.asyncSuccessAction();
			executeFactoryObject(o, selfValidate);
		}


		[Test(async)]
		public function test_fail_syncSingleAction():void
		{
			var o:Object = testFactory.syncFailAction();
			executeFactoryObject(o, selfValidate);
			assertEquals("failed", o.result.result);
		}


		[Test(async)]
		public function test_fail_asyncSingleAction():void
		{
			var o:Object = testFactory.asyncFailAction();
			executeFactoryObject(o, selfValidate);
		}


		[Test(async)]
		public function test_complete_2Children_sequentialAND():void
		{
			var o:Object = testFactory.seqAND_2children();
			o.result.showTrace = true;
			executeFactoryObject(o, selfValidate);
		}


		[Test(async)]
		public function test_complete_2Children_executeChildDirectly():void
		{
			var o:Object = testFactory.seqAND_2children();
			//initialize
			o.result.initialize();
			var firstChildAction:AbstractAction = AbstractAction(o.accessors.a10);
			executeAction(firstChildAction, check_complete_2Children_executeChildDirectly, o);
		}


		private function newSyncAction():AbstractAction
		{
			var a:AbstractAction = new AbstractAction();
			a.addChild(new SuccessSyncAction());
			return a;
		}


		[Test(async)]
		public function test_uninitialize_eventsShouldNotPropagate():void
		{
			var a:AbstractAction = newSyncAction();
			a.addEventListener(ActionEvent.STATUS_CHANGE, addEventToEventQueue);
			a.initialize();

			a.execute();
			assertTrue(0 < events.length);
			clearEvents();

			a.uninitialize();
			a.children[0].dispatchEvent(new ActionEvent(ActionEvent.STATUS_CHANGE, a.children[0], ActionStatus.FAILED));
			assertEquals(0, events.length);
		}


		[Test(async)]
		public function test_fail_2Children_sequentialAND():void
		{
			var o:Object = testFactory.seqAND_2children_2ndFail();
			executeFactoryObject(o, selfValidate);
		}


		[Test(async)]
		public function test_complete_2Children_sequentialOR():void
		{
			var o:Object = testFactory.seqOR_2children();
			executeFactoryObject(o, selfValidate);
		}


		[Test(async)]
		public function test_complete_2Children_sequentialOR_keepExecutingOrActions():void
		{
			var o:Object = testFactory.seqOR_2children_keepExecutingOrActions();
			executeFactoryObject(o, selfValidate);
		}


		[Test(async)]
		public function test_complete_2Children_sequentialOR_1stFail():void
		{
			var o:Object = testFactory.seqOR_2children_1stFail();
			executeFactoryObject(o, selfValidate);
		}


		[Test(async)]
		public function test_complete_2Children_parallelOR():void
		{
			var o:Object = testFactory.parOR_2children();
			executeFactoryObject(o, selfValidate);
		}


		[Test(async)]
		public function test_fail_3levels_sequentialAND():void
		{
			var o:Object = testFactory.seqAND_3levels();
			executeFactoryObject(o, selfValidate);
		}


		[Test(async)]
		public function test_fail_3levels_parallelAND():void
		{
			var o:Object = testFactory.parAND_3levels();
			executeFactoryObject(o, selfValidate);
		}


		[Test(async)]
		public function test_complete_3levels_sequentialOR():void
		{
			var o:Object = testFactory.seqOR_3levels();
			executeFactoryObject(o, selfValidate);
		}


		[Test(async)]
		public function test_complete_3levels_parallelOR():void
		{
			var o:Object = testFactory.parOR_3levels();
			executeFactoryObject(o, selfValidate);
		}


		//a0(C), a10(F), a11(NS)
		[Test]
		public function test_getDescendantsWithStatus_2children():void
		{
			var o:Object = testFactory.seqAND_2children();
			AbstractAction(o.accessors.a0).status = ActionStatus.COMPLETED;
			AbstractAction(o.accessors.a10).status = ActionStatus.FAILED;

			var res:Array = AbstractAction(o.accessors.a0).getDescendantActionsWithStatus(ActionStatus.NOT_STARTED);

			assertEquals(1, res.length);
			assertEquals(o.accessors.a11, res[0]);

		}


		[Test]
		public function test_getDescendantsWithStatus_3levels():void
		{
			var o:Object = testFactory.seqAND_3levels();

			var res:Array = AbstractAction(o.accessors.a0).getDescendantActionsWithStatus(ActionStatus.NOT_STARTED);

			assertEquals(2, res.length);
			assertEquals(o.accessors.a10, res[0]);
			assertEquals(o.accessors.a11, res[1]);
		}


		private function check_complete_2Children_executeChildDirectly(event:Event, token:Object):void
		{
			var factoryObject:Object = token;
			assertEquals(ActionStatus.NOT_STARTED, token.accessors.a0.status);
			assertEquals(ActionStatus.COMPLETED, token.accessors.a10.status);
			assertEquals(ActionStatus.NOT_STARTED, token.accessors.a11.status);
		}


		[Test]
		public function test_getAccessibleChildren_SEQallowNext():void
		{
			var a:AbstractAction = createSeqWith2Children();
			a.canExecuteNextActionWhileCurrentIsCompleting = true;
			a.initialize();

			a.execute();

			var res:ArrayCollection = a.getAccessibleChildren();
			assertEquals(2, res.length);
			assertEquals(a.children[0], res[0]);
			assertEquals(a.children[1], res[1]);
		}


		private function createSeqWith2Children():AbstractAction
		{
			var a:AbstractAction = new AbstractAction("A");
			a.type = ActionType.SEQUENTIAL;
			var a1:AbstractAction = new SuccessAsyncAction("A1", 2000);
			var a2:AbstractAction = new SuccessSyncAction("A2");
			a.addChild(a1);
			a.addChild(a2);
			return a;
		}


		[Test]
		public function test_getAccessibleChildren_SEQdoNotAllowNext():void
		{
			var a:AbstractAction = createSeqWith2Children();
			a.canExecuteNextActionWhileCurrentIsCompleting = false;
			a.initialize();

			a.execute();

			var res:ArrayCollection = a.getAccessibleChildren();
			assertEquals(1, res.length);
			assertEquals(a.children[0], res[0]);
		}


		[Test]
		public function test_getAvailableActions():void
		{
			var factoryObject:Object = testFactory.seqAND_3levels();
			factoryObject.accessors.a10.status = ActionStatus.COMPLETING;
			factoryObject.result.status = ActionStatus.COMPLETED;

			var root:AbstractUserAction = new AbstractUserAction();
			root.addChild(factoryObject.result);

			var res:Array = root.getAvailableActions();

			assertEquals(3, res.length);
			assertEquals(factoryObject.accessors.a11, res[0]);
		}


		[Test]
		public function test_doExecute_functionNoInputOrOutput():void
		{
			var a:AbstractAction = new AbstractAction();
			var executed:Boolean = false;
			a.doExecuteFunction = function ():void
			{
				executed = true;
			};
			assertFalse(executed);

			a.initialize();
			a.execute();

			assertTrue("body should execute", executed);
		}
	}
}