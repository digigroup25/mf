package collections
{
	import mx.collections.ArrayCollection;
	
	public class ArrayCollectionEx extends ArrayCollection implements ICollection
	{
		/*
		public function get current():*
		{
			return null;
		}
		
		public function set current(item:*):void
		{
			
		}
		*/
		public function addCollectionItem (item:*):*
		{
			super.addItem(item);
			return item;
		}
		
		public function removeCollectionItem (item:*):void
		{
			var index:int = this.getItemIndex(item);
			this.removeItemAt(index);
		}
		
		public function ArrayCollectionEx(collection:Array=null)
		{
			if (collection != null)
				super(collection);
		}
		
	}
}