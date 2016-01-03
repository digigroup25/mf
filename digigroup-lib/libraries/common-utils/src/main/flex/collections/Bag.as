package collections
{
	public class Bag
	{
		public var source:Array = new Array();
		
		public virtual function add(item:*):void
		{
			source.push(item);
		}
		
		public virtual function get():Array
		{
			return source;
		}	
		
		public virtual function remove(item:*):void
		{
			for (var i:int=0; i<source.length; i++)
			{
				if (source[i]==item)
					source.splice(i, 1);
			}
		}	
		
		public virtual function getIndex(item:*):int
		{
			for (var i:int=0; i<source.length; i++)
			{
				if (source[i]==item)
					return i;
			}
			return -1;
		}
		
		public function clear():void
		{
			source = new Array();
		}
		
		public function getItemAt(i:int):*
		{
			return source[i];
		}
		
		public function get length():int
		{
			return source.length;
		}
	}
}