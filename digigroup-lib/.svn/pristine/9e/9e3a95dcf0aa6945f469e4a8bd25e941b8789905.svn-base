package uiengine
{


	import org.flexunit.asserts.assertEquals;

	import testclasses.*;


	public class ActionRepositoryTest
	{
		[Test]
		public function test_getByVoType():void {
			var repo:ActionRepository = new ActionRepository();
			repo.add(new ActionDescriptor2("a", IClassB, "m_a"));
			repo.add(new ActionDescriptor2("b", ClassB, "m_b"));
			repo.add(new ActionDescriptor2("c", ClassC, "m_c"));
			
			var res:Array = repo.getByVOType(IClassB);
			
			assertEquals(2, res.length);
			assertEquals("a", res[0].label);
			assertEquals("b", res[1].label);
			
			res = repo.getByVOType(ClassB);
			assertEquals(1, res.length);
			assertEquals("b", res[0].label);
			
			res = repo.getByVOType(ClassC);
			assertEquals(1, res.length);
			assertEquals("c", res[0].label);
			
		}

	}
}