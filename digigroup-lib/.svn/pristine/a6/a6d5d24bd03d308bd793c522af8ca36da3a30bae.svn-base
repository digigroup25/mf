package mindmaps.elementderivatives.subway
{
	import org.flexunit.asserts.assertEquals;

	public class SubwayLayoutTest 
	{
		[Test]
		public function test_getMaxX_3stations():void {
			var s:Subway = new SubwayFactory().createSubway3Stations();
			var layout:SubwayLayout = new SubwayLayouter().compute(s);
			var res:Number = layout.getMaxX();
			assertEquals(1, res);
		}
	}
}