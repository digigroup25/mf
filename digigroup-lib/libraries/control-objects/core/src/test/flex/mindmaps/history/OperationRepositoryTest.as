package mindmaps.history
{
	import flexunit.framework.TestCase;
	
	import mindmaps.map.messages.NodeMessages;
	
	import org.flexunit.asserts.*;
	
	public class OperationRepositoryTest
	{
		[Test]
		public function test_getComplement():void {
			var r:OperationRepository = new OperationRepository();
			r.register(Operations.getOperation(NodeMessages.ADD_NODE), 
				Operations.getOperation(NodeMessages.REMOVE_NODE));
			
			var complement:Operation = r.getComplement(Operations.getOperation(NodeMessages.ADD_NODE));
			assertEquals(NodeMessages.REMOVE_NODE, complement.name);
			
			var complementOfComplement:Operation = r.getComplement(Operations.getOperation(NodeMessages.REMOVE_NODE));
			assertEquals(NodeMessages.ADD_NODE, complementOfComplement.name);
			
			var complementOfNonExistentOperation:Operation = r.getComplement(Operations.getOperation("a"));
			assertNull(complementOfNonExistentOperation);
		}
	}
}