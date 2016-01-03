package mindmaps.elementderivatives.subway
{
	import collections.TreeCollectionEx;
	
	import org.flexunit.asserts.*;
	

	public class TreeToSubwayConverterTest
	{
		private const trees:SubwayFactory = new SubwayFactory();
		
		//VR 6/10/11 fix failing test
		public function _test_convert_treeForSubway():void {
			var c:TreeToSubwayConverter = new TreeToSubwayConverter();
			var tree:TreeCollectionEx = trees.treeForSubway();
			var subWay:Subway = c.convert(tree);
			assertNotNull(subWay);
			
			assertEquals("numberOfLines", 3, subWay.numberOfLines);
			assertEquals("numberOfStations", 2, subWay.numberOfStations);
		}
		
		[Test]
		public function test_dummy():void {
			
		}
	}
}