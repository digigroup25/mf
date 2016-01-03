package components
{
	import flash.display.DisplayObject;
	
	import flexlib.containers.WindowShade;
	
	import mx.binding.utils.BindingUtils;

	public class BasicWindowShade extends WindowShade implements IWindowShade
	{
		private var previousOpenedHeight:Number = NaN;
		
		public function BasicWindowShade(){
			super();
			BindingUtils.bindSetter(onOpenedChange, this, "opened");
		}
		
		private function onOpenedChange(value:Boolean):void {
			if (!value) {
				previousOpenedHeight = this.height;
			}
			var eventType:String = (value) ? WindowShadeEvent.EXPAND : WindowShadeEvent.COLLAPSE;
			this.dispatchEvent(new WindowShadeEvent(eventType));
		}
		
		public function addContent(child:DisplayObject):void {
			this.addChild(child);
		}
		
		//(vr) hack, seems that WindowShade has a bug when reopening the window
		//it does not maintain its previous height thereby shrinking itself
		override protected function measure():void {
			super.measure();
			if (!opened) return;
			this.measuredHeight = this.measuredMinHeight = this.getExplicitOrMeasuredHeight();
			this.measuredWidth = this.measuredMinWidth = this.getExplicitOrMeasuredWidth();
								
			if (opened && !isNaN(previousOpenedHeight)) {
				this.measuredHeight = previousOpenedHeight;
			} /* else if (!opened) {
				this.measuredHeight = this.measuredMinHeight = 50;
			} */
		}
	}
}