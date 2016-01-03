package mindmaps.elementderivatives.subway
{


	import org.flexunit.asserts.assertEquals;


	public class LineTest
	{
		public function LineTest()
		{
		}

		[Test]
		public function test_ctor():void {
			var line:Line = new LineFactory().createStations(2);
			
			assertEquals(2, line.numberOfStations);
		}
	}
}