package mindmaps2.elements
{
	import collections.TreeCollectionEx;
	
	import commonutils.ClassInspector;
	
	import vos.Item;
	import vos.Task;
	
	public class ElementFactory
	{
		private const ci:ClassInspector = new ClassInspector();
		
		public function createTask(name:String):TreeCollectionEx {
			var task:Task = new Task();
			task.name = name;
			var res:TreeCollectionEx = new TreeCollectionEx(task);
			return res;
		}
		
		public function createItem(name:String):TreeCollectionEx {
			var item:Item = new Item();
			item.name = name;
			var res:TreeCollectionEx = new TreeCollectionEx(item);
			return res;
		}
		
		public function createFromPrototype(node:TreeCollectionEx, name:String=null):TreeCollectionEx {
			var vo:Object = node.vo;
			if (vo==null) throw new ArgumentError("vo is not set on node");
			var voType:Class = ci.getClass(vo);
			var newVo:Object = new voType();
			if (name!=null)
				newVo.name = name;
			return new TreeCollectionEx(newVo);
		}
		
		public function createOfType(type:Class, name:String=null):TreeCollectionEx {
			var vo:* = new type();
			if (name!=null)
				vo.name = name;
			return new TreeCollectionEx(vo);
		}
	}
}