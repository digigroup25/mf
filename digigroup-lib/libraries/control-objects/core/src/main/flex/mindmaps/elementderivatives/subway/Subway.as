package mindmaps.elementderivatives.subway
{
	import collections.IIterator;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	public class Subway
	{
		public var lines:ArrayCollection = new ArrayCollection();
		
		public function Subway()
		{
		}
		
		public function addLines(lines:Array):void {
			for each (var line:Line in lines) {
				addLine(line);
			}
		}
		
		public function	get numberOfLines():int {
			return this.lines.length;
		}
		
		public function get numberOfStations():int {
			var res:int = 0;
			var allStations:Dictionary = new Dictionary();
			var station:Object;
			for each (var line:Line in lines) {
				for each (station in line.stations) {
					allStations[station] = 0;
				}
			}
			for (station in allStations)
				res++;
			return res;
		}
		
		public function getLineIndex(line:Line):int {
			return this.lines.getItemIndex(line);
		}
		
		public function getLineAt(index:int):Line {
			return Line(lines.getItemAt(index));
		}
		
		public function addLine(line:Line):void {
			if (lines.contains(line)) return;
			lines.addItem(line);
		}
		
		/* private function makeTransferable(station:Station):TransferStation {
			var res:TransferStation = new TransferStation(station.name);
			res.addLine(station.line);
			station.line.replaceStation(station, res);
			return res;
		}
 */		
		public function addStation(name:String, lines:Array):Station {
			var station:Station = new Station(name);
			for each(var line:Line in lines) {
				line.addStation(station);
			}
			return station;
		} 
		
		public function markAsTransferStations(stations:Array):Station {
			if (stations.length<2) throw new ArgumentError("Need to provide at least 2 stations");
			var transferStation:Station;
			for (var i:int=0; i<stations.length; i++) {
				if (i==0) {
					//set 1st station to point to multiple lines
					transferStation = Station(stations[0]);
					for (var j:int=1; j<stations.length; j++) {
						var otherStation:Station = Station(stations[j]);
						transferStation.addLine(otherStation.lines[0]);
					}
				}
				else {
					//remove other stations
					var stationToRemove:Station = Station(stations[i]);
					stationToRemove.lines[0].replaceStation(stationToRemove, transferStation);
				}
			}
			return transferStation;
		}
		
		public function getTransferStations():Array {
			var res:Array = new Array();
			for each (var line:Line in this.lines) {
				var it:IIterator = line.createIterator();
				while(it.hasNext()) {
					var transferStation:Station = Station(it.next());
					if ((transferStation.isTransferStation()) && (res.indexOf(transferStation)==-1))
						res.push(transferStation);
				}
			}
			return res;
		}
		
		public function getLongestPathLengthFromTransferStation(transferStation:Station):Object {
			var pathLengths:Array = new Array();
			var pathLength:int;
			for each (var line:Line in transferStation.lines) {
				var it:LineIterator = new LineIterator(line, true);
				it.moveTo(transferStation);
				var prevStationPath:Object = getPathLengthToNextTransferStationOrEnd(it);
				pathLengths.push(prevStationPath);
			}
			var res:Object = pathLengths[0];
			for (var i:int=1; i<pathLengths.length; i++) { 
				var curPathLength:Object = pathLengths[i];
				if (curPathLength.pathLength>res.pathLength)
					res = curPathLength;
			}
			return res;
		}
		
		private function getPathLengthToNextTransferStationOrEnd(it:IIterator):Object {
			var res:Object = null;
			var pathLength:int = 0;
			while (it.hasNext()) {
				 var station:Station = Station(it.next());
				 if (station.isTransferStation()) {
				 	res = {previousTransferStation:station, pathLength:pathLength};
				 	break;
				 }
				 else pathLength++;
			}
			//if reached the beginning of the line
			if (res==null) 
				res = {previousTransferStation:null, pathLength:pathLength};
			return res;
		}
	}
}