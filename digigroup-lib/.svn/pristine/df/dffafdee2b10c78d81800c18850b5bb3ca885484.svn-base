package mindmaps2.actions.element {
	import actions.AbstractAction;
	import actions.AbstractIOAction;
	import actions.AbstractUserAction;
	import actions.ActionStatus;

	import collections.IIterator;
	import collections.TreeCollectionEx;

	import mf.framework.Container2;

	import mindmaps2.actions.Actions;
	import mindmaps2.actions.task.PrioritizeByRatingAction;
	import mindmaps2.elements.ElementFactory;

	import org.flexunit.asserts.*;

	public class SelectAndActOnElementTest {
		private var a:SelectAndActOnElement;

		[Before]
		public function setUp():void {
			a = new SelectAndActOnElement("", 3);
		}

		[Test]
		public function test_initialExecution():void {
			a.initialize();

			a.execute();

			assertEquals("action status is completing", a.status, ActionStatus.COMPLETING);
			var selectElement:AbstractAction = a.getAvailableActionsByName(Actions.SELECT_ELEMENT)[0];
			assertEquals("select action is not executed", selectElement.status, ActionStatus.NOT_STARTED);
		}

		[Test]
		public function _test_executeSelectActionWithoutInputParams():void {
			a.initialize();
			a.execute();

			var selectElement:AbstractUserAction = a.getAvailableActionsByName(Actions.SELECT_ELEMENT)[0];
			try {
				selectElement.userExecute();
				fail();
			} catch (e:Error) {
			}
		}

		[Test]
		public function test_executeSelectActionOnTask():void {
			executeSelectAction();

			var it:IIterator = a.createIterator(ActOnElementOrUnselect);
			assertTrue(it.hasNext());

			var elementActions:AbstractIOAction = AbstractIOAction(it.next());
			var availableTaskActions:Array = elementActions.getAvailableActions();
			assertEquals(1 + CreateElementActions.commonElementActions.length + CreateElementActions.taskActions.length,
				availableTaskActions.length);
		}

		//execute actionOnTask, ensure the chain is complete and new actions are available
		//execute unselect, ditto

		[Test]
		public function test_executeActionOnTask_completesAction():void {
			executeSelectAction();

			var it:IIterator = a.createIterator(ActOnElementOrUnselect);
			assertTrue(it.hasNext());

			var elementActions:AbstractIOAction = AbstractIOAction(it.next());
			var availableTaskActions:Array = elementActions.getAvailableActions();
			var prioritizeAction:AbstractUserAction = elementActions.getAvailableActions(PrioritizeByRatingAction)[0];

			assertTrue(prioritizeAction.hasInput());

			prioritizeAction.userExecute();

			assertEquals(ActionStatus.COMPLETED, prioritizeAction.status);
			assertEquals(ActionStatus.COMPLETED, a.status);
			assertEquals(ActionStatus.COMPLETED, a.children[0].status);
		}

		[Test]
		public function test_executeActionOnTask_newActionsAvailable():void {
			executeSelectAction();

			var it:IIterator = a.createIterator(ActOnElementOrUnselect);
			assertTrue(it.hasNext());

			var elementActions:AbstractIOAction = AbstractIOAction(it.next());
			var availableTaskActions:Array = elementActions.getAvailableActions();
			var prioritizeAction:AbstractUserAction = elementActions.getAvailableActions(PrioritizeByRatingAction)[0];

			prioritizeAction.userExecute();

			var selectAndActOnElement:AbstractAction = a.children[1];
			assertEquals(ActionStatus.COMPLETING, selectAndActOnElement.status);

			availableTaskActions = selectAndActOnElement.getAvailableActions();
		}

		[Test]
		public function test_executeUnselect_newActionsAvailable():void {
			executeSelectAction();

			var it:IIterator = a.createIterator(ActOnElementOrUnselect);
			assertTrue(it.hasNext());

			var elementActions:AbstractIOAction = AbstractIOAction(it.next());
			var availableTaskActions:Array = elementActions.getAvailableActions();
			var unselectAction:AbstractAction = elementActions.getAvailableActionsByName(Actions.UNSELECT_ELEMENT)[0];

			unselectAction.execute();

			var selectAndActOnElement:AbstractAction = a.children[1];
			assertEquals(ActionStatus.COMPLETING, selectAndActOnElement.status);

			availableTaskActions = selectAndActOnElement.getAvailableActions();
		}

		private function executeSelectAction():Object {
			var res:Object = {};
			a.input.mapContainer = new Container2();
			a.initialize();
			a.execute();

			var selectElement:AbstractUserAction = a.getAvailableActionsByName(Actions.SELECT_ELEMENT)[0];
			var taskNode:TreeCollectionEx = new ElementFactory().createTask("task");
			selectElement.input.node = taskNode;

			selectElement.userExecute();

			return res;
		}
	}
}
