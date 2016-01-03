package mindmaps.importexport
{
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;

	public class CompositeMatchTest
	{
		
		[Test]
		public function containsOneSimpleMatch():void {
			var compositeMatch:CompositeMatch = new CompositeMatch([MatchTestData.simpleMatch1]);
			
			var matches:Array = compositeMatch.matches;
			assertThat(matches, array(MatchTestData.simpleMatch1));
		}
		
		[Test]
		public function containsOneSimpleOneCompositeMatch():void {
			var rootCompositeMatch:CompositeMatch = new CompositeMatch(
				[MatchTestData.simpleMatch1, MatchTestData.compositeMatch]);
			
			var matches:Array = rootCompositeMatch.matches;
			assertThat(matches, array(MatchTestData.simpleMatch1, 
				MatchTestData.simpleMatch2, MatchTestData.simpleMatch3));
		}
	}
}