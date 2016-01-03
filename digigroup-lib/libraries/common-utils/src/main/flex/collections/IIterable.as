package collections
{
	import collections.IIterator;
	
	public interface IIterable
	{
		function createIterator(type:Class=null):IIterator;
	}
}