package mf.framework
{
	public class AbstractController implements IMessenger, IManagedLifecycle
	{
		//should be internal mb, not public
		public var mb:IMessageBroker;
		
		protected var modelProvider:IModelProvider;
		public function get model():Object {
			if  (modelProvider==null) return null;
			return modelProvider.model;
		}
		
		public function set model(value:Object):void {
			if (modelProvider==null)
				modelProvider = new ModelProvider(value);
			else
				modelProvider.model = value;
		}
		
		private var _initialized:Boolean = false;
		private var _uninitialized:Boolean = false;
		private var _activated:Boolean = false;
		protected var _messageHandler:Function;
		private var _container:Container2;
		
		public function get initialized():Boolean {
			return _initialized;
		}
		
		public function get uninitialized():Boolean {
			 return _uninitialized;
		}
		
		public function get container():Container2 {
			return _container;
		}
		
		public function AbstractController(modelProvider:IModelProvider=null, mb:IMessageBroker=null, messageHandler:Function=null)
		{
			this.modelProvider = modelProvider;
			
			//create a message broker if none exist
			//if (mb==null) mb=new MessageBroker();
			this.mb	= mb;
			
			this._messageHandler = messageHandler;
		}
		
		public function initialize():void{
			mb.subscribe(this);
			_initialized=true;
			_activated=true;
		}
		
		public function activate():void {
			_activated=true;
		}
		
		public function deactivate():void {
			_activated=false;
		}
		
		public function uninitialize():void{
			mb.unsubscribe(this);
			_initialized=false;
			_uninitialized=true;
			_activated=false;
			_messageHandler=null;
			_container=null;
			mb=null;
			modelProvider=null;
		}
		
		public function send(m:Message, itself:Boolean=false):void{
			mb.send(m, itself);
		}
		
		public function receive(m:Message):void{
			if (_messageHandler==null) {
				return; //throw new Error("abstract method");
			}
			if (_activated==false) 
				return;
			_messageHandler(m);
		}
		
		internal function setContainer(container:Container2):void {
			this._container = container;
		}
	}
}