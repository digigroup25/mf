package testclasses
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import mx.collections.ArrayCollection;
	
	public class DisplayObjectContainerMock extends DisplayObjectContainer
	{
		private var displayObjects:ArrayCollection = new ArrayCollection();
		public function DisplayObjectContainerMock()
		{
			//super();
		}
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			displayObjects.addItem(child);
			return child;
		}
		
		public override function get numChildren():int
		{
			return displayObjects.length;
		}

	}
}