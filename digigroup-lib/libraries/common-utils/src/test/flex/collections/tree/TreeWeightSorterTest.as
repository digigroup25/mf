package collections.tree
{
	import classes.TreeFactory;

	import collections.*;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;


	public class TreeWeightSorterTest
	{
		private const trees:TreeFactory = new TreeFactory();
		private const sorter:TreeWeightSorter = new TreeWeightSorter();
		
		//     A0					A0
		//  B0   E1		=>		E1			B0
		//C2 D3
		// 						D3		C2
		[Test]
		public function test_sort_parentChildHPTaskTree():void {
			var t:TreeCollectionEx = trees.createParentChildHPTaskTree();
			var res:TreeCollectionEx = sorter.sort(t, "priority");
			assertNotNull(res);
			assertEquals("E", res.children[0].toString());
			assertEquals("B", res.children[1].toString());
			assertEquals("D", res.children[1].children[0].toString());
			assertEquals("C", res.children[1].children[1].toString());
		}
		
		//              0(0)
		//     1A(1)        1B(2)	
		//2A(2)  2B(3)      2C(1)
		[Test]
		public function test_sort_priorityTaskTree():void {
			var t:TreeCollectionEx = trees.createPriorityTaskTree();
			var res:TreeCollectionEx = sorter.sort(t, "priority");
			assertNotNull(res);
			assertEquals("1B", res.children[0].toString());
			assertEquals("1A", res.children[1].toString());
			assertEquals("2C", res.children[0].children[0].toString());
			assertEquals("2B", res.children[1].children[0].toString());
			assertEquals("2A", res.children[1].children[1].toString());
		}
		
	}
}