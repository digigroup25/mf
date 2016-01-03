package mindmaps.importexport
{
	import mx.utils.StringUtil;
	
	import org.flexunit.asserts.assertEquals;
	
	public class MatcherTestBase
	{		
		protected var m:IMatcher;
		
		protected function get testData():Array { return [] };
		
		public function matchTestData():void {
			for each (var testCase:Object in testData) {
				var result:Match = m.match(testCase.input);
				assertResult(testCase.input, testCase.output, result);
			}
		}
		
		/*public function assertTestData(dataSet:Array, executeFunction:Function, args:Array):void {
			for each (var dataElement:Object in dataSet) {
				
			}
		}*/
		
		protected function assertResult(input:String, expectedResult:Object, actualResult:Match):void {
			assertEquals(StringUtil.substitute("Input '{0}', score", input), 
				expectedResult.score, actualResult.score);
			assertResultRecursive(input, expectedResult, actualResult, null);
		}
		
		private function assertResultRecursive(input:String, expectedResult:Object, actualResult:Object, key:String):void {
			if (typeof(expectedResult)!="object") {
				assertEquals(StringUtil.substitute("Input '{0}', key '{1}'", input, key), expectedResult, actualResult);
			}
			else {
				/*if (expectedResult.hasOwnProperty("value")) {*/
					for (var key:String in expectedResult/*.value*/) {
						assertResultRecursive(input, expectedResult[key], actualResult[key], key);
					}
				/*}*/
			}
		}
	}
}