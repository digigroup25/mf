package reflection
{
	import collections.*;
	import collections.tree.ITreeData;
	
	import commonutils.ClassInspector;
	
	import mx.collections.ArrayCollection;
	
	public class VOInspector
	{
		private var ci:ClassInspector = new ClassInspector();
		public function isCollection(vo:*):Boolean
		{
			return ((vo is Array) || (vo is ArrayCollection) || 
				(ci.implementsInterface(ci.getClass(vo), ITreeData)));
		}
	}
}