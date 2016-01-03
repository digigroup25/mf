package mindmaps2.actions.element
{
	import actions.AbstractIOAction;
	
	import org.flexunit.asserts.*;
	
	import mindmaps2.elements.ElementFactory;

	public class CreateElementActionsTest
	{
		private var a:AbstractIOAction;
		private function get commonActionsSize():int { return CreateElementActions.commonElementActions.length; };
		private function get taskActionsSize():int { return CreateElementActions.taskActions.length};
		
		[Before]
		public function setUp():void {
			a = new CreateElementActions();
		}
		
		[Test]
		public function test_failPreconditions():void {
			a.initialize();
			
			try {
				a.execute();
				fail("Should throw preconditions not met exception");
			}
			catch (e:Error) {}
		}
		
		[Test]
		public function test_passPreconditions():void {
			a.input.node = new ElementFactory().createTask("a");
			a.initialize();
			
			a.execute();
		}
		
		[Test]
		public function test_outputHasElementActions():void {
			a.input.node = new ElementFactory().createTask("a");
			a.initialize();
			
			a.execute();
			
			assertTrue("elementActions should not be null", a.output.elementActions!=null);
		}
		
		[Test]
		public function test_elementActionsContainCommonActions():void {
			a.input.node = new ElementFactory().createTask("a");
			a.initialize();
			
			a.execute();
			
			assertTrue("elementActions should contain common actions", a.output.elementActions.length>=commonActionsSize);
		}
		
		[Test]
		public function test_elementActionsContainTaskActions():void {
			a.input.node = new ElementFactory().createTask("a");
			a.initialize();
			
			a.execute();
			var allActionsSize:int = commonActionsSize+taskActionsSize;
			assertTrue("elementActions should contain task actions", a.output.elementActions.length>=allActionsSize);
		}
	}
}