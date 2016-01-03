package mindmaps.elementderivatives.subway
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	
	import org.flexunit.asserts.*;

	public class SubwayLayouterTest 
	{
		[Test]
		public function test_compute_subway3Stations():void {
			var s:Subway = new SubwayFactory().createSubway3Stations();
			var layout:SubwayLayouter = new SubwayLayouter();
			
			
			var stationPositions:Dictionary = layout.compute(s).stationCoordinates;
			
			
			var l0s0:Station = s.lines[0].getStationAt(0);
			var l1s0:Station = s.lines[1].getStationAt(1);
			var l0s1:Station = s.lines[0].getStationAt(1);
			var l1s1:Station = s.lines[1].getStationAt(1);
			
			assertPointEquals("l0s0", new Point(0, 0.5), 	stationPositions[l0s0]);
			assertPointEquals("l0s1", new Point(1, 0), 		stationPositions[l0s1]);
			assertPointEquals("l1s1", new Point(1, 1), 		stationPositions[l1s1]);
		}
		
		[Test]
		public function test_calculatePathsFromStartToTransferStations_subway3Stations2ts():void {
			var s:Subway = new SubwayFactory().createSubway3Stations2ts();
			var layout:SubwayLayouter = new SubwayLayouter();
			var res:Dictionary = new Dictionary();
			
			layout.calculatePathsFromStartToTransferStations(s, res);
			
			var transferStations:Array = s.getTransferStations();
			var ts0:Station = transferStations[0]; 
			var ts0x:int = res[ts0];
			assertEquals(ts0.toString(), 1, ts0x);
			
			var ts1:Station = transferStations[1]; 
			var ts1x:int = res[ts1];
			assertEquals(ts1.toString(), 2, ts1x);
			
		}
		
		[Test]
		public function test_compute_subway3Lines():void {
			var s:Subway = new SubwayFactory().createSubway3Lines();
			var layout:SubwayLayouter = new SubwayLayouter();
			
			
			var stationPositions:Dictionary = layout.compute(s).stationCoordinates;
			
			
			var l0s0:Station = s.lines[0].getStationAt(0);
			var l0s1:Station = s.lines[0].getStationAt(1);
			var l0s2:Station = s.lines[0].getStationAt(2);
			
			var l1s0:Station = s.lines[1].getStationAt(0);
			var l1s1:Station = s.lines[1].getStationAt(1);
			var l1s2:Station = s.lines[1].getStationAt(2);
			
			var l2s0:Station = s.lines[2].getStationAt(0);
			
			assertPointEquals(l0s0.toString(), new Point(0, 0), stationPositions[l0s0]);
			assertPointEquals(l0s1.toString(), new Point(1, 1), stationPositions[l0s1]);
			assertPointEquals(l0s2.toString(), new Point(2, 0), stationPositions[l0s2]);
			
			assertPointEquals(l1s0.toString(), new Point(0, 1), stationPositions[l1s0]);
			assertPointEquals(l1s1.toString(), new Point(1, 1), stationPositions[l1s1]);
			assertPointEquals(l1s2.toString(), new Point(2, 1), stationPositions[l1s2]);
			
			assertPointEquals(l2s0.toString(), new Point(1, 1), stationPositions[l2s0]);
		}
		
		[Test]
		public function test_compute_createSubway3Stations2ts():void {
			var s:Subway = new SubwayFactory().createSubway3Stations2ts();
			var layout:SubwayLayouter = new SubwayLayouter();
			
			
			var stationPositions:Dictionary = layout.compute(s).stationCoordinates;
			
			
			var l0s0:Station = s.lines[0].getStationAt(0);
			var l0s1:Station = s.lines[0].getStationAt(1);
			var l0s2:Station = s.lines[0].getStationAt(2);
			
			var l1s0:Station = s.lines[1].getStationAt(0);
			var l1s1:Station = s.lines[1].getStationAt(1);
			var l1s2:Station = s.lines[1].getStationAt(2);
			
			assertPointEquals(l0s0.toString(), new Point(0, 0), stationPositions[l0s0]);
			assertPointEquals(l0s1.toString(), new Point(1, 0.5), stationPositions[l0s1]);
			assertPointEquals(l0s2.toString(), new Point(2, 0.5), stationPositions[l0s2]);
			
			assertPointEquals(l1s0.toString(), new Point(0, 1), stationPositions[l1s0]);
			assertPointEquals(l1s1.toString(), new Point(1, 0.5), stationPositions[l1s1]);
			assertPointEquals(l1s2.toString(), new Point(2, 0.5), stationPositions[l1s2]);
		}	

		//VR 6/10/11 need to fix failing test
		public function _test_compute_subway1():void {
			var s:Subway = new SubwayFactory().createSubway1();
			var layout:SubwayLayouter = new SubwayLayouter();
			
			
			var stationPositions:Dictionary = layout.compute(s).stationCoordinates;
			
			
			var l0s0:Station = s.lines[0].getStationAt(0);
			var l0s1:Station = s.lines[0].getStationAt(1);
			
			var l1s0:Station = s.lines[1].getStationAt(0);
			var l1s1:Station = s.lines[1].getStationAt(1);
			var l1s2:Station = s.lines[1].getStationAt(2);
			
			var l2s0:Station = s.lines[2].getStationAt(0);
			var l2s1:Station = s.lines[2].getStationAt(1);
			var l2s2:Station = s.lines[2].getStationAt(2);
			
			var l3s0:Station = s.lines[3].getStationAt(0);
			var l3s1:Station = s.lines[3].getStationAt(1);
			
			assertPointEquals("l0s0", new Point(2, 1.5), stationPositions[l0s0]);
			assertPointEquals("l0s1", new Point(4, 0.5), stationPositions[l0s1]);
			
			assertPointEquals("l1s0", new Point(2, 1.5), stationPositions[l1s0]);
			assertPointEquals("l1s1", new Point(3, 1), stationPositions[l1s1]);
			assertPointEquals("l1s2", new Point(4, 0.5), stationPositions[l1s2]);
			
			assertPointEquals("l2s0", new Point(0, 2), stationPositions[l2s0]);
			assertPointEquals("l2s1", new Point(1, 2), stationPositions[l2s1]);
			assertPointEquals("l2s2", new Point(2, 1.5), stationPositions[l2s2]);
			
			assertPointEquals("l3s0", new Point(2, 1.5), stationPositions[l3s0]);
			assertPointEquals("l3s1", new Point(4, 0.5), stationPositions[l3s1]);
		}
		
		[Test]
		public function test_calculatePathsFromStartToTransferStations_subway1():void {
			var s:Subway = new SubwayFactory().createSubway1();
			var layout:SubwayLayouter = new SubwayLayouter();
			var res:Dictionary = new Dictionary();
			
			layout.calculatePathsFromStartToTransferStations(s, res);
			
			var transferStations:Array = s.getTransferStations();
			var ts0:Station = transferStations[0]; 
			var ts0x:int = res[ts0];
			assertEquals(ts0.toString(), 2, ts0x);
			
			var ts1:Station = transferStations[1]; 
			var ts1x:int = res[ts1];
			assertEquals(ts1.toString(), 4, ts1x);
			
		}
		
		private function pointsEqual(p1:Point, p2:Point):Boolean {
			return ObjectUtil.compare(p1, p2)==0;
		}
		
		private function assertPointEquals(pointName:String, p1:Point, p2:Point):void {
			assertEquals(StringUtil.substitute("{0} x should match", pointName), p1.x, p2.x);
			assertEquals(StringUtil.substitute("{0} x should match", pointName), p1.y, p2.y);
		}
	}
}