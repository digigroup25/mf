package uiengine.datarenderer
{
	import commonutils.ClassInspector;
	
	import flash.display.*;
	
	import mx.core.UIComponent;
	
	import reflection.*;
	
	public class DataRenderer
	{
		public static function render(context:DataRendererContext):DisplayObject
		{
			var renderer:AbstractDataRenderer = getRenderer(context);
			return renderer.render(context);
		}
		
		private static function getRenderer(context:DataRendererContext):AbstractDataRenderer {
			var renderer:AbstractDataRenderer;
			var voInspector:VOInspector = new VOInspector();
			if ((context.vo==null) || 
				(context.vo.hasOwnProperty("length") && (context.vo["length"]==0)))
				renderer=new EmptyRenderer();
			else if (voInspector.isCollection(context.vo))
				renderer=new CollectionRenderer();
			else
				renderer=new ObjectRenderer();
			return renderer;
		}
		public static function renderContainer(context:DataRendererContext):Render {
			var renderer:AbstractDataRenderer = getRenderer(context);
			var component:UIComponent = UIComponent(renderer.render(context));
			var res:Render = new Render(component, context.vo, context.container, context.watchers);
			return res;
		}
	}
}