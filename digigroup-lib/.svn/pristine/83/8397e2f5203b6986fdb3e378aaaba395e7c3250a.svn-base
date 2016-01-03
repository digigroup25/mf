package uiengine.datarenderer
{
	import commonutils.*;
	
	import flash.display.*;
	
	import mx.collections.*;
	import mx.containers.*;
	import mx.controls.*;
	import mx.core.*;
	
	public class AbstractDataRenderer
	{
		private var defaultMap:DefaultControlMap = DefaultControlMap.getInstance();

		
		/**
		* algorithm:
		 * 
		 * 	build container (or use parentControl if provided as a container)
		 *  foreach attribute in the model
		 * 		build control
		 * 		bind model's value to control's value
		 *  
		*/
		public function render(context:DataRendererContext):DisplayObject
		{
			var container:UIComponent = setContainer(context);
			
			if ((context.vo is ArrayCollection) &&(context.vo.length==0)) //return empty
				return container;
			populateContainer(context, container);
			if (context.defaultEventHandling)
				addEventHandling(context, container);
			return container;
		}
		
		private function setContainer(context:DataRendererContext):UIComponent
		{
			
			if (context.container!=null)
				Container(context.container).removeAllChildren();
			var control:UIComponent = assignContainer(context);
			
			//assign name to control
			if (context.controlName!=null)
				control.name = context.controlName;
			
			//if there is container
			if ((context.container!=null) && (context.container!=control))
			{
				var container:Container = Container(context.container);
				if (context.useObjectHandles)
				{
					var oh:DisplayObject = new DataRendererHelper(defaultMap).wrapObjectHandles(control);
					container.addChild(oh);
				}
				else
					container.addChild(control);				
			}
			return control;
		}
		
		protected function assignContainer(context:DataRendererContext):UIComponent
		{
			throw new Error("abstract class");
			return null;
		}
		
		protected function getAllProperties(context:DataRendererContext, container:UIComponent):Array
		{
			throw new Error("abstract class");
			return null;	
		}
		
		protected function assignDataToControl(context:DataRendererContext, container:UIComponent, properties:Array):void
		{
			throw new Error("abstract class");
		}
		
		private function populateContainer(context:DataRendererContext, container:UIComponent):void
		{
			
			var allData:Array = getAllProperties(context, container);
			var visibleData:Array = allData;//by default
			
			//filter all data into visible data
			if (context.viewDataFilter!=null && allData!=null) //for empty object
				visibleData = context.viewDataFilter.filter(allData);
	
			assignDataToControl(context, container, visibleData);
		}
		
		protected function addEventHandling(context:DataRendererContext, container:UIComponent):void
		{
		
		}
	}
}