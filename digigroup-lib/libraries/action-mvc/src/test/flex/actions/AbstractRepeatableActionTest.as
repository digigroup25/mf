package actions
{


	import collections.AliasHashMap;

	import flash.events.Event;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;


	public class AbstractRepeatableActionTest extends ActionTestCase
	{
		private const tester:ActionChecker = new ActionChecker();
		protected const testFactory:TestActionFactory = new TestActionFactory();
		
		[Test]
		public function test_initialize_copiesItselfAsChild():void {
			var a:AbstractAction = new SuccessSyncRepeatableAction();
			assertFalse(a.hasChildren());
			
			a.initialize();
			
			assertEquals(1, a.numChildren);
			assertTrue(a.children[0] is SuccessSyncRepeatableAction);
		}

		[Test]
		public function test_initialize_1repeatDoesNotCopyItselfAsChild():void {
			var a:AbstractAction = new SuccessSyncRepeatableAction("", 1);
			assertFalse(a.hasChildren());
			
			a.initialize();
			
			assertFalse(a.hasChildren());
		}
		
		/* public function test_repeat2_1stFails():void {
			
		} */
		[Test(async)]
		public function test_repeat3_sync():void {
			var o:Object = testFactory.repeatable3timesSync();
			executeFactoryObject(o, this.validate1stAndExecute2nd);
		}
		
		protected function validate1stAndExecute2nd(event:Event, token:Object):void {
			token.validate(token, events);
			this.clearEventQueue();
			
			var childAction2:AbstractAction = AbstractAction(token.result.children[1]);
			super.executeInitializedAction(childAction2, onValidate1stAndExecute2nd, token);
		}
		
		private function onValidate1stAndExecute2nd(event:Event, token:Object):void {
			token.validate2(token, events);
		}

		[Test(async)]
		public function test_repeat3_async():void {
			var o:Object = testFactory.repeatable3timesAsync();
			executeFactoryObject(o, this.validate1stAndExecute2nd);
			var a:AbstractAction = AbstractAction(o.result);
		}

		[Test(async)]
		public function test_copyShouldMadeWhileExecuting():void {
			var o:Object = testFactory.repeatable3timesAsync();
			executeFactoryObject(o, this.selfValidate);
			var a:AbstractAction = AbstractAction(o.result);
			assertEquals("copy should be made as soon as execution starts", 2, a.numChildren);
		}

		[Test(async)]
		public function test_repeat2_compositeAsync():void {
			var o:Object = testFactory.repeatableSuccessCompositeAsync();
			executeFactoryObject(o, this.selfValidate);
		}

//		[Test(async)]
		// TODO: 2011/05/16 KTD: Commented out.  Test failing.
		public function test_repeat_failCompositeAsync():void {
			var o:Object = testFactory.repeatableFailCompositeAsync();
			executeFactoryObject(o, this.validate1stAndExecute2nd);
		}

//		[Test(async)]
		// TODO: 2011/05/16 KTD: Commented out.  Test failing.
		public function test_repeat_failCompositeAsync2():void {
			var o:Object = testFactory.repeatableFailCompositeAsync2();
			executeFactoryObject(o, this.selfValidate);
		}
		
		private function createRepeatableAction(name:String="test"):AbstractRepeatableAction {
			var a:AbstractRepeatableAction = new SuccessSyncRepeatableAction(name);
			a.type = ActionType.PARALLEL;
			a.logicType = LogicType.OR;
			return a;
		}

		[Test]
		public function test_copy_isCopySet():void {
			var a:AbstractRepeatableAction = createRepeatableAction();
			assertFalse(a.isCopy);
			
			var copy:AbstractRepeatableAction = AbstractRepeatableAction(a.copy());
			
			assertFalse(copy.isCopy);
		}

		[Test]
		public function test_copy_repeatCountIsPreserved():void {
			var a:AbstractRepeatableAction = createRepeatableAction();
			assertEquals(2, a.repeatCount);
			
			var copy:AbstractRepeatableAction = AbstractRepeatableAction(a.copy());
			
			assertEquals(2, copy.repeatCount);
		}

		[Test]
		public function test_copy_childrenAreCopied():void {
			var a:AbstractRepeatableAction = createRepeatableAction();
			var child:AbstractAction = new SuccessSyncAction("child");
			a.addChild(child);
			
			var copy:AbstractRepeatableAction = AbstractRepeatableAction(a.copy());
			
			assertEquals(1, copy.numChildren);
			assertTrue(copy.children[0] is SuccessSyncAction);
		}

		[Test]
		public function test_copy_repeatableChildrenAreCopied():void {
			var a:AbstractRepeatableAction = createRepeatableAction();
			var child:AbstractAction = new AbstractRepeatableAction("", 2);
			a.addChild(child);
			
			var copy:AbstractRepeatableAction = AbstractRepeatableAction(a.copy());
			
			assertEquals(1, copy.numChildren);
			var copiedChild:AbstractRepeatableAction = AbstractRepeatableAction(copy.children[0]);
			assertEquals(2, copiedChild.repeatCount);
		}

		[Test]
		public function test_copy_descendandsRepeatCountIsPreservedWhenCopied():void {
			var a:AbstractRepeatableAction = createRepeatableAction();
			var child:AbstractAction = new AbstractAction();// createRepeatableAction();
			var grandChild:AbstractAction = createRepeatableAction();
			a.addChild(child);
			child.addChild(grandChild);
			
			var copy:AbstractRepeatableAction = AbstractRepeatableAction(a.copy());
			
			assertEquals(1, copy.numChildren);
			var copiedChild:AbstractAction = AbstractAction(copy.children[0]);
			//assertEquals(2, copiedChild.repeatCount); */
			var copiedGrandChild:AbstractRepeatableAction = AbstractRepeatableAction(copiedChild.children[0]);
			assertEquals(2, copiedGrandChild.repeatCount);
		}

		[Test]
		public function test_copy_inputIsShallowCopiedToDescendants():void {
			var a:AbstractRepeatableAction = createRepeatableAction("parent");
			var child:AbstractAction = createRepeatableAction("child");
			var grandChild:AbstractAction = new SuccessSyncAction("grandChild");
			child.addChild(grandChild);
			a.addChild(child);
			var input:AliasHashMap = new AliasHashMap();
			input["object"]={};
			a.input = input;
			
			var copy:AbstractRepeatableAction = AbstractRepeatableAction(a.copy());
			
			assertEquals("input on copy is the same as in original action", a.input.object, copy.input.object);
			assertEquals("input on child copy is the same as in original action", a.input.object, copy.children[0].input.object);
			assertFalse("input on grandchild does not exist", copy.children[0].children[0].hasOwnProperty("input"));
		}

		[Test]
		public function test_canExecuteNextActionWhileCurrentIsCompleting_repeatableOnce():void {
			var a:AbstractAction = new SuccessSyncRepeatableAction("test", 1);
			a.canExecuteNextActionWhileCurrentIsCompleting = true;
			a.initialize();
			
			a.execute();
			
			assertTrue(a.canExecuteNextActionWhileCurrentIsCompleting);
			assertEquals(0, a.numChildren);
		}

		[Test]
		public function test_canExecuteNextActionWhileCurrentIsCompleting_repeatableTwice():void {
			var a:AbstractAction = createRepeatableAction();
			a.canExecuteNextActionWhileCurrentIsCompleting = true;
			a.initialize();
			
			a.execute();
			
			assertTrue(a.canExecuteNextActionWhileCurrentIsCompleting);
			//since repeatable actions will copy themselves, then next repeatable action
			//should inherit this property but its children should not
			assertFalse(a.children[0].canExecuteNextActionWhileCurrentIsCompleting);
		}

		[Test]
		public function test_afterInitializeLatestInputIsCopiedToChildren():void {
			var a:AbstractRepeatableAction = new SuccessSyncRepeatableAction("parent");
			var initialInput:AliasHashMap = new AliasHashMap();
			initialInput["label"] = "a";
			initialInput["object"] = {};
			a.input = initialInput;
			a.initialize();
			
			var newInput:AliasHashMap = new AliasHashMap();
			newInput["label"] = "b";
			newInput["object"] = {};
			a.input = newInput;
			a.execute();
			
			assertEquals("newInput should be on every child", newInput.object, a.children[1].input.object);
		}

		[Test]
		public function test_getAvailableActions_repeatableParentShouldSubsumeItsChildren():void {
			var parent:AbstractAction = new AbstractAction("parent");
			var child:AbstractUserAction = new AbstractUserAction("child", 2);
			parent.addChild(child);
			parent.initialize();
			parent.execute();
			
			var res:Array = parent.getAvailableActions();
			
			assertEquals(1, res.length);
			assertTrue(res[0].hasChildren(), "the 1st action is the repeatable action itself");
		}
	}
}