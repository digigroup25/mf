package mindmaps.elementderivatives.subway
{
	import collections.IIterator;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.utils.ArrayUtil;
	
	public class SubwayLayouter
	{
		//return a map of [Station:Point(x,y)]
		internal function computeFirstPass(subWay:Subway):Dictionary {
			var res:Dictionary = new Dictionary();
			for (var y:int=0; y<subWay.numberOfLines; y++) {
				var lineIterator:IIterator = subWay.getLineAt(y).createIterator();
				var x:int = -1;
				while (lineIterator.hasNext()) {
					x++;
					var station:Station = Station(lineIterator.next());
					if (station.isTransferStation()) {
						var transferStation:Station = station;
						//compute location only once
						if (res[station]!=undefined) {
							continue;
						}
						res[station] = new Point(x, calculateYMean(subWay, transferStation));
					}
					else {
						res[station] = new Point(x, y);
					}
				}
			}
			return res;
		}
		
		protected function calculateYMean(subWay:Subway, station:Station):Number {
			var lineIndices:Array = new Array();
			for each (var line:Line in station.lines) {
				lineIndices.push(subWay.getLineIndex(line));
			}
			var res:Number = getMean(lineIndices);
			return res;
		}
		
		private function sortPaths(subWay:Subway, pathsDictionary:Dictionary):ArrayCollection {
			var paths:ArrayCollection = new ArrayCollection();
			//convert dictionary to array
			for (var transferStation:Object in pathsDictionary) {
				paths.addItem({transferStation:transferStation, pathLength:pathsDictionary[transferStation]});
			}
			var sort:Sort = new Sort();
			sort.fields = [new SortField("pathLength")];
			paths.sort = sort;
			paths.refresh();
			return paths;
		}
		
		public function compute(subWay:Subway):SubwayLayout {
			var positions:Dictionary = computeFirstPass(subWay);
			computeSecondPass(subWay, positions);
			var res:SubwayLayout = new SubwayLayout(positions);
			return res;
		}
		
		
		private function computeSecondPass(subWay:Subway, res:Dictionary):void {
			var pathsDictionary:Dictionary = new Dictionary();
			calculatePathsFromStartToTransferStations(subWay, pathsDictionary);
			//sort all transfer stations according to their paths to the beginning of the line or neighboring station
			var paths:ArrayCollection = sortPaths(subWay, pathsDictionary);
			
			//set x on all transfer stations
			var currentLongestPath:int = 0;
			var path:Object;
			var transferStation:Station;
			var pathLength:int;
			
			for each (path in paths) {
				transferStation = Station(path.transferStation);
				pathLength = path.pathLength;
				var prevPoint:Point = res[path.transferStation];
				res[transferStation] = new Point(pathLength, prevPoint.y);
			}
			
			//assign x to all stations connected to a particular transfer station
			for each (path in paths) {
				pathLength = path.pathLength;
				transferStation = Station(path.transferStation);
				assignXToStations(transferStation, Point(res[transferStation]).x, res, true);
			}
			
			//assign x to all stations that are connected to the last transfer station
			var lastTransferStationIndex:int = paths.length-1;
			if (lastTransferStationIndex>=0) {
				var lastTransferStation:Station = Station(paths[lastTransferStationIndex].transferStation);
				assignXToStations(lastTransferStation, Point(res[lastTransferStation]).x, res, false);
			}
		}
		
		//returns a map of transferStation:x
		public function calculatePathsFromStartToTransferStations(subWay:Subway, paths:Dictionary):void {
			//find all transfer stations
			var transferStations:Array = subWay.getTransferStations();
			while (transferStations.length>0) {
				var transferStation:Station = transferStations[0];
				getXOfTransferStation(subWay, transferStations, transferStation, paths);
			}
		}
		
		private function getXOfTransferStation(subWay:Subway, transferStations:Array, transferStation:Station, paths:Dictionary):void {
			var transferStationIndex:int = ArrayUtil.getItemIndex(transferStation, transferStations);
			if (transferStationIndex==-1 || transferStations.length==0) {
				//assume already calculated path for that transfer station
				return;
			}
				
			//remove tstation
			transferStations.splice(transferStationIndex, 1);
			
			var path:Object = subWay.getLongestPathLengthFromTransferStation(transferStation);
			if (path.previousTransferStation==null) {
				paths[transferStation] = path.pathLength;
			}
			//there exists a tstation in front, calc path from that station
			else {
				var prevTransferStation:Station = path.previousTransferStation;
				getXOfTransferStation(subWay, transferStations, prevTransferStation, paths);
				paths[transferStation] = path.pathLength + 1 + paths[prevTransferStation];
			}
		}
		
		private function assignXToStations(transferStation:Station, x:int, positions:Dictionary, isReverse:Boolean):void {
			for each (var line:Line in transferStation.lines) {
				var it:LineIterator = new LineIterator(line, isReverse);
				it.moveTo(transferStation);
				var curX:int = x;
				while (it.hasNext()) {
					var station:Station = Station(it.next());
					if (station.isTransferStation()) break;
					var prevPoint:Point = positions[station];
					var newX:int = isReverse ? --curX : ++curX;
					positions[station] = new Point(newX, prevPoint.y);
				}
			}
		}
		
		private function getMean(series:Array):Number {
			var sum:Number = 0;
			for each (var number:Number in series) {
				sum += number;
			}
			return sum/series.length;
		}
	}
}