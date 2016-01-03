package mindmaps.elementderivatives.subway
{
	import collections.IIterator;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import mx.controls.Label;
	import mx.utils.StringUtil;
	
	public class SubwayDrawer
	{
		private static const scale:int	= 100;
		private static const stationColor:uint = 0xff0000;
		private static const minStationRadius:int = 7;
		private static const defaultStationRadius:int = 12;
		private var stationRadius:int = defaultStationRadius;
		private var lineThickness:int = stationRadius;
		private var showLabels:Boolean = true;
		
		private var width:Number;
		private var height:Number;
		private var graphics:Graphics;
		private var view:Sprite;
		private var stationClass:Class;
		
		private var stationsDrawn:Dictionary;
		
		public function SubwayDrawer(view:Sprite, width:Number, height:Number, stationClass:Class)
		{
			this.view = view;
			this.graphics = view.graphics;
			this.width = width;
			this.height = height;
			this.stationClass = stationClass;
			//graphics.lineStyle(3);
		}
		 
		public function draw(subWay:Subway, layouter:SubwayLayouter):void {
			var layout:SubwayLayout = layouter.compute(subWay);
			//reset which stations were drawn
			stationsDrawn = new Dictionary(true);
			var stationPositions:Dictionary = layout.stationCoordinates;
			
			//compute deltaX and deltaY
			var maxStationsHorizontally:int = layout.getMaxX();
			var numberOfLines:int = subWay.numberOfLines;
			
			var roughDeltaX:Number = width / maxStationsHorizontally;
			var roughDeltaY:Number = height / numberOfLines;
			
			if (roughDeltaX < 40) { 
				stationRadius = lineThickness = minStationRadius;
				showLabels = false;
			}
			
			//compute precise deltaX and deltaY based on the radius
			var leftGap:int = stationRadius;
			var topGap:int = stationRadius;
			var deltaX:Number = (width - 2*stationRadius) / maxStationsHorizontally;
			var deltaY:Number = (height - 2*stationRadius) / numberOfLines;
			
			var lineCounter:int = -1;
			for each (var line:Line in subWay.lines) {
				lineCounter++;
				var stationColor:uint = LineColors.defaultColors[lineCounter%LineColors.defaultColors.length];
				graphics.lineStyle(lineThickness, stationColor);
				var lineIterator:IIterator = line.createIterator();
				var stationCounter:int = -1;
				while (lineIterator.hasNext()) {
					stationCounter++;
					var station:Station = Station(lineIterator.next());
					var x:Number = stationPositions[station].x;
					var y:Number = stationPositions[station].y;
					var tx:Number = deltaX * x + leftGap;
					var ty:Number = deltaY * y + topGap;
					trace (StringUtil.substitute("line={2}, x={0}, y={1}", x, y, line));
					var moveOrLineFunction:Function;
					moveOrLineFunction = (stationCounter==0) ? graphics.moveTo : graphics.lineTo; 
						
					
					moveOrLineFunction(tx, ty);
					if (!isStationDrawn(station)) {
						setStationDrawn(station);
						drawStation(station, tx, ty, stationColor);
						if (showLabels) 
							drawStationLabel(station, tx, ty);
					}
				}
			}
		}
		
		private function isStationDrawn(station:Station):Boolean {
			return stationsDrawn[station]!=null;
		}
		
		private function setStationDrawn(station:Station):void {
			stationsDrawn[station] = true;
		}
		
		private function drawStation(station:Station, x:Number, y:Number, color:uint):void {
			if (stationClass==null) {
				graphics.beginFill(color);
				graphics.drawCircle(x, y, stationRadius);
				graphics.endFill();
			}
			else {
				var stationView:DisplayObject = new stationClass();
				stationView.x = x;
				stationView.y = y;
				stationView.width = stationView.height = stationRadius;
				Object(stationView).label = station.name;
				Object(stationView).visited = station.visited;
				Object(stationView).radius = stationRadius;
				Object(stationView).stationColor = color;
				view.addChild(stationView);
			}
		}
		
		private function drawStationLabel(station:Station, x:Number, y:Number):void {
			var label:Label = new Label();
			label.x = x;
			label.y = y + stationRadius*1.25;
			label.width = 300;
			label.height = 50;
			label.text = station.name;
			view.addChild(label);
		}
	}
}