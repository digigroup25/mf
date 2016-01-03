package uiengine.datarenderer
{
	import com.roguedevelopment.objecthandles.ObjectHandles;
	
	public class ObjectHandlesFactory
	{
		public static function create(hasBorder:Boolean=false):ObjectHandles
		{
			var oh:ObjectHandles = new ObjectHandles();
			oh.mouseCursors = null;
			oh.mouseChildren = true;
			oh.allowRotate = false;
			oh.allowHMove = false;
			oh.allowVMove = false;
			if (hasBorder) {
				oh.setStyle("borderThickness", 1);
				oh.setStyle("borderStyle", "solid");
			}
			return oh;
		}
	}
}