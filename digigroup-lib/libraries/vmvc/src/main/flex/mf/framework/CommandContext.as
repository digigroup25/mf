package mf.framework
{
	public class CommandContext
	{
		public var message:Message;
		public var model:Object;
		public function CommandContext(message:Message, model:Object=null)
		{
			this.message 	= message;
			this.model		= model;
		}

	}
}