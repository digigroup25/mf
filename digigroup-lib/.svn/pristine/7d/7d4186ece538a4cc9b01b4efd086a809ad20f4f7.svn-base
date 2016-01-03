package collections.tree
{
	import collections.*;
	
	import mx.collections.ArrayCollection;
	
	public class TreeTypeIterator implements ITreeIterator
	{
		private var nodes:ArrayCollection = new ArrayCollection();
		private var ni:TreeIterator;
		private var type:Class;
		public function TreeTypeIterator(root:TreeComposite, type:Class)
		{
			var temp:ArrayCollection = CollectionConverter.toArray(new CollectionConverterContext(root));
			var context:ArrayCollectionViewerContext = new ArrayCollectionViewerContext(null, false, type);
			nodes = new ArrayCollectionViewer().createView(temp, context);
		}
		
		public function hasNext():Boolean
		{
			return (nodes.length>0);
		}
		
		public function next():Object
		{
			return nodes.removeItemAt(0);
		}
		
		public function peek():*
		{
			return nodes[0];
		}
		
		public function skip():*
		{
			return next();
		}
	}
}