package mf.framework
{
	public class Message
	{
		private static const active:uint = 1 << 0;
		private static const suspended:uint = 1 << 1;
		private static const destroyed:uint = 1 << 2;
		
		public var name:String;
		public var sender:Object;
		public var body:Object;
		public var isForwarded:Boolean = false;
		private var status:uint = active;
		
		public function isActive():Boolean {
			return (status & active) == active;
		}
		public function isDestroyed():Boolean {
			return (status & destroyed) == destroyed;
		}
		
		public function Message(name:String, sender:Object, body:Object=null)
		{
			this.name = name;
			this.sender = sender;
			this.body = body;
		}
		
		public function destroy():void {
			status = destroyed;
		}
		
		public function toString():String
		{
			return this.name + "\t " + sender;
		}
		
		public function clone():Message {
			return new Message(this.name, this.sender, this.body);
		}
	}
}