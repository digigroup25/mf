package mindmaps.importexport
{
	import collections.TreeCollectionEx;
	
	import org.flexunit.asserts.assertEquals;

	public class MapTextImporterLevelLookupTest
	{
		private var map:MapTextImporterLevelLookup;
		private static const node1:TreeCollectionEx = new TreeCollectionEx();
		private static const node2:TreeCollectionEx = new TreeCollectionEx();
		private static const node3:TreeCollectionEx = new TreeCollectionEx();
		
		public function MapTextImporterLevelLookupTest()
		{
		}
		
		[Before]
		public function setUp():void
		{
			map = new MapTextImporterLevelLookup();
		}
		
		[After]
		public function tearDown():void
		{
			map = null;
		}
		
		[Test]
		public function ctor():void {
			assertEquals(-1, map.maxLevel);
			assertEquals(-1, map.minLevel);
		}
		
		[Test]
		public function addNode():void {
			map.addNode(0, node1, 0);
			assertEquals(0, map.maxLevel);
			assertEquals(-1, map.minLevel);
		}
		
		[Test]
		public function add2Nodes():void {
			map.addNode(0, node1, 0);
			map.addNode(1, node2, 0);
			assertEquals(1, map.maxLevel);
			assertEquals(-1, map.minLevel);
		}
		
		[Test]
		public function getClosestParentLevel_parentChild():void {
			map.addNode(0, node1, 1);
			map.addNode(1, node2, 4);
			
			var result:int = map.getClosestParentLevel(2);
			assertEquals(0, result);
			
			result = map.getClosestParentLevel(3);
			assertEquals(0, result);
			
			result = map.getClosestParentLevel(6);
			assertEquals(1, result);
			
			result = map.getClosestParentLevel(0);
			assertEquals(-1, result);
		}
		
		[Test]
		public function getClosestParentLevel_sibling():void {
			map.addNode(0, node1, 1);
			map.addNode(1, node2, 4);
			
			var result:int = map.getClosestParentLevel(1);
			assertEquals(-1, result);
			
			var result:int = map.getClosestParentLevel(2);
			assertEquals(0, result);
			
			result = map.getClosestParentLevel(4);
			assertEquals(0, result);
			
			result = map.getClosestParentLevel(5);
			assertEquals(1, result);
		}
		
		/**
		 * n1
		 * n2 
		 */		
		[Test]
		public function getClosestParentLevel_2siblings():void {
			map.addNode(0, node1, 1);
			map.addNode(0, node2, 1);
			
			var result:int = map.getClosestParentLevel(0);
			assertEquals(-1, result);
			
			result = map.getClosestParentLevel(1);
			assertEquals(-1, result);
			
			result = map.getClosestParentLevel(2);
			assertEquals(0, result);
		}
		
		/**
		 * n1
		 *   n2
		 * n3 
		 */		
		[Test]
		public function getClosestParentLevel_3nodes():void {
			map.addNode(0, node1, 0);
			map.addNode(1, node2, 1);
			map.addNode(0, node3, 0);
			
			var result:int = map.getClosestParentLevel(0);
			assertEquals(-1, result);
			
			result = map.getClosestParentLevel(1);
			assertEquals(0, result);
		}
		
		[Test]
		public function getClosestParentLevel_emptyMap():void {
			var result:int = map.getClosestParentLevel(0);
			assertEquals(-1, result);
		}
		
		[Test]
		public function minMaxLevel_emptyMap():void {
			var min:int = map.minLevel;
			var max:int = map.maxLevel;
			assertEquals(-1, min);
			assertEquals(-1, max);
		}
	}
}