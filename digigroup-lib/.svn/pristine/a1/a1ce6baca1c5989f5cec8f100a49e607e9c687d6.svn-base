package mindmaps.history
{
	import mindmaps.map.messages.NodeMessages;
	
	public class Operations
	{
		public function Operations()
		{
		}
		
		private static var operations:Object = new Object();
		
		public static function getOperation(name:String):Operation {
			if (operations[name]==undefined)
				operations[name] = new Operation(name);
			return operations[name];
		}
		
		public static function get ADD_NODE():Operation {
			return getOperation(NodeMessages.ADD_NODE);
		}
		
		public static function get REMOVE_NODE():Operation {
			return getOperation(NodeMessages.REMOVE_NODE);
		}
		
		public static function get UPDATE_NODE_DATA():Operation {
			return getOperation(NodeMessages.UPDATE_NODE_DATA);
		}
		
		public static function get MOVE_NODE():Operation {
			return getOperation(NodeMessages.MOVE_NODE);
		}
	}
}