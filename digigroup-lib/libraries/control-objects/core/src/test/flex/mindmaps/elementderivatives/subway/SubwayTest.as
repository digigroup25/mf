package mindmaps.elementderivatives.subway
{
	import collections.IIterator;

	import org.flexunit.asserts.assertEquals;


	public class SubwayTest
	{
		public function SubwayTest()
		{
		}

		[Test]
		public function test_markStationAsTransferable():void {
			var s:Subway = new SubwayFactory().createSubway3Stations();
			var line0:Line = s.lines[0];
			var line1:Line = s.lines[1];
			
			var line0It:IIterator = line0.createIterator();
			
			assertEquals(2, line0.numberOfStations);
			var line0s0:Station = Station(line0It.next());
			var line0s1:Station = Station(line0It.next());
			
			assertEquals(line0.getStationAt(1), line0s1);
			
			var line1It:IIterator = line1.createIterator();
			var line1s0:Station = Station(line1It.next());
			var line1s1:Station = Station(line1It.next());
			assertEquals("s0 should be the same", line0s0, line1s0);
			assertEquals(line1.getStationAt(1), line1s1);
		}

		[Test]
		public function test_getTransferStations_3stations():void {
			var s:Subway = new SubwayFactory().createSubway3Stations();
			var res:Array = s.getTransferStations();
			assertEquals(1, res.length);
		}

		[Test]
		public function test_getLongestPathLengthFromTransferStation_Subway1():void {
			var s:Subway = new SubwayFactory().createSubway1();
			var transferStation:Station = s.getTransferStations()[0];
			var longestPath:Object = s.getLongestPathLengthFromTransferStation(transferStation);
			assertEquals(2, longestPath.pathLength); 
			
			transferStation = s.getTransferStations()[1];
			longestPath = s.getLongestPathLengthFromTransferStation(transferStation);
			assertEquals(1, longestPath.pathLength); 
		}

		[Test]
		public function test_numberOfStations_subway1():void {
			var s:Subway = new SubwayFactory().createSubway1();
			assertEquals(6, s.numberOfStations);
		}
	}
}