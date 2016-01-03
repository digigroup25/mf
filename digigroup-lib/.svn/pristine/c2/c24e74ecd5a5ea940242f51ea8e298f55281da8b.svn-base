package components
{
	import collections.ICollection;
	
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Menu;
	import mx.events.FlexEvent;
	import mx.events.MenuEvent;

	public class InteractiveMenu extends Menu
	{
		private var timer:Timer;
			
		private var _lastCursorPosition:Point = new Point(0,0);
		
		private var dataProviderChanged:Boolean = false;
		private var _dataProvider:Object;
		private var itemClicked:Boolean = false;
		
		private var labelFieldChanged:Boolean = false;
		
		private var _ignoreHierarchy:Boolean = true;
		private var stopped:Boolean = false;
		
		public var delay:int = 2000;
		
		public var showMenuCondition:Function = function():Boolean {return true;}
		public function get ignoreHierarchy():Boolean {
			return _ignoreHierarchy;
		}
		
		public function set ignoreHierarchy(value:Boolean):void {
			this._ignoreHierarchy = value;
			this.invalidateProperties();
		}
		
		
		public function get lastCursorPosition():Point {
			return _lastCursorPosition;
		}
	
		override public function set dataProvider(value:Object):void {
			_dataProvider = super.dataProvider = value;
			this.dataProviderChanged = true;
			this.invalidateProperties();
			/*this.invalidateSize(); */
		}
		
		override public function set labelField(value:String):void {
			super.labelField = value;
			this.labelFieldChanged = true;
			this.invalidateProperties();
		}
		
		private function wrapChildrenInData(children:ArrayCollection):ArrayCollection {
			var res:ArrayCollection = new ArrayCollection();
			for each (var child:Object in children) {
				var wrappedChild:Object = new Object();
				wrappedChild[labelField] = child[labelField];
				wrappedChild.data = child;
				res.addItem(wrappedChild);
			}
			return res;
		}
		override protected function commitProperties():void {
			if (dataProviderChanged) {
				dataProviderChanged = false;
				
				if (ignoreHierarchy) {
					if (_dataProvider) {
						var children:ArrayCollection;
						if (_dataProvider is Array)
							children = new ArrayCollection(_dataProvider as Array);
						else if (_dataProvider.hasOwnProperty("children")
							&& _dataProvider.children is ArrayCollection) {
								children = ArrayCollection(_dataProvider.children);
							}
						if (children) {
							var newChildren:ArrayCollection = wrapChildrenInData(children);
							this.dataProvider = newChildren;
						}
					}
				}
								
				if (this.labelFieldChanged) {
					this.labelFieldChanged = false;
				}
				else if (this.dataProvider is XML) {
					this.labelField = "@label";
				}
				else if (this.dataProvider is ICollection) {
					this.labelField = "label";
				}
			}
			super.commitProperties();
		}
		
		override protected function measure():void {
			super.measure();
			measuredWidth += 80;
		}
		
		
		public function InteractiveMenu()
		{
			super();
			this.showRoot = false;
			this.ignoreHierarchy = true;
			
			//hide can happen if either a user clicked on menu or clicked outside
			this.addEventListener(FlexEvent.HIDE, onMenuHide);
			startTimer();
		}
		
		private function onMenuHide(event:FlexEvent):void {
			if (stopped)
				return;
			trace("hide");
			if (!itemClicked) {
				restart();
			} 
			itemClicked = false;
		}
		
		public function pause():void {
			trace("pause");
			timer.stop();
			this.removeEventListener(TimerEvent.TIMER, onTimer);
		}
		
		public function start():void {
			trace("start");
			stopped = false;
			restart();
		}
		
		public function stop():void {
			this.stopped = true;
			timer.stop();
			this.removeEventListener(TimerEvent.TIMER, onTimer);
			this.hide();
			
		}
		
		private function restart():void {
			if (timer) {
				if (timer.hasEventListener(TimerEvent.TIMER)) 
					timer.removeEventListener(TimerEvent.TIMER, onTimer);
				if (timer.running) {
					timer.stop();
					timer.reset();
				}
			}
			startTimer();
		}
		
		private function startTimer():void {
			trace("startTimer");
			timer = new Timer(delay);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		private function onTimer(event:TimerEvent):void {
			trace("onTimer", timer.currentCount);
			
			pause();
			var stagePoint:Point = new Point (stage.mouseX, stage.mouseY);
			var localPoint:Point = this.globalToLocal(stagePoint);
			_lastCursorPosition = stagePoint;
			trace("stagePoint", stagePoint);
			trace("localPoint", localPoint);
			
			if (showMenuCondition()) {	
				showMenu();
			}
		}
		
        // Create and display the Menu control.
        private function showMenu():void {
        	trace("showMenu");
            this.addEventListener(MenuEvent.ITEM_CLICK, menuHandler);
            this.show(lastCursorPosition.x, lastCursorPosition.y);
        }
   
        // keep track if user chose something from the menu
        private function menuHandler(event:MenuEvent):void  {
           itemClicked = true;
        }
		
	}
}