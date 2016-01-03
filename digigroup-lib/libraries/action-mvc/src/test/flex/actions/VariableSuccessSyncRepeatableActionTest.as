package actions
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	import org.flexunit.asserts.assertEquals;


	public class VariableSuccessSyncRepeatableActionTest
	{
		[Test]
		public function test_fail2nd():void {
			VariableSuccessSyncRepeatableAction.resetCounter();
			VariableSuccessSyncRepeatableAction.failExecutionsWhenCounterIs = [1];
			
			var a1:AbstractAction = new VariableSuccessSyncRepeatableAction();
			a1.initialize();
			
			a1.execute();
			assertEquals(ActionStatus.COMPLETED, a1.status);
			
			var a2:AbstractAction = AbstractAction(a1.children[1]);
			a2.execute();
			assertEquals(ActionStatus.COMPLETED, a1.status);
			assertEquals(ActionStatus.FAILED, a2.status);
		}

		[Test]
		public function test_fail2andSucceed3rd():void {
			VariableSuccessSyncRepeatableAction.resetCounter();
			VariableSuccessSyncRepeatableAction.failExecutionsWhenCounterIs = [0,1];
			
			var a:AbstractAction = new VariableSuccessSyncRepeatableAction();
			a.initialize();
			
			a.execute();
			assertEquals(ActionStatus.COMPLETED, a.status);
			assertEquals(ActionStatus.FAILED, a.children[0].status);
			assertEquals(ActionStatus.FAILED, a.children[1].status);
			assertEquals(ActionStatus.COMPLETED, a.children[2].status);
		}
	}
}