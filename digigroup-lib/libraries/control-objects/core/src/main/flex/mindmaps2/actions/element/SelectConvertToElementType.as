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
	
	public class SelectConvertToElementType extends AbstractUserAction
	{
		private static const ci:ClassInspector = new ClassInspector();
		private var convertElementWindow:ConvertElementWindow;
		private var node:TreeCollectionEx;
		
		public function SelectConvertToElementType(name:String=null, repeatCount:int=1)
		{
			super(name, repeatCount);
			this.preconditions = [checkPreconditions];
		}
		
		private function checkPreconditions():Boolean {
			Require.notNull(this.input.mapContainer, "mapContainer");
			Require.notNull(this.input.mapContainer.mapContext, "mapContext");
			Require.notNull(this.input.node, "node");
			return true;
		}
		
		override protected function doExecute():void {
			
			node = TreeCollectionEx(this.input.node);
			var mapContext:MapContext = MapContext(this.input.mapContainer.mapContext);
			var currentElementType:Class = ci.getClass(node.vo);
			
			var allElementTypes:Array = ArrayUtil.copyArray(mapContext.nodeTypes);
			ArrayUtil.removeValueFromArray(allElementTypes, currentElementType);
			var convertableElementTypes:Array = allElementTypes;
			
			showConvertElementWindow(convertableElementTypes);
			
			//Alert.show(StringUtil.substitute("Convert element {0}", node.vo.name));
			//container.send(nodeMessages.ConvertNode(node, Task));
		}
		
		private function showConvertElementWindow(convertToElements:Array):void {
			convertElementWindow = new ConvertElementWindow();
			convertElementWindow.title = "Convert to";
			convertElementWindow.convertToElements = new ArrayCollection(convertToElements);
			PopUpManager.addPopUp(convertElementWindow, DisplayObject(FlexGlobals.topLevelApplication));
			PopUpManager.centerPopUp(convertElementWindow);
			convertElementWindow.addEventListener(ConvertElementWindowEvent.CONVERT, onConvert, false, 0, true);
			convertElementWindow.addEventListener(CloseEvent.CLOSE, onClose, false, 0, true);
		}
		
		private function onConvert(event:ConvertElementWindowEvent):void {
			PopUpManager.removePopUp(convertElementWindow);
			
			var convertElementToType:Class = event.convertElementToType;
			this.output.convertElementToType = convertElementToType;
			super.doExecute();
		}
		
		private function onClose(event:CloseEvent):void {
			PopUpManager.removePopUp(convertElementWindow);
			
			super.fail();
		}
	}
}