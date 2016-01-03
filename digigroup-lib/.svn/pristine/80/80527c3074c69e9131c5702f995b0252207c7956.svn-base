package uiengine.datarenderer
{
	import commonutils.*;
	
	import mx.controls.*;
	import mx.core.*;
	
	import reflection.*;
	
	import uiengine.*;
	
	public class EmptyRenderer extends AbstractDataRenderer
	{
		private var voInspector:VOInspector = new VOInspector();
		protected override function assignContainer(context:DataRendererContext):UIComponent
		{
			var res:UIComponent;
			var label:Label = new Label();
			label.text = "empty";
			res = label;
			res.percentHeight = 100;
			return res;
		}
		
		protected override function getAllProperties(context:DataRendererContext, container:UIComponent):Array
		{
			return null;
		}
		
		protected override function assignDataToControl(context:DataRendererContext, container:UIComponent, properties:Array):void
		{
			
		}
	}
}