package mindmaps2.actions.element
{
	import actions.AbstractUserAction;
	
	import assertions.Require;
	
	import collections.TreeCollectionEx;
	
	import com.adobe.utils.ArrayUtil;
	
	import commonutils.ClassInspector;
	
	import flash.display.DisplayObject;
	
	import mf.framework.Container2;
	import mf.framework.IReceiver;
	import mf.framework.Message;
	
	import mindmaps.map.MapContext;
	import mindmaps.map.messages.NodeMessageFactory;
	import mindmaps.map.messages.NodeMessages;
	import mindmaps.map.ui.actions.messages.MapMessageFactory;
	
	import mindmaps2.AppSettings;
	import mindmaps2.elements.ui.ConvertElementWindow;
	import mindmaps2.elements.ui.ConvertElementWindowEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;
	
	import vos.Task;
	
	public class ConvertElement extends AbstractUserAction 
	{
		
		public function ConvertElement(name:String="Convert", repeatCount:int=AppSettings.DEFAULT_REPEAT_COUNT)
		{
			super(name, repeatCount);
			this.addChildren([new SelectConvertToElementType(), new ConvertElementToType()]);
			this.preconditions = [checkPreconditions];
		}
		
		private function checkPreconditions():Boolean {
			Require.notNull(this.input.mapContainer, "mapContainer");
			Require.notNull(this.input.mapContainer.mapContext, "mapContext");
			Require.notNull(this.input.node, "node");
			return true;
		}
		
	}
}