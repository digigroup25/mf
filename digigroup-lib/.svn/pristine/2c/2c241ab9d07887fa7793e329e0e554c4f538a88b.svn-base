package mindmaps.history
{


	import collections.TreeCollectionEx;

	import mf.framework.AbstractController;
	import mf.framework.Container2;
	import mf.framework.MessageLogBroker;

	import mindmaps.map.MapModel2;
	import mindmaps.map.MapModel2Factory;
	import mindmaps.map.NodeLocation;
	import mindmaps.map.messages.NodeMessageFactory;

	import mindmaps2.elements.ElementFactory;
	import mindmaps2.map.controllers.MindMapController;

	import org.flexunit.asserts.*;


	public class HistoryControllerTest
	{
		//1. " " -> "task1"
		//2. " " -> "task1"
		//		 -> "task2"
		//3. " " -> "task1"

		[Test]
		public function test_replay():void
		{
			var mb:MessageLogBroker = new MessageLogBroker();
			var maps:MapModel2Factory = new MapModel2Factory();
			var map:MapModel2 = maps.createEmptyMap("");
			var nodeController:AbstractController = new MindMapController();
			var historyController:HistoryController = new HistoryController();
			var container:Container2 = new Container2(mb, map, [nodeController, historyController]);
			container.initialize();

			var nodeMessages:NodeMessageFactory = new NodeMessageFactory(container);
			var tasks:ElementFactory = new ElementFactory();
			var task1:TreeCollectionEx = tasks.createTask("task1");
			var task2:TreeCollectionEx = tasks.createTask("task2");
			container.send(nodeMessages.AddNode(task1, new NodeLocation(map.nodes, 0)));
			container.send(nodeMessages.AddNode(task2, new NodeLocation(map.nodes, 1)));
			container.send(nodeMessages.RemoveNode(task1, new NodeLocation(map.nodes, 0)));
			assertEquals("3 sent and 3 reply messages", 3 * 2, mb.logSize);

			mb.clearLog();
			var newMap:MapModel2 = maps.createEmptyMap("");
			var historyMessages:HistoryMessagesFactory = new HistoryMessagesFactory(container);
			container.send(historyMessages.ReplayAll(newMap));
			assertEquals("replay generates 3 actions and 3 actions completed and 3 actions replayed messages + 1 original message", 1 + 3 * 3, mb.logSize);
			assertEquals("contains task2 only", "task2", newMap.nodes.children[0].toString());

		}
	}
}