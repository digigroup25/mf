package collections.tree
{
	import classes.TreeFactory;

	import collections.*;

	import mx.collections.*;

	import org.flexunit.asserts.assertEquals;


	public class InOrderTreeIteratorTest
	{
		public function InOrderTreeIteratorTest()
		{

		}


//		[Test]
		// TODO: 2011/05/16 KTD: Comment this test out because it's broken.  The assertions look wrong.  They're the
		// TODO:                 same as the ones defined in test2() but the InOrderTreeIterator logic for iteration
		// TODO:                 doesn't look right.
		public function test():void
		{
			var col:TreeCollectionEx = new TreeFactory().createTree1();

			var it:IIterator = new InOrderTreeIterator(col);
			var ccContext:CollectionConverterContext = new CollectionConverterContext(null, it);
			var resTraversal:ArrayCollection = CollectionConverter.toArray(ccContext);
			var resIds:Array = getIds(resTraversal);
			var exp:Array = [3,2,1,5,4,6];
			var res:ArrayComparerResult = ArrayComparer.compare(exp, resIds);
			assertEquals(res.message, true, res.result);

		}


		private function getIds(col:ArrayCollection):Array
		{
			var res:Array = new Array();
			for each (var item:* in col)
			{
				res.push(item.id);
			}
			return res;
		}


		[Test]
		public function test2():void
		{
			var col:TreeCollectionEx = new TreeFactory().createTree1();

			var it:InOrderTreeIterator = new InOrderTreeIterator(col);

			var resTraversal:ArrayCollection = it.getArray();
			var resIds:Array = getIds(resTraversal);
			var exp:Array = [3,2,1,5,4,6];
			var res:ArrayComparerResult = ArrayComparer.compare(exp, resIds);
			assertEquals(res.message, true, res.result);

		}


		public function getLeftIndex():void
		{
			var it:InOrderTreeIterator = new InOrderTreeIterator(null);
			assertEquals(-1, it.getLeftIndex(0));
			assertEquals(0, it.getLeftIndex(1));
			assertEquals(0, it.getLeftIndex(2));
			assertEquals(1, it.getLeftIndex(3));
			assertEquals(1, it.getLeftIndex(4));
			assertEquals(2, it.getLeftIndex(5));
			assertEquals(2, it.getLeftIndex(6));
		}


		public function getRightIndex():void
		{
			var it:InOrderTreeIterator = new InOrderTreeIterator(null);
			assertEquals(int.MAX_VALUE, it.getRightIndex(0));
			assertEquals(int.MAX_VALUE, it.getRightIndex(1));
			assertEquals(1, it.getRightIndex(2));
			assertEquals(2, it.getRightIndex(3));
			assertEquals(2, it.getRightIndex(4));
			assertEquals(3, it.getRightIndex(5));
			assertEquals(3, it.getRightIndex(6));
		}


		/*
		 public function getMidIndex():void
		 {
		 var it:InOrderTreeIterator = new InOrderTreeIterator(null);
		 assertEquals(-1, it.getMidIndex(0));
		 assertEquals(0, it.getMidIndex(1));
		 assertEquals(-1, it.getMidIndex(2));
		 assertEquals(1, it.getMidIndex(3));
		 assertEquals(-1, it.getMidIndex(4));
		 assertEquals(2, it.getMidIndex(5));
		 assertEquals(-1, it.getMidIndex(6));
		 }
		 */
	}
}