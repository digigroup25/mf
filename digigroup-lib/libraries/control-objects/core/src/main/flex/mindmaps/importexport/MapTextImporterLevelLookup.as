package mindmaps.importexport
{
	import collections.HashMap;
	import collections.TreeCollectionEx;
	
	import flash.utils.Dictionary;
	
	public class MapTextImporterLevelLookup
	{
		private var map:Dictionary = new Dictionary(true);
		private var _maxLevel:int = -1;
		private var _minLevel:int = -1;
		
		public function get maxLevel():int {
			return _maxLevel;
		}
		
		public function get minLevel():int {
			return _minLevel;
		}
		
		public function addNode(level:int, node:TreeCollectionEx, leadingSpaces:int):void {
			map[level] = {node:node, leadingSpaces:leadingSpaces};
			if (level>maxLevel) {
				_maxLevel = level;
			}
			if (level<minLevel) {
				_minLevel = level;
			}
		}
		
		public function getNode(level:int):TreeCollectionEx {
			return (map[level]==undefined) ? null 
				: map[level].node as TreeCollectionEx;
		}
		
		public function getClosestParentLevel(leadingSpaces:uint):int {
			var minDistance:uint = uint.MAX_VALUE;
			var minDistanceLevel:int = -1;
			for (var level:String in map) {
				var nodeLeadingSpaces:int = map[level].leadingSpaces;
				var distance:uint = Math.abs(leadingSpaces - nodeLeadingSpaces) as uint;
				if (distance <= minDistance) {
					minDistance = distance;
					minDistanceLevel = parseInt(level);
					if (leadingSpaces<=nodeLeadingSpaces)
						minDistanceLevel--; //go one level down 
				}
			}
			return minDistanceLevel;
		}
	}
}