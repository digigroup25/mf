package mindmaps.models.search
{
	import collections.TreeCollectionEx;
	
	import factories.TreeFactory;
	
	import mindmaps.*;
	import mindmaps.search.SearchResult;
	import mindmaps.search.Searcher;
	
	import mx.collections.ArrayCollection;
	
	import org.flexunit.asserts.*;
	
	public class SearcherTest
	{
		private static const searcher:Searcher = new Searcher();
		
		[Test]
		public function test_search_1node():void
		{
			var map:TreeCollectionEx = new TreeFactory().create1NodeCollection_Appointment();
			
			var res:SearchResult = searcher.search("Appointment1", map);
			assertOneWordResult(map, res.matches, "word match");
			
			res = searcher.search("App", map);
			assertZeroWordResult(map, res.matches, "start substring match");
			
			res = searcher.search("poi", map);
			assertZeroWordResult(map, res.matches, "middle substring match");
			
			res = searcher.search("app", map);
			assertZeroWordResult(map, res.matches, "case-insensitive match");
			
			res = searcher.search("Appt", map);
			assertZeroWordResult(map, res.matches, "no match");
		}
		
		private function assertOneWordResult(map:TreeCollectionEx, res:ArrayCollection, message:String):void {
			assertEquals(message, 1, res.length);
			assertEquals(message + " - matching container", "Appointment1", res[0].elementProperty);
			assertEquals(message + " - reference to object", map, res[0].element);
		}
		
		private function assertZeroWordResult(map:TreeCollectionEx, res:ArrayCollection, message:String):void {
			assertEquals(message, 0, res.length);
		}
		
		[Test]
		public function test_search_severalMatchingTerms():void {
			//test that if 2 or more terms are found in the same element, this elements gets only added once
			var map:TreeCollectionEx = new TreeFactory().create1NodeCollection_Appointment();
			map.vo.name = "a b c";
			var res:SearchResult = searcher.search("a b", map);
			
			assertEquals(1, res.matches.length);
			assertEquals(map, res.matches[0].element);
		}
		
		[Test]
		public function test_search_parent2children_any_word():void
		{
			var map:TreeCollectionEx = new TreeFactory().createParentNChildren(2);
			map.vo = {name:"abc"};
			map.children[0].vo = {name:"de"};
			map.children[1].vo = {name:"fgh"};
			
			var res:SearchResult = searcher.search("abc de", map);
			assertTwoWordsResult(res.matches, "two word match");
			
			res = searcher.search("bc e", map);
			assertZeroWordResult(map, res.matches, "two partial word match");
			
			//double space between words
			res = searcher.search("abc  de", map);
			assertEquals(res.searchTerms, "abc de");
			assertTwoWordsResult(res.matches, "double space");
		}
		
		private function assertTwoWordsResult(res:ArrayCollection, message:String=""):void {
			assertEquals(message, 2, res.length);
			assertEquals("any word match", "abc", res[0].elementProperty);
			assertEquals("any word match", "de", res[1].elementProperty);
		}
		
		[Test]
		public function test_isMatch():void {
			assertTrue("exact match, one word", searcher.isMatch("abc", " abc "));
			assertFalse("no match, one word", searcher.isMatch("ab", "abc"));
			assertFalse("no match, one word", searcher.isMatch("abc", "ab"));
		}

	}
}