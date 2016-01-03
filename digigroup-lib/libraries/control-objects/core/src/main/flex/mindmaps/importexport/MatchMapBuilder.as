package mindmaps.importexport
{
	import collections.HashMap;
	
	public class MatchMapBuilder
	{
		public function MatchMapBuilder()
		{
		}
		
		public function build(tokens:Array, matchers:Array, repeatableMatchers:Array):HashMap {
			var matchMapByType:HashMap = new HashMap(true);
			for each (var token:String in tokens) {
				var i:uint=0;
				while (i<matchers.length) {
					var matcherClass:Class = matchers[i] as Class;
					var matcher:IMatcher = new matcherClass();
					var match:Match = matcher.match(token);
					if (match.score>0) {
						addMatchToMatchMap(matchMapByType, match);
						var removeCurrent:Boolean = repeatableMatchers==null || repeatableMatchers.indexOf(matcherClass)==-1;//do not remove repeating matchers
						removeMatchersUpTo(matchers, matcherClass, removeCurrent);
						break;
					}
					i++;
				}
			}
			return matchMapByType;
		}
		
		private function removeMatchersUpTo(matchers:Array, matcherClass:Class, removeCurrent:Boolean):void {
			var index:int = matchers.indexOf(matcherClass);
			if (index==-1) return;
			if (removeCurrent) index++;
			matchers.splice(0, index);
		}
		
		private function addMatchToMatchMap(matchMapByType:HashMap, match:Match):void {
			var matches:Array = (match is CompositeMatch) ? CompositeMatch(match).matches : [match];
			
			for each (var simpleMatch:Match in matches) {
				var type:String = simpleMatch.type;					
				if (matchMapByType.getValue(type)==undefined)
					matchMapByType.put(type, new MaxScoreList());
				MaxScoreList(matchMapByType.getValue(type)).add(simpleMatch, simpleMatch.score);
			}
		}
	}
}