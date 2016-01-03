package commonutils
{
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.core.UIComponent;
	
	public class UIControlUtil
	{
		public static function addEventListener(control:UIComponent, eventType:String, listener:Function):void{
			control.addEventListener(eventType, listener, false, 0, true);
		}
		
		public static function bindBidirectionally(model:Object, modelProperty:String, view:Object,
			viewProperty:String):Array {
				
			var cw1:ChangeWatcher = BindingUtils.bindProperty(view, viewProperty, model, modelProperty);
			var cw2:ChangeWatcher = BindingUtils.bindProperty(model, modelProperty, view, viewProperty);
			
			return [cw1, cw2];		
		}
	}
}