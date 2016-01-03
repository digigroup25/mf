package mf.framework
{
	import flash.display.DisplayObject;
	
	import org.flexunit.asserts.*;
	
	import mx.controls.Label;
	
	public class ContainerDecoratorTest
	{
		public function ContainerDecoratorTest()
		{
		}

		[Test]
		public function testViewContainer():void {
			var c:Container2 = new Container2();
			var v:ViewContainerDecorator = new ViewContainerDecorator(c, null);
			var type:String = v.toString();
			
			assertEquals("ViewContainerDecorator", type);
		}
		
		[Test]
		public function test_containerDecoration():void {
			var c:Container2 = new Container2();
			var displayObject:DisplayObject = new Label();
			var v:ViewContainerDecorator = new ViewContainerDecorator(c, displayObject);
			var containerDecorator:MockContainerDecorator = new MockContainerDecorator(v);
			var childContainer:Container2 = new Container2();
			containerDecorator.addContainer(childContainer);
			
			var type:String = containerDecorator.toString();
			assertEquals("MockDecoratedContainer", type);
			assertEquals(1, containerDecorator.getDescendantContainers().length);
		}
		
		[Test]
		public function test_initializeMethodIsCalledInDecoratorSubClass():void {
			var c:MockContainerDecorator = new MockContainerDecorator(new Container2());
			
			c.initialize();
			
			assertTrue(c.initializeCalled);
		}
		
		[Test]
		public function test_uninitializeMethodIsCalledInDecoratorSubClass():void {
			var c:MockContainerDecorator = new MockContainerDecorator(new Container2());
			c.initialize();

			c.uninitialize();
			
			assertTrue(c.uninitializeCalled);
		}
		
		[Test]
		public function test_eachContainerDecoratorShouldReceiveMessageIfHasMessageHandler():void {
			var c:MockContainerDecorator = new MockContainerDecorator(new Container2());
			c.initialize();
		}
	}
}