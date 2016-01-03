package mindmaps.importexport.task {

	import collections.HashMap;
	import collections.Set;

	import commonutils.TimeSpan;

	import mindmaps.importexport.IMatcher;
	import mindmaps.importexport.Match;
	import mindmaps.importexport.MatchMapBuilder;
	import mindmaps.importexport.MaxScoreList;
	import mindmaps.importexport.StringTokenizer;

	import mx.utils.StringUtil;

	import vos.Task;

	public class TaskMatcher implements IMatcher {
		private static const tokenizer:StringTokenizer = new StringTokenizer();

		private static const matchMapBuilder:MatchMapBuilder = new MatchMapBuilder();

		public function TaskMatcher() {
		}

		/**returns a task object with properties set that match the input string along with its score
		 * e.g. result = {value:Task{}, score:2}
		 * score is calculated as follows: score=# of successfully matched matchers
		 **/

		/*public function match(value:*):Match {
			var tokens:Array = tokenizer.tokenize(value, " ");

			var matchPriority:Array = matchBy(tokens, PriorityTextualMatcher);
			var matchName:Array = matchBy(tokens, NameTextualMatcher);
			var mergedMap:Object = merge(matchPriority.concat(matchName));

			//var matchPriorityPositional:Array = matchBy(tokens, PriorityPositionalMatcher);

			var hasIntersection:Boolean = false;
			var matchPriorityTop:Array = mergedMap.matches[PriorityTextualMatcher.type].toArray();
			var matchNameTop:Array = mergedMap.matches[NameTextualMatcher.type].toArray();
			var matchPriorityTopSet:Set = new Set(true);
			matchPriorityTopSet.fromArray(matchPriorityTop);
			var matchNameTopSet:Set = new Set(true);
			matchNameTopSet.fromArray(matchNameTop);
			matchPriorityTopSet.retainAll(matchNameTopSet);
			if (matchPriorityTopSet.toArray().length>0)
				hasIntersection = true;

			var val:Task = new Task();
			setProperties(val, mergedMap.matches);
			var result:Match = new Match("task", val).setScore(mergedMap.score).setInputValue(value);

			return result;
		}*/

		/**
		 * result Match.score represents how many properties were matched
		 **/
		public function match(value:*):Match {
			var tokens:Array = tokenizer.tokenize(value, /\s+/); // /[\s\/\,]/g do not add comma or forward slash since it is used for assignedTo matching
			var matchers:Array = [ PriorityTextualMatcher, StatusTextualMatcher, NameTextualMatcher, AssignedToTextualMatcher, ExecutionPeriodTextualMatcher ];
			var repeatableMatchers:Array = [ NameTextualMatcher ];

			var matchMapByType:HashMap = matchMapBuilder.build(tokens, matchers, repeatableMatchers);
			var val:Task = new Task();
			setPropertiesOfMap(val, matchMapByType);
			var score:uint = getScore(matchMapByType);
			var result:Match = new Match("task", val).setInputValue(value).setScore(score);

			return result;
		}

		/*private function getMatchMapByType(tokens:Array, matchers:ArrayCollection):Object {
			var matchMapByType:Object = {};
			for each (var token:String in tokens) {
				var i:uint=0;
				while (i<matchers.length) {
					var matcherClass:Class = matchers.getItemAt(i) as Class;
					var matcher:IMatcher = new matcherClass();
					var match:Match = matcher.match(token);
					if (match.score>0) {
						var type:String = match.type;
						if (matchMapByType[type]==undefined)
							matchMapByType[type]=new MaxScoreList();
						matchMapByType[type].add(match, match.score);
						var removeCurrent:Boolean = matcherClass!=NameTextualMatcher;// repeating NameTextualMatcher
						removeMatchersUpTo(matchers, matcherClass, removeCurrent);
						break;
					}
					i++;
				}
			}
			return matchMapByType;
		}*/



		private function matchBy(tokens:Array, matcherClass:Class):Array {
			var matcher:IMatcher = new matcherClass();
			var result:Array = [];
			for each (var token:String in tokens) {
				var matchResult:Object = matcher.match(token);
				if (matchResult.score > 0) {
					result.push(matchResult);
				}
			}
			return result;
		}


		/** Returns a map containing {key:type, MaxScoreList([value:match{token, score}]}
		 **/
		private function getMapWithMatchesWithHighestScorePerType(allMatches:Array):Object {
			var map:Object = {};
			for each (var match:Object in allMatches) {
				if (match.score > 0) {
					var type:String = match.type;
					if (map[type] == undefined)
						map[type] = new MaxScoreList();
					map[type].add(match, match.score);
				}
			}
			return map;
		}

		private function merge(allMatches:Array):Object {
			var map:Object = getMapWithMatchesWithHighestScorePerType(allMatches);

			var score:Number = calculateTotalScore(map);

			return { matches: map, score: score };
		}

		private function calculateTotalScore(map:Object):Number {
			var totalScore:Number = 0;
			for each (var list:MaxScoreList in map) {
				totalScore += list.maxScore;
			}
			return totalScore;
		}

		private function setProperties(value:Object, matchesMap:Object):void {
			for (var type:String in matchesMap) {
				var list:MaxScoreList = MaxScoreList(matchesMap[type]);
				if (list.length > 0)
					value[type] = list.toArray()[0].value;
			}
		}

		private function getScore(matchesMap:HashMap):uint {
			/*var result:uint = 0;
			for (var type:String in matchesMap) {
				result++;
			}
			return result;*/
			return matchesMap.size;
		}

		private function setPropertiesOfMap(value:Object, matchesMap:HashMap):void {
			for (var type:String in matchesMap) {
				var list:MaxScoreList = MaxScoreList(matchesMap.getValue(type));
				if (list.length == 0)
					continue;
				if (type == NameTextualMatcher.type) {
					var name:String = getCombinedName(list.toArray());
					value[type] = name;
				} else {
					var val:* = list.toArray()[0].value;
					if (val is TimeSpan)
						val = TimeSpan(val).totalHours;
					value[type] = val;
				}
			}
		}

		private function getCombinedName(matches:Array):String {
			var result:String = "";
			for each (var match:Match in matches) {
				result += " " + match.value as String;
			}
			return StringUtil.trim(result);
		}
	}
}
