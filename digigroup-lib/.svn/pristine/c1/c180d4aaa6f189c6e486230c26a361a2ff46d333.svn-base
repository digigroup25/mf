package classes
{
	import mx.collections.ArrayCollection;
	import commonutils.ClassInspector;
	
	public class MyNode
	{
		[Bindable]
		public var name:String;
		public var date:Date;
		public var id:int;
		public var children:ArrayCollection=new ArrayCollection();
		
		public function MyNode(name:String=null, date:Date=null, id:int=0)
		{
			this.name = name;
			this.date = date;
			this.id = id;
		}
		
		public function getName():String
		{
			return new ClassInspector().getClassName(this, true);
		}
	}
}