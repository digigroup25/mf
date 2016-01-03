package uiengine
{
	import actions.*;
	
	import collections.*;
	import collections.tree.*;
	
	import mf.framework.*;
	
	public class MessageableUserAction extends AbstractUserAction implements IManagedLifecycle
	{
		public var mb:IMessageBroker;
		public var message:Message;
		public var menuGenerator:IMenuGenerator;
		
		public function MessageableUserAction(mb:IMessageBroker, label:String, message:Message=null, 
			menuGenerator:IMenuGenerator=null){
			this.mb = mb;
			this.label = label;
			this.message = message;
			this.menuGenerator = menuGenerator;
		}
		
		protected override function doExecute():void{
			this.mb.send(message);
		}
		
		public override function initialize():void { 
			super.initialize();
			if (menuGenerator!=null){
				menuGenerator.generate(this);
			}
			
			for each (var child:AbstractAction in this.children){
				child.initialize();
			}
		}
		
		public override function uninitialize():void {
			this.mb = null;
			this.label = null;
			this.message = null;
			this.menuGenerator = null;
			
			for each (var child:AbstractAction in this.children){
				child.uninitialize();
			}
			super.uninitialize();
		}
	}
}