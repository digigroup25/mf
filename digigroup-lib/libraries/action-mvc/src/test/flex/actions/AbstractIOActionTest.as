package actions
{
	import collections.AliasHashMap;
	
	import flexunit.framework.TestCase;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	import testClasses.*;

	public class AbstractIOActionTest
	{
		private var a:AbstractIOAction;
		
		private function createIOAction():AbstractIOAction {
			var parent:AbstractIOAction = new AbstractIOAction();
			var input:AliasHashMap = new AliasHashMap();
			input["data"] = "a";
			input["object"] = {};
			parent.input = input;
			return parent;
		}

		[Test]
		public function test_copy_dataShouldBePreservedExceptStatus():void {
			a = createIOAction();
			a.type = ActionType.PARALLEL;
			a.logicType = LogicType.OR;
			a.setFailed();
			
			var copy:AbstractIOAction = AbstractIOAction(a.copy());
			
			assertEquals(a.type, copy.type);
			assertEquals(a.logicType, copy.logicType);
			assertEquals(ActionStatus.NOT_STARTED, copy.status);
		}

		[Test]
		public function test_copy_inputShouldBeCopiedByReference():void {
			a = createIOAction();
			
			var copy:AbstractIOAction = AbstractIOAction(a.copy());
			
			assertFalse(a.input == copy.input);
			assertEquals(a.input.object, copy.input.object);
		}

		[Test]
		public function test_copy_inputAliasesAreCopied():void {
			a = createIOAction();
			a.input.addAlias("b", "a");
			
			var copy:AbstractIOAction = AbstractIOAction(a.copy());
			
			var aliases:Array = copy.input.getAliases();
			assertEquals(1, aliases.length);
			assertEquals("b", aliases[0]["alias"]);
			assertEquals("a", aliases[0]["propertyName"]);
		}

		[Test]
		public function test_addngChildInputMapIsCopied():void {
			a = createIOAction();
			a.input.addAlias("c", "a");
			var childAction:AbstractIOAction = createIOAction();
			childAction.input.addAlias("b", "a");
			
			a.addChild(childAction);
			
			var aliases:Array = childAction.input.getAliases();
			assertEquals(2, aliases.length);
		}

		[Test]
		public function test_copy_inputAliasesOfChildrenCopied():void {
			a = createIOAction();
			var childAction:AbstractIOAction = createIOAction();
			childAction.input.addAlias("b", "a");
			a.addChild(childAction);
			
			var copy:AbstractIOAction = AbstractIOAction(a.copy());
			
			var aliasValues:Array = copy.children[0].input.getAliases();
			assertEquals(1, aliasValues.length);
			var aliasValue:Object = aliasValues[0];
			assertEquals("b", aliasValue.alias);
			assertEquals("a", aliasValue.propertyName);
		}

		[Test]
		public function test_copy_childrenShouldBeCopied():void {
			a = createIOAction();
			a.addChild(createIOAction());
			a.addChild(new SuccessSyncAction());
			
			var copy:AbstractIOAction = AbstractIOAction(a.copy());
			
			assertEquals(2, copy.numChildren);
			assertTrue(copy.children[0] is AbstractIOAction);
			assertTrue(copy.children[1] is SuccessSyncAction);
		}

		[Test]
		public function test_childrenGetInputFromParent():void {
			var parent:AbstractAction = createIOAction();
			var child:AbstractIOAction = new AbstractIOAction();
			parent.addChild(child);
			
			
			parent.initialize();
			parent.execute();
			
			assertEquals("a", child.input.data);
		}
		
		private function createParent():AbstractIOAction {
			var parent:AbstractIOAction = new AbstractIOAction("parent");
			var input:AliasHashMap = new AliasHashMap();
			input["a"] = 0;
			parent.input = input;
			return parent;
		}
		private function createParent2Children():AbstractIOAction {
			var parent:AbstractIOAction = createParent();
			var child1:AbstractAction = new ChildABIOAction();
			var child2:AbstractAction = new ChildBCIOAction();
			parent.addChildren([child1, child2]);
			return parent;
		}

		[Test]
		public function test_seq_ioPassing():void {
			var parent:AbstractIOAction = createParent2Children();
			parent.type = ActionType.SEQUENTIAL;
			
			parent.initialize();
			parent.execute();
			
			assertTrue(parent.output.hasOwnProperty("b"));
			assertTrue(parent.output.hasOwnProperty("c"));
			assertTrue(parent.output.hasOwnProperty("d"));
		}

		[Test]
		public function test_par_ioPassing():void {
			var parent:AbstractIOAction = createParent2Children();
			parent.type = ActionType.PARALLEL;
			
			parent.initialize();
			parent.execute();
			
			assertTrue(parent.output.hasOwnProperty("b"));
			assertFalse(parent.output.hasOwnProperty("c"));
			assertTrue(parent.output.hasOwnProperty("d"));
		}

		[Test]
		public function test_hasInput():void {
			var a:AbstractIOAction = createParent();
			assertTrue(a.hasInput());
		}

		[Test]
		public function test_hasNoInput():void {
			var a:AbstractIOAction = new AbstractIOAction();
			assertFalse(a.hasInput());
		}

		[Test]
		public function test_hasNoOutput():void {
			var a:AbstractIOAction = new AbstractIOAction();
			assertFalse(a.hasOutput());
		}

		[Test]
		public function test_getInputForKey_existentKey():void {
			var a:AbstractIOAction = createParent();
			
			var res:Object = a.getInputForKey("a");
			assertEquals(0, res as int);
		}

		[Test]
		public function test_getInputForKey_nonExistentKey():void {
			var a:AbstractIOAction = createParent();
			
			var res:Object = a.getInputForKey("nonExistentKey");
			assertTrue(res==null);
		}

		[Test]
		public function test_inputShouldNotBeCopiedToOutput():void {
			var a:AbstractIOAction = new AbstractIOAction();
			a.input.a = "b";
			a.initialize();
			a.execute();
			assertTrue("output should not contain input parameters", a.output.a==undefined);
		}

		[Test]
		public function test_executeFunction_accessInput():void {
			var a:AbstractIOAction = createParent();
			var expectedInputOfA:String = "b";
			a.input.a = expectedInputOfA;
			var inputOfAExternal:String;
			var executed:Boolean = false;
			a.doExecuteFunction = function (action:AbstractAction):void { 
				var ioAction:AbstractIOAction = AbstractIOAction(action);
				var inputOfA:String = ioAction.input.a;
				inputOfAExternal = inputOfA;
				trace(inputOfA);
				executed = true;
			};
			a.initialize();
			
			a.execute();
			
			assertTrue("body should have executed", executed);
			assertEquals("input should be accessible from within function closure", expectedInputOfA, inputOfAExternal);
		}

		[Test]
		public function test_addChildShouldShallowCopyInputFromParentToChild():void {
			var parent:AbstractIOAction = createParent();
			var child:AbstractIOAction = new AbstractIOAction();
			
			parent.addChild(child);
			
			assertEquals("input should be copied", 0, child.input.a);
		}

		[Test]
		public function test_addChildrenShouldShallowCopyInputFromParentToChild():void {
			var parent:AbstractIOAction = createParent();
			var child:AbstractIOAction = new AbstractIOAction();
			
			parent.addChildren([child]);
			
			assertEquals("input should be copied", 0, child.input.a);
		}
	}
}