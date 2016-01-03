package mf.framework
{
	import flash.utils.*;
	
	import mf.utils.ClassUtil;
	
	public class AbstractCommandController extends AbstractController
	{
		//public var messageCommandMap:Dictionary = new Dictionary(true);
		public var messageCommandMap:Object = new Object();
		protected var classUtil:ClassUtil = new ClassUtil();
		
		public function AbstractCommandController(modelProvider:IModelProvider, mb:IMessageBroker)
		{
			super(modelProvider, mb);
		}
		
		public override function receive(m:Message):void {
			var commandClass:Class = getCommand(m);
			//var messageClass:Class = classUtil.getClass(m);
			//var commandClass:Class = messageCommandMap[messageClass];
			if (commandClass==null){
				return;
				//throw new Error("unable to find matching command for message "+m.name);
			}
				
			var command:Command = new commandClass();
			var commandContext:CommandContext = new CommandContext(m);
			commandContext.model = this.model;
			//var baseClass:Class = classUtil.getBaseClass(commandClass);
			if (command is MessageMacroCommand){
				var macroCommand:MessageMacroCommand = MessageMacroCommand(command);
				macroCommand.mb = this.mb;
			}
			if (command is AsyncCommand){
				command.context = new AsyncCommandContext(commandContext.message, commandContext.model, null);
			}
			else {
				command.context = commandContext;
			}
			command.execute();
		}
		
		//mapping can be either by name for Message classes
		//or by MessageClass if message class is unique
		protected function getCommand(m:Message):Class {
			var mClass:String;
			if (classUtil.getClass(m)==Message) 
				mClass=m.name;
			else mClass = classUtil.getClassName(m);
			return messageCommandMap[mClass];
		} 
		
		protected function register(messageClass:*, commandClass:Class) : void {
			var messageClassName:String;
			if (messageClass is String)
				messageClassName = messageClass;
			else messageClassName = classUtil.getClassName(messageClass);
			this.messageCommandMap[messageClassName] = commandClass;
		}
	}
}