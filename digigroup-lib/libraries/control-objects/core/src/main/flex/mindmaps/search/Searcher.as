package mindmaps.search
{
	import collections.IIterator;
	import collections.TreeCollectionEx;
	
	import commonutils.Attribute;
	import commonutils.ClassInspector;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	public class Searcher
	{
		public function Searcher()
		{
		}
		private var ci:ClassInspector = new ClassInspector();
		
		public function search (searchValue:String, map:TreeCollectionEx) : SearchResult {
			
			if (searchValue==null) return res;
			if (map==null) throw new ArgumentError("map cannot be null");
			
			//replace 1 or more spaces with only 1 space
			var removeMultipleWhiteSpaces:RegExp = /\s+/g;
			var normalizedSearchValue:String = searchValue.replace(removeMultipleWhiteSpaces, " ");
			
			var searchTerms:Array = normalizedSearchValue.split(" ");
			var it:IIterator = map.createIterator();
			var matches:ArrayCollection = new ArrayCollection();
			while (it.hasNext())
			{
				var curNode:TreeCollectionEx = TreeCollectionEx(it.next());
				if (curNode.vo==null) continue;
				for each (var searchTerm:String in searchTerms) {
					var searchMatch:SearchMatch = getSearchMatch(curNode, searchTerm);
					if (searchMatch && (!searchMatchesContainElement(matches, searchMatch.element))) { //add only if result does not contain the match already
						matches.addItem(searchMatch);
						continue;
					}
				}
			}
			var res:SearchResult = new SearchResult(normalizedSearchValue, matches);
			return res;
		}
		
		private function searchMatchesContainElement(matches:ArrayCollection, element:*):Boolean {
			for each (var match:SearchMatch in matches) {
				if (match.element==element) return true;
			}
			return false;
		}
		
		private function getSearchMatch(node:TreeCollectionEx, searchTerm:String):SearchMatch {
			var vo:* = node.vo;
			var dataAttributes:Array = ci.getDataAttributes(vo);
			for each (var dataAttribute:Attribute in dataAttributes) {
				var val:Object = vo[dataAttribute.name];
				if (val==null) continue;
				var valString:String = val.toString();
				if (isMatch(searchTerm, valString))
					return new SearchMatch(node, valString, [searchTerm]);
			}
			return null;
		}
		
		public function isMatch(searchTerm:String, candidateString:String):Boolean {
			//return (candidateString.toLowerCase().lastIndexOf(searchTerm.toLowerCase())>=0);
			var exp:String = StringUtil.substitute("\\b{0}\\b", searchTerm);
			//var e:RegExp = /\babc\b/;//new RegExp(exp, "i");
			var e:RegExp = new RegExp(exp, "i");
			//var res:Array = candidateString.match(exp);
			var res:Boolean = e.test(candidateString);
			return res;
			//return (res!=null);
			//return (e.exec(candidateString)!=null);
		}
	}
}