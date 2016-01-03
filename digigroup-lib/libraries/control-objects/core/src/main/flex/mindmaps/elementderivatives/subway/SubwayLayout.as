package mindmaps.elementderivatives.subway
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class SubwayLayout
	{
		private var _stationCoordinates:Dictionary;
		private var computedMaxXValue:Number = 0;
		private var computedMaxX:Boolean = false;
		
		//station:Point(x,y) in relative coordinates 
		public function get stationCoordinates():Dictionary {
			return _stationCoordinates;
		}
		
		public function SubwayLayout(stationCoordinates:Dictionary)
		{
			this._stationCoordinates = stationCoordinates;
		}
		
		public function getMaxX():Number {
			if (computedMaxX)
				return computedMaxXValue;
			computedMaxX = true;
			for each (var p:Point in stationCoordinates) {
				if (p.x>computedMaxXValue) 
					computedMaxXValue = p.x;
			}
			return computedMaxXValue;
		}
	}
}