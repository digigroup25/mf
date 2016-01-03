package mindmaps.elementderivatives.subway
{
	import collections.IIterable;
	import collections.IIterator;
	
	import mx.collections.ArrayCollection;
	
	public class Line implements IIterable
	{
		private var _name:String;
		
		public function get name():String {
			return _name;
		}
		
		public var stations:ArrayCollection = new ArrayCollection();
		
		public function Line(name:String="") {
			this._name = name;
		}
		
		public function get numberOfStations():int {
			if (stations==null) return 0;
			return stations.length;
		}
		
		public function addStations (stations:Array):void {
			for each (var station:Station in stations) 
				addStation(station);
		}
		public function addStation(station:Station):Station {
			if (stations.contains(station)) return station;
			stations.addItem(station);
			station.addLine(this);
			return station;
		}
		
		public function addStationBefore(station:Station, beforeStation:Station):Station {
			var beforeStationIndex:int = stations.getItemIndex(beforeStation);
			if (beforeStationIndex==-1) throw new Error("beforeStation "+beforeStation+" does not exist");
			stations.addItemAt(station, beforeStationIndex);
			station.addLine(this);
			return station;
		}
		
		public function createIterator(type:Class=null):IIterator {
			return new LineIterator(this);
		}
		
		public function getStationAt(index:int):Station {
			return Station(stations.getItemAt(index));
		}
		
		public function getStationByName(name:String):Station {
			for each (var station:Station in this.stations) {
				if (station.name==name) return station;
			}
			return null;
		}
		
		public function replaceStation(station:Station, newStation:Station):void {
			var stationIndex:int = stations.getItemIndex(station);
			if (stationIndex==-1) throw new Error ("Station does not exist in the line");
			stations.setItemAt(newStation, stationIndex);
		}
	}
}