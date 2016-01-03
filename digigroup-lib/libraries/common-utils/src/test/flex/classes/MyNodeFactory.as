package classes
{
	public class MyNodeFactory
	{
		public static function create1Node():MyNode
		{
			var r:MyNode = new MyNode("myname");
			return r;
		}
		
		public static function create1NodeXml():String
		{
			return "<MyNode date=\"null\" id=\"0\" name=\"myname\" />";
		}
		
		public static function createParentChild():MyNode
		{
			var p:MyNode = new MyNode("myParentName");
			var c:MyNode = new MyNode("myChildName");
			p.children.addItem(c);
			return p;
		}
		
		public static function createParentChildXml():String
		{
			return "<MyNode date=\"null\" id=\"0\" name=\"myParentName\" >"+
 				"<MyNode date=\"null\" id=\"0\" name=\"myChildName\" /></MyNode>";
		}
	}
}