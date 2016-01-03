package collections
{
	import mx.collections.ArrayCollection;
	
	public class ArrayCollectionIterator implements IIterator
	{
		private var col:ArrayCollection;
		private var index:int;
		public function ArrayCollectionIterator(col:ArrayCollection)
		{
			this.col = col;
			index = 0;
		}
		
		public function hasNext():Boolean
		{
			return (index<col.length);
		}
		
		public function next():Object
		{
			index++;
			return col[index-1];
		}
	}
}