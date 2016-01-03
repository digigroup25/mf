package mindmaps.map
{
	import collections.TreeCollectionEx;
	
	import factories.TreeFactory;
	
	import mindmaps2.elements.ElementFactory;
	
	import vos.*;
	
	public class MapModel2Factory
	{
		private const elements:ElementFactory = new ElementFactory();
		private const trees:TreeFactory = new TreeFactory();
		
		public function createEmptyMap(name:String):MapModel2 {
			var emptyNode:TreeCollectionEx = elements.createItem("new item");
			var res:MapModel2 = new MapModel2(emptyNode, name);
			return res;
		}
		
		public function createEmptyMaps(numberOfMaps:int):Array {
			var res:Array = new Array();
			for (var i:int=0; i<numberOfMaps; i++) {
				var map:MapModel2 = createEmptyMap("Map "+(i+1));
				res.push(map);
			}
			return res;
		}
		
		public function createMapFrom(nodes:TreeCollectionEx, name:String=""):MapModel2 {
			var map:MapModel2 = new MapModel2(nodes, name);
			return map;
		}
		
		public function createRandomMaps(numberOfMaps:uint, numberOfNodesPerMap:uint):Array {
			var res:Array = new Array();
			for (var i:int=0; i<numberOfMaps; i++) {
				var map:MapModel2 = createMapFrom(trees.createRandomVoTree(numberOfNodesPerMap, [Task, Note]), 
					"Map "+(i+1));
				res.push(map);
			}
			return res;
		}
		
		public function createPriorityMap():MapModel2 {
			var priorityTree:TreeCollectionEx = trees.createPriorityTaskTree2();
			var res:MapModel2 = createMapFrom(priorityTree, "Priority map");
			return res;
		}
		
		public function createAllElementsMap():MapModel2 {
			var t:TreeCollectionEx = trees.createAllElements();
			var res:MapModel2 = createMapFrom(t, "All Elements");
			return res;
		}
	}
}