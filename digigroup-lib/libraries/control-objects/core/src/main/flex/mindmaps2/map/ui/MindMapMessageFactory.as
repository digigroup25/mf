package mindmaps2.map.ui
{
	import collections.TreeCollectionEx;
	
	import mf.framework.Message;
	
	import mindmaps.map.MapFormat;
	import mindmaps.map.MapModel2;
	
	public class MindMapMessageFactory
	{
		private var sender:Object;
		
		public function MindMapMessageFactory(sender:Object)
		{
			this.sender = sender;
		}
		
		public function Imported(node:TreeCollectionEx):Message {
			return new Message(MindMapMessages.IMPORTED_MAP, sender, {node:node});
		}
		
		public function Export(map:MapModel2, format:String):Message {
			var messageType:String;
			switch (format) {
				case MapFormat.XML:
					messageType = MindMapMessages.EXPORT_MAP_TO_XML;
					break;
				case MapFormat.TEXT:
					messageType = MindMapMessages.EXPORT_MAP_TO_TEXT;
					break;
				default:
					throw new ArgumentError("Unknown map format: " + format);
					break;
			}
			return new Message(messageType, sender, {map:map});
		}
		
		public function Import(map:MapModel2, format:String):Message {
			var messageType:String;
			switch (format) {
				case MapFormat.XML:
					messageType = MindMapMessages.IMPORT_MAP;
					break;
				default:
					throw new ArgumentError("Unknown map format: " + format);
					break;
			}
			return new Message(messageType, sender, {map:map});
		}
		
		public function CloseMap(map:MapModel2):Message {
			return new Message(MindMapMessages.CLOSE_MAP, sender, {map:map});
		}
	}
}