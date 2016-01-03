package mindmaps2.actions
{
	import org.flexunit.asserts.*;

	public class UserTriggeredActionTest
	{
		[Test]
		public function test_inputCopiedToOutput():void {
			var a:UserTriggeredAction = new UserTriggeredAction();
			a.initialize();
			a.input.a = "b";
			a.userExecute();
			assertTrue("input parameters should be copied to output", a.output.a!=undefined);
			assertEquals("b", a.output.a);
		}
	}
}