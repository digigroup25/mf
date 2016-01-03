package mf.framework
{
	import mx.core.ClassFactory;
	import mx.rpc.AsyncResponder;
	
	internal class FrameworkFactory
	{
		public static var messageBrokerType:Class = MessageBroker;
		
		public static function createMessageBroker():MessageBroker
		{
			var factory:ClassFactory = new ClassFactory(messageBrokerType);
			var res:MessageBroker = MessageBroker(factory.newInstance());
			return res;
		}
		
		public static function createAsyncCommand(commandClass:Class, context:CommandContext,
			responder:AsyncResponder) : AsyncCommand {
			var command:AsyncCommand = AsyncCommand(new commandClass());
			command.context = new AsyncCommandContext(context.message, context.model,
				responder);
			return command;	
		}
		
		public static function createCommand(commandClass:Class, context:CommandContext) : Command {
			var command:Command = Command(new commandClass());
			command.context = new CommandContext(context.message, context.model);
			return command;	
		}
	}
}