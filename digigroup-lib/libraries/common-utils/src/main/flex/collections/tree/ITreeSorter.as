package collections.tree
{
	import collections.TreeCollectionEx;
	
	public interface ITreeSorter
	{
		function sort(root:TreeCollectionEx, weightPropertyName:String):TreeCollectionEx;
	}
}