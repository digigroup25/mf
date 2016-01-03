package mf.framework
{


	import actions.AbstractAction;
	import actions.SuccessSyncAction;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;


	public class ActionContainerDecoratorTest
	{
		private var ac:ActionContainerDecorator;
		private var action:AbstractAction;
		private var action2:AbstractAction;
		private var actionAddedEventDispatched:Boolean = false;
		private var model:Object = {};

		[Before]
	 	public function setUp():void {
			action= new SuccessSyncAction();
			action2 = new SuccessSyncAction();
			actionAddedEventDispatched = false;
			ac = new ActionContainerDecorator(new Container2());
		}

		[Test]
		public function test_ctor():void {
			var c:ActionContainerDecorator = new ActionContainerDecorator(new Container2());
			
			assertEquals(0, c.numberOfActionableObjects);	
		}

		[Test]
		 public function test_initialize_allActionsAreInitialized():void {
			ac.setAction(model, action);
			
			ac.initialize();
			
			assertTrue("Container is initialized", ac.initialized);
			assertTrue("Actions are initialized", ac.getAction(model).initialized);			
		}

		[Test]
		public function test_uninitialize_allActionsAreUninitialized():void {
			ac.setAction(model, action);
			ac.initialize();
			
			ac.uninitialize();
			
			assertTrue("Container is uninitialized", ac.uninitialized);
			assertFalse("Actions are uninitialized", ac.getAction(model).initialized);			
		} 

		[Test]
		public function test_setActionForNewActionableObject():void {
			ac.setAction(model, action);
			
			assertTrue(ac.hasAction(model));
			assertEquals(ac.numberOfActionableObjects, 1);
		}

		[Test]
		public function test_setActionForNewActionableObject_eventDispatched():void {
			ac.addEventListener(ActionContainerDecoratorEvent.ACTION_ADDED, onActionAdded);
			
			ac.setAction(model, action);
			
			assertTrue(actionAddedEventDispatched);
		}

		[Test]
		public function test_setActionForExistingActionableObject():void {
			ac.setAction(model, action);
			
			ac.setAction(model, action2);
			
			assertEquals(ac.numberOfActionableObjects, 1);
			assertEquals(action2, ac.getAction(model));
		}

		[Test]
		public function test_deleteAction():void {
			ac.setAction(model, action);
			
			ac.deleteAction(model);
			
			assertEquals(ac.numberOfActionableObjects, 0);
			assertEquals(null, ac.getAction(model));
		}
		
		private function onActionAdded(event:ActionContainerDecoratorEvent):void {
			actionAddedEventDispatched = true;
		}
	}
}