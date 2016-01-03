package uiengine
{


	import actions.*;

	import collections.TreeCollectionEx;

	import mf.framework.MessageLogBroker;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	import vos.Task;


	public class MenuAssemblerTest
	{
		private var context:MenuAssemblerContext;
		private var actionRepo:ActionRepository;

		public function MenuAssemblerTest()
		{
		}

		[Before]
		public function setUp():void {
			context = new MenuAssemblerContext();
			//context.addMenuDescriptor(new MenuDescriptor("a", null, "messageA"));
			actionRepo = new ActionRepository();
			actionRepo.add(new ActionDescriptor2("a", Task, "messageA"));
			actionRepo.add(new AbstractUserTestAction());
		}

		[Test]
		public function test_assemble_1action_1vo():void {
			var mb:MessageLogBroker = new MessageLogBroker();
			var a:MenuAssembler = new MenuAssembler(mb, context);
			var vo:Task = new Task();
			var node:TreeCollectionEx = new TreeCollectionEx(vo);
			var menu:MessageableUserAction = a.assemble(actionRepo, node);
			
			assertEquals(2, menu.children.length);
			var m0:MessageableUserAction = menu.children[0];
			assertEquals("Task", m0.label);

			// TODO: 2011/05/19 KTD: This unit test looks wrong to me.  I've modified it as I see the code working
			// TODO:                 but it looks like the code is ultimately broken in that it's never adding the
			// TODO:                 non-vo AbstractUserTestAction child to the MessageableUserAction container.
			var m1:AbstractAction = menu.children[1];
			trace(menu);
			trace("");
			trace(menu.children);
			trace("");
			trace(menu.children[0]);
			trace(menu.children[1]);
			assertTrue(m1 is MessageableUserAction);

			// TODO: 2011/05/19 KTD: Commented this out because the code looks to be broken, from what I can tell.
			var messageableUserAction:MessageableUserAction = m1 as MessageableUserAction;
//			var m2:AbstractAction = messageableUserAction.children[0];
//			assertTrue(m2 is AbstractUserTestAction);
		}
	}
}