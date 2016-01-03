package mindmaps.importexport
{
	import collections.TreeCollectionEx;
	
	import mindmaps.importexport.task.TaskMatcher;
	
	import mx.utils.StringUtil;
	
	import vos.Task;

	public class MapTextImporter implements IMapImporter
	{
		private static const tokenizer:StringTokenizer = new StringTokenizer();
		
		private static const matchers:Array = [TaskMatcher];
		private static const taskMatcher:TaskMatcher = new TaskMatcher();
		
		public function importFrom(text:String):TreeCollectionEx {
			if (text==null)
				return null;
			
			var lines:Array = breakIntoLines(text);
			
			var i:int=0;
			var baselinePrecedingSpaces:uint = 0;
			var levelToLastNodeMap:MapTextImporterLevelLookup = new MapTextImporterLevelLookup(); //maps level index to node reference
			
			var seedNode:TreeCollectionEx = new TreeCollectionEx(new Task().setName(""));
			seedMap(levelToLastNodeMap, seedNode);
			
			while (i<lines.length) {
				var line:String = lines[i];
				var precedingSpaces:uint = getPrecedingSpaces(line);
				var closestParentLevel:int = levelToLastNodeMap.getClosestParentLevel(precedingSpaces);
				var vo:* = matchVo(line);
				var node:TreeCollectionEx = new TreeCollectionEx(vo, true);
				/*if (closestParentLevel!=-1) {*/
					var parentNode:TreeCollectionEx = levelToLastNodeMap.getNode(closestParentLevel);
					parentNode.addChild(node);
				/*}*/
				levelToLastNodeMap.addNode(closestParentLevel+1, node, precedingSpaces);
				i++;
			}
			
			var root:TreeCollectionEx = levelToLastNodeMap.getNode(levelToLastNodeMap.minLevel);
			if (root.numChildren==0) {
				root = null;
			} 
			else if (root.numChildren==1) {
				var child:TreeCollectionEx = TreeCollectionEx(root.children.getItemAt(0)); 
				root.removeChild(child);
				root = child;
			} 
			return root;
		}
		
		private function seedMap(map:MapTextImporterLevelLookup, node:TreeCollectionEx):void {
			map.addNode(-1, node, -1);
		}
		public function breakIntoLines(text:String):Array {
			var textLines:Array = text.split('\r');
			var filterBlankLines:Function = function (item:*, index:int, array:Array):Boolean {
				var line:String = StringUtil.trim(item as String);
				return line.length>0;
			}

			textLines = textLines.filter(filterBlankLines);	
			
			return textLines;
		}
		
		public function getPrecedingSpaces(line:String):uint {
			var res:uint = 0;
			for (var i:uint=0; i<line.length; i++) {
				var char:String = line.charAt(i);
				if (StringUtil.isWhitespace(char)) 
					res++;
				else break;
			}
			return res;
		}
		
		private function matchVo(line:String):* {
			return taskMatcher.match(line).value;
		}
	}
}