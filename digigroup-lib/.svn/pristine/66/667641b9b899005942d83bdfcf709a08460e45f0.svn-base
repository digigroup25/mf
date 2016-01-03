package mf.framework
{
	public class ContainerDecorator extends Container2
	{
		private var container:Container2;
		
		
		
		override public function get mb():IMessageBroker {
			return container.mb;
		}
		
		override public function set mb(value:IMessageBroker):void {
			container.mb = value;
		}
		
		override public function get controllers():Array {
			return container.controllers;
		}
		
		override public function set controllers(value:Array):void {
			container.controllers = value;
		}
		
		override public function get containers():Array {
			return container.containers;
		}
		
		override public function set containers(value:Array):void {
			container.containers = value;
		}
		
		override public function get initialized():Boolean {
			return container.initialized;
		}
		
		override public function get uninitialized():Boolean {
			return container.uninitialized;
		}
		
		override public function get model():Object {
			return container.model;
		}
		
		override public function set model(value:Object):void {
			container.model = value;
		}
		
		override public function get name():String {
			return container.name;
		}
		
		override public function set name(value:String):void {
			container.name = value;
		}
		
		public function ContainerDecorator(container:Container2)
		{
			this.container = container;
			super(container.mb, container.model, container.controllers, container.messageHandler, 
				container.containers); //since it overrides all methods, set container first
		}
		
		override public function getContainerByName(name:String):Container2 {
			return this.container.getContainerByName(name);
		}
		
		override public function setContainerByName(name:String, container:Container2):void {
			this.container.setContainerByName(name, container);
		}
		
		override public function addContainer(container:Container2):void {
			this.container.addContainer(container);
		}
		
		override public function removeContainer(container:Container2):void {
			this.container.removeContainer(container);
		}
		
		//explicit override so that sublclasses overriding this method
		//did not call doInitialize on Container2 which causes
		//add container twice to the list of subscribers (decorator and container)
		override protected function doInitialize():void {
			
		}
		
		override protected function doUninitialize():void {
			
		}
		
		override public function initialize():void {
			if (this.container.initialized) return;
			
			this.doInitialize();
			this.container.initialize();
		}
		
		override public function uninitialize():void {
			if (this.container.uninitialized) return;
			
			this.container.uninitialize();
			this.doUninitialize();			
		}
		
		override public function send(m:Message, itself:Boolean=false):void {
			this.container.send(m, itself);
		}
		
		override public function receive(m:Message):void {
			this.container.receive(m);
		}
		
		override public function addController(controller:AbstractController):void {
			this.container.addController(controller);
		}
		
		override public function removeController(controller:AbstractController):void {
			this.container.removeController(controller);
		}
		
		override public function getDescendantContainers():Array {
			return this.container.getDescendantContainers();
		}
		
		override public function toString():String {
			return this.container.toString();
		}
	}
}