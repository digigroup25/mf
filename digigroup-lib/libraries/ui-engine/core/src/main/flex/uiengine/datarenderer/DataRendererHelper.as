package uiengine.datarenderer
{


	import com.roguedevelopment.objecthandles.ObjectHandles;

	import commonutils.*;

	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;

	import mx.binding.utils.*;
	import mx.controls.*;
	import mx.core.*;


	public class DataRendererHelper
	{
		private var ci:ClassInspector;
		private var defaultMap:DefaultControlMap;


		public function DataRendererHelper(controlMap:DefaultControlMap)
		{
			this.ci = IocDataRendererFactory.createClassInspector();
			this.defaultMap = controlMap;
		}


		public function createControl(attr:Attribute):UIComponent
		{
			var res:UIComponent;

			//if attr.property matches keyword in ViewKeywordControlMap use the control from there
			var map:ViewKeywordControlMap = ViewKeywordControlMap.getInstance();
			var control:Class = map.getControl(attr.name);
			var cf:ClassFactory;
			if (control != null)
			{
				cf = new ClassFactory(control);
			}
			else
			{
				cf = new ClassFactory(defaultMap.getControl(attr.type));
			}
			res = cf.newInstance();
			return res;
		}


		public function wrapObjectHandles(control:UIComponent):UIComponent
		{
			if (!defaultMap.allowsObjectHandles(ci.getClass(control)))
			{
				return control;
			}
			else
			{
				control.percentHeight = 100;
				control.percentWidth = 100;

				var oh:ObjectHandles = ObjectHandlesFactory.create();
				(control.minWidth > 0) ? oh.width = control.minWidth : oh.percentWidth = 100;
				(control.minHeight > 0) ? oh.height = control.minHeight : oh.percentHeight = 100;

				//VR_Hack: controls should provide their default sizes
				/*if (control is TextEditorEx)
				 {
				 oh.width=oh.height=200;
				 }*/
				oh.addChild(control);
				return oh;
			}
		}
	}
}