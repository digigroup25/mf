package mindmaps.inputqueue {
	import mf.framework.Message;
	import mf.framework.MessageBroker;
	import mf.framework.ModelProvider;

	import mindmaps.map.MapModel2;
	import mindmaps.map.MapModel2Factory;

	import mindmaps2.elements.ElementFactory;

	import org.flexunit.asserts.*;

	import vos.Task;

	public class InputQueueControllerTest {
		private static const INPUT_QUEUE_EXISTS:String = "should create \"Inbox\" element";

		private const elements:ElementFactory = new ElementFactory();

		private var c:InputQueueController;

		private var map:MapModel2;

		private var modelProvider:ModelProvider;

		private var mb:MessageBroker = new MessageBroker();

		private const maps:MapModel2Factory = new MapModel2Factory();

		[Before]
		public function setUp():void {
			modelProvider = new ModelProvider(null);
			c = new InputQueueController(modelProvider, mb);
		}

		[Test]
		[Ignore(description = "controller sends a message to another MindMapController add the child")]
		public function test_addToQueue_emptyMap():void {
			map = maps.createEmptyMap("test");
			modelProvider.model = map;

			c.initialize();
			c.send(new Message(InputQueueMessages.ADD_TO_INPUT_QUEUE, null, { name: "abc" }), true);

			//new item
			//	Input Queue
			//		abc

			assertInputQueueWithOneChild(1, 0);
		}

		[Test]
		[Ignore(description = "controller sends a message to another MindMapController add the child")]
		public function test_addToQueue_InputQueue_defaultLocation():void {
			map = maps.createEmptyMap("test");
			map.nodes.addChild(elements.createTask("Inbox"));

			modelProvider.model = map;
			c.initialize();
			c.send(new Message(InputQueueMessages.ADD_TO_INPUT_QUEUE, null, { name: "abc" }), true);

			assertInputQueueWithOneChild(1, 0);
		}

		[Test]
		[Ignore(description = "controller sends a message to another MindMapController add the child")]
		public function test_addToQueue_InputQueue_nonDefaultLocation():void {
			map = maps.createEmptyMap("test");
			map.nodes.addChild(elements.createItem("some item"));
			map.nodes.addChild(elements.createTask("Inbox"));

			modelProvider.model = map;
			c.initialize();
			c.send(new Message(InputQueueMessages.ADD_TO_INPUT_QUEUE, null, { name: "abc" }), true);

			assertInputQueueWithOneChild(2, 1);
		}

		private function assertInputQueueWithOneChild(numChildren:int, queueIndex:int):void {
			assertTrue(INPUT_QUEUE_EXISTS + ": not null", map.nodes.children != null);
			assertEquals(INPUT_QUEUE_EXISTS + ": " + numChildren + " child", numChildren, map.nodes.children.length);
			var newTask:Object = map.nodes.children[queueIndex].getChildAt(0).vo;
			assertTrue("added element is task", newTask is Task);
			assertEquals("added element has correct name", "abc", newTask.name);
		}
	}
}
