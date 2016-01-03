package mindmaps.importexport
{
	
	import mx.utils.StringUtil;
	
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	
	public class CommonMatcherTest extends MatcherTestBase
	{
		private static const matcher:CommonMatcher = new CommonMatcher();
		
		public static function wordTest():Array {
			return [
				["1", false],
				["$", false],
				["(", false],
				[" (", false],
				["a", true], 
				[" a", true], 
				["ab", true],
				["{ab}", true],
				["(note", true],
				["\"note", true],
				["'note", true]
			];
		}
		[Test]//(dataProvider="wordTest")]
		public function testWords():void { //testValue:String, expectedValue:Boolean)
			var wordCandidates:Array = wordTest();
			for (var i:int=0; i<wordCandidates.length; i++) {
				var wordCandidate:Array = wordCandidates[i];
				var testValue:String = wordCandidate[0];
				var expectedValue:Boolean = wordCandidate[1];
				
				var actualValue:Boolean = matcher.isWord(testValue);
				
				assertEquals(StringUtil.substitute("Test value=\"{0}\"", testValue), expectedValue, actualValue);
			}
		}
	} 
}