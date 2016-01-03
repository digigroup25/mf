package mindmaps.importexport {
	import org.flexunit.runners.Parameterized;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	[RunWith("org.flexunit.runners.Parameterized")]
	public class WordTokenizerTest {

		private static const tokenizer:WordTokenizer = new WordTokenizer();

		public static function wordTokenizerTestCases():Array {
			return [[ "", []],
				[ ",.*&^", []],
				[ "a", [ "a" ]],
				[ "a,", [ "a" ]],
				[ ",a", [ "a" ]],
				[ " , a , b", [ "a", "b" ]],
				[ "a,b", [ "a", "b" ]],
				[ "a.b|c", [ "a", "b", "c" ]],
				[ "var actualResult:Match = m.match(inputString);",
				[ "var", "actualResult", "Match", "m", "match", "inputString" ]],
				[ "V, M", [ "V", "M" ]], ];
		}

		public function WordTokenizerTest() {
		}

		private var foo:Parameterized;

		[Test(dataProvider = "wordTokenizerTestCases")]
		public function matchTimeSpans(inputString:String, expectedWords:Array):void {
			var actualWords:Array = tokenizer.getWords(inputString);
			assertThat(actualWords, equalTo(expectedWords));
		}
	}
}
