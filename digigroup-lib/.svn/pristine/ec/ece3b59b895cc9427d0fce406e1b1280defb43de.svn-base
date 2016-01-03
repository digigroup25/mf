package actions
{


	import org.flexunit.asserts.assertEquals;


	public class VariableSuccessSyncActionTest
	{
		[Test]
		public function test_fail2nd():void {
			VariableSuccessSyncAction.resetCounter();
			VariableSuccessSyncAction.failExecutionsWhenCounterIs = [1];
			
			var a1:VariableSuccessSyncAction = new VariableSuccessSyncAction();
			var a2:VariableSuccessSyncAction = new VariableSuccessSyncAction();
			a1.initialize();
			a2.initialize();
			
			a1.execute();
			assertEquals(ActionStatus.COMPLETED, a1.status);
			
			a2.execute();
			assertEquals(ActionStatus.FAILED, a2.status);
		}

		[Test]
		public function test_fail1st():void {
			VariableSuccessSyncAction.resetCounter();
			VariableSuccessSyncAction.failExecutionsWhenCounterIs = [0];
			
			var a:AbstractAction = new AbstractAction("a");
			a.type = ActionType.SEQUENTIAL;
			a.logicType = LogicType.OR;
			
			var a1:VariableSuccessSyncAction = new VariableSuccessSyncAction("a1");
			var a2:VariableSuccessSyncAction = new VariableSuccessSyncAction("a2");
			a.addChildren([a1, a2]);
			a.initialize();
			
			a.execute();
			
			assertEquals(ActionStatus.COMPLETED, a.status);
			assertEquals(ActionStatus.FAILED, a1.status);
			assertEquals(ActionStatus.COMPLETED, a2.status);
		}
	}
}
