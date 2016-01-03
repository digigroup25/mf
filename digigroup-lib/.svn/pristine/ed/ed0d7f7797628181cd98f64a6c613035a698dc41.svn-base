package collections
{
	import flexunit.framework.TestCase;
	import mx.collections.ArrayCollection;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;


	public class ArrayCollectionIteratorTest
	{
		[Test]
		public function testIterate_collection():void
		{
			var a:ArrayCollection = new ArrayCollection();
			a.addItem("a"); a.addItem("b");
			var it:IIterator = new ArrayCollectionIterator(a);
			
			var item1:Object = it.next();
			var item2:Object = it.next();
			assertEquals("a", item1);
			assertEquals("b", item2);
			assertFalse(it.hasNext());
		}

		[Test]
		public function testIterate_emptyCollection():void
		{
			var a:ArrayCollection = new ArrayCollection();
			var it:IIterator = new ArrayCollectionIterator(a);
			
			assertFalse(it.hasNext());
		}
	}
}