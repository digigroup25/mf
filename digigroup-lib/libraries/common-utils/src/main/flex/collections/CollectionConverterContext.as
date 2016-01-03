package collections
{
	import collections.tree.TreeComposite;
	
	public class CollectionConverterContext
	{
		public var root:TreeComposite;
		public var iterator:IIterator;
		public var addPath:Boolean;
		
		public function CollectionConverterContext(root:TreeComposite, 
			iterator:IIterator=null, addPath:Boolean=false)
			{
				this.root = root;
				this.iterator = iterator;
				this.addPath = addPath;
			}
	}
}