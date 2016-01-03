package mindmaps.importexport
{
	import collections.HashMap;
	
	import mx.collections.ArrayCollection;
	
	import org.hamcrest.assertThat;

	public class MatchMapBuilderTest
	{
		
		private const builder:MatchMapBuilder = new MatchMapBuilder();
		
		public function MatchMapBuilderTest()
		{
		}
		
		[Test]
		public function simpleMatcherOnly():void {
			var matchMap:HashMap = builder.build([""], [SimpleMatcherFake], null);
			assertThat(matchMap.size==1);
		}
		
		[Test]
		public function compositeMatcherOnly():void {
			var matchMap:HashMap = builder.build([""], [CompositeMatcherFake], null);
			assertThat(matchMap.size==2);
		}
		
		[Test]
		public function simpleAndCompositeMatchers():void {
			var matchMap:HashMap = builder.build(["", ""], [SimpleMatcherFake, CompositeMatcherFake], null);
			assertThat(matchMap.size==3);
		}
	}
}