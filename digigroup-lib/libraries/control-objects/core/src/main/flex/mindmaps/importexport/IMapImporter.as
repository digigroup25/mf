package mindmaps.importexport
{
	import collections.TreeCollectionEx;

	public interface IMapImporter
	{
		function importFrom(text:String):TreeCollectionEx;
	}
}