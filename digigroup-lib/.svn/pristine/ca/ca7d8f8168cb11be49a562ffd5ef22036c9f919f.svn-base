package collections
{
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.not;
	import org.hamcrest.object.hasProperty;

	public class HashMapTest
	{
		private var set:HashMap;
		private static const item1:Object = {key:"a", value:1};
		private static const item2:Object = {key:"b", value:2};
		
		[Before]
		public function setUp():void
		{
			set = new HashMap();
		}
		
		[After]
		public function tearDown():void
		{
			set = null;
		}
		
		[Test]
		public function putItem():void {
			assertThat(set, hasProperty("size", 0));
			set.put(item1.key, item1.value);
			assertFalse(set.isEmpty());
			assertThat(set, hasProperty("size", 1));
			assertTrue(set.containsKey(item1.key));
			assertTrue(set.containsValue(item1.value));
		}
		
		[Test]
		public function asserts():void {
			assertThat(true);
			assertThat(not(false));
		}
		
	}
}