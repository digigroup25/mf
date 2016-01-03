package collections.tree
{
	import classes.TreeFactory;

	import collections.IIterator;
	import collections.TreeCollectionEx;
	
	import flexunit.framework.TestCase;
	
	import mx.collections.ArrayCollection;

	import org.flexunit.asserts.assertEquals;


	public class TreeLeafIteratorTest
	{
		private static const trees:TreeFactory = new TreeFactory();
		
		private var expectedNames:Array = ["Task1", "Appointment1", "Project2"];

		[Test]
		public function test_traverseLeafs():void
  		{
  			var col:TreeCollectionEx = trees.createSimpleCollection();
  			var it:IIterator = new TreeLeafIterator(col);
  			var res:ArrayCollection = new ArrayCollection();
  			while (it.hasNext()) {
  				res.addItem(it.next());
  			}
  			assertEquals(3, res.length);
  			assertEquals(expectedNames[0], res[0].vo.name);
  			assertEquals(expectedNames[1], res[1].vo.name);
  			assertEquals(expectedNames[2], res[2].vo.name);
  		}

		[Test]
  		public function test_traverseLeafs_reverse():void
  		{
  			var col:TreeCollectionEx = trees.createSimpleCollection();
  			var it:IIterator = new TreeLeafIterator(col,true);
  			var res:ArrayCollection = new ArrayCollection();
  			while (it.hasNext()) {
  				res.addItem(it.next());
  			}
  			assertEquals(3, res.length);
  			expectedNames = expectedNames.reverse();
  			assertEquals(expectedNames[0], res[0].vo.name);
  			assertEquals(expectedNames[1], res[1].vo.name);
  			assertEquals(expectedNames[2], res[2].vo.name);
  		}
	}
}