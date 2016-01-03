package mf.framework
{
	public class MockContainerDecorator extends ContainerDecorator
	{
		public var initializeCalled:Boolean = false;
		public var uninitializeCalled:Boolean = false;
		public function MockContainerDecorator(container:Container2)
		{
			super(container);
		}
		
		override protected function doInitialize():void {
			initializeCalled = true;
		}
		
		override protected function doUninitialize():void {
			this.uninitializeCalled = true;
		}
		
		override public function toString():String {
			return "MockDecoratedContainer";
		}
	}
}