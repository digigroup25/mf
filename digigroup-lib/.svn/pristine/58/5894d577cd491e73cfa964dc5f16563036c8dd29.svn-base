package mindmaps.importexport
{
	import collections.TreeCollectionEx;
	
	import factories.TreeFactory;
	
	import mindmaps.importexport.task.TaskExporter;
	import mindmaps.map.MapModel2;
	import mindmaps.map.MapModel2Factory;
	
	import mx.utils.StringUtil;
	
	import org.flexunit.asserts.*;
	
	import vos.Item;
	import vos.Task;
	
	public class MapTextExporterTest 
	{
		private const maps:MapModel2Factory = new MapModel2Factory();
		private const trees:TreeFactory = new TreeFactory();
		private const exporter:MapTextExporter = new MapTextExporter();
		
		[Ignore]
		[Test]
		public function test_export_parentChildTree_justNames():void {
			var map:MapModel2 = maps.createMapFrom(trees.createParentChildCollection());
			var res:String = exporter.export(map);
			var exp:String = StringUtil.substitute("{0}\n\t{1}\n", map.nodes.vo, map.nodes.children[0].vo);
			assertEquals(exp, res);
		}
		
		[Ignore]
		[Test]
		public function test_export_parentChildTree():void {
			var map:MapModel2 = maps.createMapFrom(trees.createParentChildCollection());
			var res:String = exporter.export(map);
			var exp:String = StringUtil.substitute("{0}\n\t{1}\n", map.nodes.vo.toLongString(), 
				map.nodes.children[0].vo.toLongString());
			assertEquals(exp, res);
		}
		
		[Ignore]
		[Test]
		public function test_export_priorityTaskTree():void {
			var map:MapModel2 = maps.createMapFrom(trees.createPriorityTaskTree());
			var res:String = exporter.export(map);
			var exp:String = "0\n\t1A\n\t\t\2A\n\t\t2B\n\t1B\n\t\t2C\n";
			assertEquals(exp, res);
		}
		
		[Test]
		public function test_export_itemTaskTree():void {
			var item:Item = new Item();
			item.name = "item";
			var task:Task = new Task().setName("task");
			var tree:TreeCollectionEx = new TreeCollectionEx(item);
			tree.addChild(new TreeCollectionEx(task));
			var map:MapModel2 = maps.createMapFrom(tree);
			
			var res:String = exporter.export(map);
			
			var exp:String = StringUtil.substitute("{0}\n\t{1}\n", map.nodes.vo.toString(), 
				new TaskExporter().export(map.nodes.children.getItemAt(0).vo));
			assertEquals(exp, res);
		}
	}
}