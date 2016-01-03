package components
{
	import commonutils.ClassInspector;
	
	public class FloatingWindowFactory
	{
		private var ci:ClassInspector = new ClassInspector();
		//private var model:MapModel = MapModel(ModelSingleton.getModel(MapModel));
		
		public function createStack():FloatingWindow {
			return new FloatingStackWindow();
		}
		
		public function createResizableWindowShade():IWindowShadeStack {
			return new ResizableWindowShadeStack();
		}
		public function create(showTextExport:Boolean=false, isCanvasDataContainer:Boolean=false):FloatingWindow
		{
			var fw:FloatingWindow;
			var controlClass:Class;
			if (showTextExport) 
				controlClass=FloatingWindowTextExport;
			else controlClass=FloatingWindow;
			fw = new controlClass();//(PopUpManager.createPopUp(container, controlClass, false));
			//PopUpManager.centerPopUp(fw);
			/* if ((event==null) || (event.targetView == null)) 
			{
				fw = FloatingWindow(PopUpManager.createPopUp(container, controlClass, false));
				PopUpManager.centerPopUp(fw);
				fw.e = event;
			} 
			else */
			//	fw = event.targetView as FloatingWindow;
			
			/* if (isCanvasDataContainer)
			{
				//replace VBox with Canvas
				fw.titleControl.removeChild(fw.container);
				fw.container = new Canvas();
				fw.titleControl.addChild(fw.container);
			} */
			//if (event!=null)
			//	fw.title = FloatingWindowHelper.getTitle(event);
			return fw;
		}
	}
}