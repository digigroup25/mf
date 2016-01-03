package uiengine
{


	import factories.*;

	import flash.display.DisplayObject;

	import mx.collections.*;
	import mx.controls.DataGrid;

	import org.flexunit.asserts.assertTrue;

	import uiengine.datarenderer.*;


	public class DataRendererTest
	{
		[Test]
		public function test_render_ArrayCollection():void
		{
			var a:Array = POFactory.createTasks1();
			var context:DataRendererContext = new DataRendererContext(new ArrayCollection(a));
			var res:DisplayObject = DataRenderer.render(context);

			assertTrue("res is DataGrid", res is DataGrid);
		}
	}
}