package mindmaps.importexport
{
	import org.hamcrest.*;
	import org.hamcrest.collection.*;
	import org.hamcrest.core.*;
	import org.hamcrest.object.*;

	public class StringTokenizerTest
	{
		private var tokenizer:StringTokenizer;
		
		public function StringTokenizerTest()
		{
		}
		
		[Before]
		public function setUp():void
		{
			tokenizer = new StringTokenizer();
		}
		
		[After]
		public function tearDown():void
		{
			tokenizer = null;
		}
		
		[Test]
		public function tokenizeNullString():void {
			var result:Array = tokenizer.tokenize(null, " ");
			assertThat(result, emptyArray());
		}
		
		[Test]
		public function tokenizeEmptyString():void {
			var result:Array = tokenizer.tokenize("", " ");
			assertThat(result, emptyArray());
		}
		
		[Test]
		public function tokenizeStringWithSpacesOnly():void {
			var result:Array = tokenizer.tokenize("   ", " ");
			assertThat(result, emptyArray());
		}
		
		[Test]
		public function tokenizeStringOneChar():void {
			var result:Array = tokenizer.tokenize("a", " ");
			assertThat(result, arrayWithSize(1));
			assertThat(result, array("a"));
		}
		
		[Test]
		public function tokenizeStringTwoWords():void {
			var result:Array = tokenizer.tokenize("one two", " ");
			assertThat(result, arrayWithSize(2));
			assertThat(result, array("one", "two"));
		}
		
		[Test]
		public function tokenizeStringMixedWordsAndSymbols():void {
			var result:Array = tokenizer.tokenize("one two   three 4 , ", " ");
			assertThat(result, arrayWithSize(5));
			assertThat(result, array("one", "two", "three", "4", ","));
		}
		
		[Test]
		public function tokenizeStringWithForwardSlash():void {
			var result:Array = tokenizer.tokenize("one/two", /\//g);
			assertThat(result, array("one", "two"));
			
		}
		
		[Test]
		public function tokenizeStringMixedWordsAndOtherChars():void {
			var result:Array = tokenizer.tokenize("one, two/three 4 , ", /[\s\,\/]/g);
			assertThat(result, array("one", "two", "three", "4"));
			
		}
	}
}