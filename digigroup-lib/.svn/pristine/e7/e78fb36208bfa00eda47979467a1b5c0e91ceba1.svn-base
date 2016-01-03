package uiengine.datarenderer
{
	import collections.*;
	
	import commonutils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.utils.*;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.containers.*;
	import mx.controls.*;
	import mx.core.*;
	
	public class ObjectRenderer extends AbstractDataRenderer
	{
		private var ci:ClassInspector = new ClassInspector();
		private var helper:DataRendererHelper;
		private var defaultMap:DefaultControlMap = DefaultControlMap.getInstance();

		protected override function assignContainer(context:DataRendererContext):UIComponent
		{
			helper = IocDataRendererFactory.createDataRendererHelper(defaultMap);
			//use renderer if exists
			var shortClassName:String = ci.getClassName(context.vo, true);
			var item:ControlMapItem  = defaultMap.getControlMapItemByType(shortClassName);
			if (item!=null && item.isCustomRenderer) {
				return new item.control();
			}
			else if (context.container==null)
				return new VBox();
			else return context.container;	
		}
		
		protected override function getAllProperties(context:DataRendererContext, container:UIComponent):Array
		{
			return ci.getDataAttributes(context.vo);
		}
		
		protected override function assignDataToControl(context:DataRendererContext, container:UIComponent, properties:Array):void
		{
			var control:UIComponent;
			var watchers:Array = context.watchers;
			//build control and assign value
			
			//use renderer if exists
			var shortClassName:String = ci.getClassName(context.vo, true);
			var item:ControlMapItem  = defaultMap.getControlMapItemByType(shortClassName);
			if (item!=null && item.isCustomRenderer) {
				IDataRenderer(container).data = context.vo;
			}
			else {
				for each (var attr:Attribute in properties)
				{
					
					//otherwise render individual fields 
					var label:Label = new Label();
					label.text = attr.name;
					
					control = helper.createControl(attr);
					
					//bidirectional binding
					var controlProperty:String = defaultMap.getControlValueByControlClass(ci.getClass(control));
					//control[controlValue] = context.vo[attr.name];
					control.name = attr.name;
					
					var watcher:ChangeWatcher;
					var watcher2:ChangeWatcher;
					
					watcher = BindingUtils.bindProperty(control, controlProperty, context.vo, attr.name);
					watcher2 = BindingUtils.bindProperty(context.vo, attr.name, control, controlProperty);
					watchers.push(watcher, watcher2);
					
					if (context.useObjectHandles)
						control = helper.wrapObjectHandles(control);
					
					if (context.showLabels)
						container.addChild(label);
					container.addChild(control);
				}
			}
			
		}
		
		/* private function updateModel(e:FocusEvent):void{
			trace("updateModel");
			var control:UIComponent = UIComponent(e.target);
			var controlValue:String = defaultMap.getControlValueByControlClass(ci.getClass(control));
			var modelDesc:Object = control.automationDelegate;
			var model:* = modelDesc["model"];
			var attrName:String = modelDesc["attrName"];
			model[attrName] = control[controlValue];
		} */
	}
}