package testclasses
{
	import mx.collections.HierarchicalData;

	public class TreeHierarchicalData extends HierarchicalData
	{
		public function TreeHierarchicalData(value:Object=null)
		{
			super(value);
		}
		
		public override function getData(node:Object):Object {
			return node.vo;
		}
	}
}