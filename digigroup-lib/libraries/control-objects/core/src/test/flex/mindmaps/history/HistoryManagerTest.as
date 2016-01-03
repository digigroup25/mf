package mindmaps.history
{
	import collections.IIterator;
	import collections.TreeCollectionEx;
	
	import mf.framework.Container2;
	import mf.framework.Message;
	import mf.framework.MessageLogBroker;
	
	import mindmaps.map.MapModel2;
	import mindmaps.map.MapModel2Factory;
	import mindmaps.map.NodeLocation;
	import mindmaps.map.messages.NodeMessageFactory;
	import mindmaps.map.messages.NodeMessages;
	
	import mindmaps2.elements.ElementFactory;
	import mindmaps2.map.controllers.MindMapController;
	
	import org.flexunit.asserts.*;

	
	public class HistoryManagerTest 
	{
		private const mb:MessageLogBroker = new MessageLogBroker();
		private var map:MapModel2; 
		private var modelContainer:Container2;
		private var hm:HistoryManager;
		private const elements:ElementFactory = new ElementFactory();
		private const maps:MapModel2Factory = new MapModel2Factory();
		
		[Before]
		public function setUp():void {
			map = maps.createEmptyMap("");
			modelContainer = new Container2(mb, map, [new MindMapController()]);
			
			hm = new HistoryManager();
			hm.initialize();
		}
		
		[Test]
		public function test_log():void {
			var task1:TreeCollectionEx = new ElementFactory().createTask("1");
			var m:Message = new NodeMessageFactory(mb).AddNode(task1, new NodeLocation(map.nodes, 0));
			mb.send(m);
			
			assertEquals("1 message", 1, mb.log.length);
		}
		
		private function saveAddRemoveActions(hm:HistoryManager):void {
			var task1:TreeCollectionEx = new ElementFactory().createTask("1");
			saveAddAction(hm, task1);
			saveRemoveAction(hm, task1);
		}
		
		private function saveAddAction(hm:HistoryManager, node:TreeCollectionEx):void {
			var addNodeMessage:Message = new NodeMessageFactory(mb).AddNode(node, new NodeLocation(map.nodes, 0));
			hm.save(new Action(Operations.ADD_NODE, addNodeMessage.body));
		}
		
		private function saveRemoveAction(hm:HistoryManager, node:TreeCollectionEx):void {
			var removeNodeMessage:Message = new NodeMessageFactory(mb).RemoveNode(node, new NodeLocation(map.nodes, 0));
			hm.save(new Action(Operations.REMOVE_NODE, removeNodeMessage.body));
		}
		
		private function saveMoveAction(hm:HistoryManager, node:TreeCollectionEx, fromNode:TreeCollectionEx,
			fromNodeIndex:int, toNode:TreeCollectionEx, toNodeIndex:int):void {
			var moveNodeMessage:Message = new NodeMessageFactory(mb).MoveNode(node, new NodeLocation(fromNode,
				fromNodeIndex), new NodeLocation(toNode, toNodeIndex));
			hm.save(new Action(Operations.MOVE_NODE, moveNodeMessage.body));	
		}
			
		private function saveUpdateAction(hm:HistoryManager, node:TreeCollectionEx):void {
			//change priority from 1 to 2
			//assume vo is task
			var propertyChain:Object = ["vo", "priority"];
			var oldValue:Object = 1;
			var newValue:Object = 2;
			var updateValueMessage:Message = new Message(NodeMessages.UPDATE_NODE_DATA, mb, 
				{node:node, propertyChain:propertyChain, oldValue:oldValue, newValue:newValue});
			hm.save(new Action(Operations.UPDATE_NODE_DATA, updateValueMessage.body));
		}
		
		private function saveAddUpdateActions(hm:HistoryManager):TreeCollectionEx {
			var task1:TreeCollectionEx = new ElementFactory().createTask("1");
			saveAddAction(hm, task1);
			saveUpdateAction(hm, task1);
			return task1;
		}
		
		[Test]
		public function test_replayActions_addUpdate():void {
			saveAddUpdateActions(hm);
			
			hm.seekStart();
			assertTrue(hm.hasNext());
			var a1:TreeCollectionEx = hm.moveNext();
			assertEquals(Operations.ADD_NODE, a1.vo.operation);
			assertTrue(hm.hasNext());
			
			var a2:TreeCollectionEx = hm.moveNext();
			assertEquals(Operations.UPDATE_NODE_DATA, a2.vo.operation);
			assertEquals("old value", 1, a2.vo.data.oldValue);
			assertEquals("new value", 2, a2.vo.data.newValue);
			assertFalse(hm.hasNext());
		}
		
		[Test]
		public function test_replayActions_addRemove():void {
			saveAddRemoveActions(hm);
			
			hm.seekStart();
			assertTrue(hm.hasNext());
			var a1:TreeCollectionEx = hm.moveNext();
			assertEquals(Operations.ADD_NODE, a1.vo.operation);
			assertTrue(hm.hasNext());
			
			var a2:TreeCollectionEx = hm.moveNext();
			assertEquals(Operations.REMOVE_NODE, a2.vo.operation);
			assertFalse(hm.hasNext());
		}
		
		[Test]
		public function test_replayActions_move():void {
			var node1:TreeCollectionEx = elements.createTask("1");
			var node2:TreeCollectionEx = elements.createTask("2");
			map.nodes.addChild(node1);
			map.nodes.addChild(node2);
			
			saveMoveAction(hm, node2, map.nodes, 1, node1, 0);
			
			hm.seekStart();
			assertTrue(hm.hasNext());
			var a1:TreeCollectionEx = hm.moveNext();
			var actionIterator:IIterator = a1.createIterator(Action);
			var removeAction:TreeCollectionEx = TreeCollectionEx(actionIterator.next());
			assertEquals(Operations.REMOVE_NODE, removeAction.vo.operation);
			assertTrue(actionIterator.hasNext());
			
			var addAction:TreeCollectionEx = TreeCollectionEx(actionIterator.next());
			assertEquals(Operations.ADD_NODE, addAction.vo.operation);
			assertFalse(actionIterator.hasNext());
			assertFalse(hm.hasNext());
			 
		}
		
		[Test]
		public function test_unplayActions_addRemove():void {
			saveAddRemoveActions(hm);
			
			hm.seekEnd();
			hm.reverse = true;
			assertTrue(hm.hasNext());
			var a1:TreeCollectionEx = hm.moveNext();
			assertEquals("Complement of REMOVE is ADD", Operations.ADD_NODE, a1.vo.operation);
			assertTrue(hm.hasNext());
			
			var a2:TreeCollectionEx = hm.moveNext();
			assertEquals("Complement of ADD is REMOVE", Operations.REMOVE_NODE, a2.vo.operation);
			assertFalse(hm.hasNext());
		}
		
		[Test]
		public function test_unplayActions_addUpdate():void {
			saveAddUpdateActions(hm);
			
			hm.seekEnd();
			hm.reverse = true;
			assertTrue(hm.hasNext());
			var a1:TreeCollectionEx = hm.moveNext();
			assertEquals("Complement of UPDATE is UPDATE", Operations.UPDATE_NODE_DATA, a1.vo.operation);
			assertEquals("new value is now equal to old value", 1, a1.vo.data.newValue);
			assertEquals("old value is now equal to new value", 2, a1.vo.data.oldValue);
			assertTrue(hm.hasNext());
			
			var a2:TreeCollectionEx = hm.moveNext();
			assertEquals("Complement of ADD is REMOVE", Operations.REMOVE_NODE, a2.vo.operation);
			assertFalse(hm.hasNext());
		}
		
		[Test]
		public function test_propertyChain():void {
			var simpleObj:Object = {val:1};
			var complexObj:Object = {simpleObj:simpleObj};
			var val:* = complexObj;
			for each (var prop:String in ["simpleObj", "val"]) {
				val = val[prop];
			}
			assertEquals(1, val);
		}
	}
}