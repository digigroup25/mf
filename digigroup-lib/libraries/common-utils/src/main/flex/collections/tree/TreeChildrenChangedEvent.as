package collections.tree
{
	import flash.events.Event;
	
	public class TreeChildrenChangedEvent extends Event
	{
		public function TreeChildrenChangedEvent()
		{
			super(name);
		}
		public static var name:String = "treeChildrenChanged";
	}
}