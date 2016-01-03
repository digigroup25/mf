package mf.framework
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	
	public class Container2 extends EventDispatcher implements IContainer
	{
		protected var modelProvider:IModelProvider;
		protected var _initialized:Boolean=false;
		protected var _uninitialized:Boolean=false;
		
		private var _mb:IMessageBroker;
		private var _controllers:Array;
		private var _containers:Array;
		public var messageHandler:Function;
		private var _name:String;
		
		public function get mb():IMessageBroker {
			return _mb;
		} 
		
		public function set mb(value:IMessageBroker):void {
			_mb = value;
		}
		
		public function get controllers():Array {
			return _controllers;
		}
		
		public function set controllers(value:Array):void {
			_controllers = value;
		}
		
		public function get containers():Array {
			return _containers;
		}
		
		public function set containers(value:Array):void {
			_containers = value;
		}
		
		public function get initialized():Boolean {
			return _initialized;
		}
		
		public function get uninitialized():Boolean {
			return _uninitialized;
		}
		
		public function get model():Object {
			return modelProvider.model;
		}
		
		public function set model(value:Object):void {
			modelProvider.model = value;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			if (initialized)
				throw new IllegalOperationError("Cannot set property name after container has been initialized");
			this._name = value;
		}
		
		public function Container2(mb:IMessageBroker=null, model:Object=null, controllers:Array=null,
			messageHandler:Function=null, containers:Array=null)
		{
			if (mb==null)
				mb=FrameworkFactory.createMessageBroker();
			this.mb = mb;
			
			this.modelProvider = new ModelProvider(model);
			
			if (controllers==null)
				controllers = [];
			this.controllers = controllers;
			
			this.messageHandler = messageHandler;
			if (containers==null) containers=[];
			this.containers = containers;
		}
		
		public function getContainerByName(name:String):Container2 {
			for each (var child:Container2 in containers) {
				if (child.name==name)
					return child;
			}
			return null;
		}
		
		public function setContainerByName(name:String, container:Container2):void {
			var existingContainer:Container2 = this.getContainerByName(name);
			if (existingContainer) {
				var existingContainerIndex:int = this.containers.indexOf(existingContainer);
				this.containers[existingContainerIndex] = container;
			}
			else {
				this.containers.push(container);
			}
		}
		
		public function addContainer(container:Container2):void {
			if (containers.indexOf(container)!=-1)
				return;
				
			containers.push(container);
			if (initialized) {
				container.initialize();
				if (!this.mb.hasSubscriber(container)) {
					this.mb.connect(container.mb, true, true);
				}
			}
		}
		
		public function removeContainer(container:Container2):void {
			var containerIndex:int = containers.indexOf(container);
			if (containerIndex==-1)
				return;
			containers.splice(containerIndex, 1);
			
			/* if (!this.mb.hasSubscriber(container)) {
				this.mb.disconnect(container.mb);
			} */
		}
		
		public function initialize():void {
			if (initialized) return; //calling initialize several times, should only execute the 1st one
			
			doInitialize();
			
			_initialized=true;
		}
		
		protected function doInitialize():void {
			this.mb.subscribe(this);
			
			//initialize children containers if any
			for each (var container:Container2 in containers) {
				container.initialize();
			}
			
			//initialize controllers
			for each (var controller:AbstractController in controllers) {
				//inject mb and model unless they have been set
				if (controller.mb==null) 
					controller.mb = this.mb;
				if (controller.model==null) 
					controller.model = this.model;
				controller.setContainer(this);
				//initialize
				controller.initialize();
			}
		}
		
		public function uninitialize():void {
			if (uninitialized) return;
			
			doUninitialize();
			
			_uninitialized=true;
		}
		
		protected function doUninitialize():void {
			//uninitialize controllers first
			for each (var controller:IManagedLifecycle in controllers) {
				controller.uninitialize();
			}
			
			//uninitialize children containers if any
			for each (var container:Container2 in containers) {
				container.uninitialize();
			}
			
			this.mb.unsubscribe(this);
		}
		
		public function send(m:Message, itself:Boolean=false):void {
			this.mb.send(m, itself);
		}
		
		public function receive(m:Message):void {
			doReceive(m);
		}
		
		protected function doReceive(m:Message):void {
			if (messageHandler!=null)
				messageHandler(m);
		}
		
		public function addController(controller:AbstractController):void {
			this.controllers.push(controller);
			if (initialized) controller.initialize(); //if container already initialized, initialize controller immediately
		}
		
		public function removeController(controller:AbstractController):void {
			var index:int = this.controllers.indexOf(controller);
			if (index<0) return;
			controllers.splice(index, 1);
			if (initialized) 
				controller.uninitialize();
		}
		
		public function getDescendantContainers():Array {
			var res:Array = [];
			res = res.concat(this.containers);
			for each (var childContainer:Container2 in this.containers) {
				res = res.concat(childContainer.getDescendantContainers());
			}
			return res;
		}
		
		override public function toString():String {
			if (this.name)
				return name;
			else return typeof this;//return super.toString();
		}
	}
}