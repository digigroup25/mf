package mindmaps2.actions
{
	import actions.AbstractAction;
	import actions.AbstractUserAction;
	import actions.ActionStatus;
	import actions.ActionType;
	
	import flexunit.framework.TestCase;
	
	import org.flexunit.asserts.*;
	
	public class UserActionCollectorTest
	{
		private const collector:UserActionCollector = new UserActionCollector();
		
		
		//UA(NS) -> UA
		[Test]
		public function test_UserActionWithoutChildren_returnItself():void {
			var a:AbstractAction = new AbstractUserAction("UA");
			
			var res:Array = collector.getAvailableUserActions(a);
			
			assertEquals(1, res.length);
			assertEquals(a, res[0]);
		}
		
		//UA1 -> UA1
		// --UA2
		[Test]
		public function test_2UserActions_returnTopMostUserAction():void {
			var a1:AbstractAction = new AbstractUserAction("UA1");
			var a2:AbstractAction = new AbstractUserAction("UA2");
			a1.addChild(a2);
			
			var res:Array = collector.getAvailableUserActions(a1);
			
			assertEquals(1, res.length);
			assertEquals(a1, res[0]);
		}
		
		//A1 -> UA2
		// --UA2
		[Test]
		public function test_2Actions_returnUserAction():void {
			var a1:AbstractAction = new AbstractAction("A1");
			var a2:AbstractAction = new AbstractUserAction("UA2");
			a1.addChild(a2);
			
			var res:Array = collector.getAvailableUserActions(a1);
			
			assertEquals(1, res.length);
			assertEquals(a2, res[0]);
		}
		
		//UA1(CI) -> UA2
		// --UA2(NS)
		[Test]
		public function test_UserActionInProgress_returnNextUserAction():void {
			var a1:AbstractAction = new AbstractUserAction("UA1");
			var a2:AbstractAction = new AbstractUserAction("UA2");
			a1.addChild(a2);
			a1.status = ActionStatus.COMPLETING;
			
			var res:Array = collector.getAvailableUserActions(a1);
			
			assertEquals(1, res.length);
			assertEquals(a2, res[0]);
		}
		
		//A1(CI) -> UA2
		// --UA2(NS)
		[Test]
		public function test_ActionInProgress_returnUserAction():void {
			var a1:AbstractAction = new AbstractAction("A1");
			var a2:AbstractAction = new AbstractUserAction("UA2");
			a1.addChild(a2);
			a1.status = ActionStatus.COMPLETING;
			
			var res:Array = collector.getAvailableUserActions(a1);
			
			assertEquals(1, res.length);
			assertEquals(a2, res[0]);
		}
		
		//UA1(CD) -> []
		// --UA2(NS)
		// TODO: 2011/05/22 KTD: Commented out.  Unstable.
//		public function test_ActionComplete_returnNoActions():void {
//			var a1:AbstractAction = new AbstractUserAction("UA1");
//			var a2:AbstractAction = new AbstractUserAction("UA2");
//			a1.addChild(a2);
//			a1.status = ActionStatus.COMPLETED;
//
//			var res:Array = collector.getAvailableUserActions(a1);
//
//			assertEquals(0, res.length);
//		}
		
		//A(NS, SEQ) -> [UA1]
		// --UA1(NS)
		// --UA2(NS)
		[Test]
		public function test_2SequentialUserActions_get1stUserActionOnly():void {
			var a:AbstractAction = new AbstractAction("A");
			var a1:AbstractAction = new AbstractUserAction("UA1");
			var a2:AbstractAction = new AbstractUserAction("UA2");
			a.type = ActionType.SEQUENTIAL;
			a.addChild(a1);
			a.addChild(a2);
			
			var res:Array = collector.getAvailableUserActions(a);
			
			assertEquals(1, res.length);
			assertEquals(a1, res[0]);
		}
		
		//A(NS, PAR) -> [UA1, UA2]
		// --UA1(NS)
		// --UA2(NS)
		[Test]
		public function test_2ParallelUserActions_get2UserActions():void {
			var a:AbstractAction = new AbstractAction("A");
			var a1:AbstractAction = new AbstractUserAction("UA1");
			var a2:AbstractAction = new AbstractUserAction("UA2");
			a.type = ActionType.PARALLEL;
			a.addChild(a1);
			a.addChild(a2);
			
			var res:Array = collector.getAvailableUserActions(a);
			
			assertEquals(2, res.length);
			assertEquals(a1, res[0]);
			assertEquals(a2, res[1]);
		}
		
		//UA1(CD, SEQ, 2) -> [UA1_2]
		// --UA1_1(CD)
		// --UA1_2(NS)
		[Test]
		public function test_repeatableUserAction_getNextAvailable():void {
			var ua1:AbstractAction = new AbstractUserAction("UA1", 2);
			
			//simulate completing this action once
			ua1.initialize();
			ua1.execute();
			
			var res:Array = collector.getAvailableUserActions(ua1);
			
			assertEquals(1, res.length);
			assertTrue(res[0] is AbstractUserAction);
		}
		
		//UA1(CI, SEQ, 2) -> [UA1_1_1, UA1_2]
		// --UA1_1(CI)
		// ----UA1_1_1(NS)
		// --UA1_2(NS)
		[Test]
		public function test_repeatableUserAction_partiallyCompleted():void {
			var ua1:AbstractAction = new AbstractUserAction("UA1", 2);
			var ua1_1:AbstractUserAction = new AbstractUserAction("UA1C");
			ua1.addChild(ua1_1);
			//simulate completing this action once
			ua1.initialize();
			ua1.execute();
			
			var res:Array = collector.getAvailableUserActions(ua1);
			
			assertEquals(2, res.length);
			assertTrue(res[0] is AbstractUserAction);
		}
		
		//A(NS, SEQ) -> [UA2]
		// --UA1(CD)
		// --UA2(NS)
		// --UA3(NS)
		[Test]
		public function test_seq1Completed():void {
			//if 1st child is completed, and actions is seq show 2nd child and the rest
			var a:AbstractAction = new AbstractAction("A");
			var a1:AbstractAction = new AbstractUserAction("UA1");
			var a2:AbstractAction = new AbstractUserAction("UA2");
			var a3:AbstractAction = new AbstractUserAction("UA3");
			a.type = ActionType.SEQUENTIAL;
			a.addChild(a1);
			a.addChild(a2);
			a.addChild(a3);
			a1.forceComplete();
			
			var res:Array = collector.getAvailableUserActions(a);
			
			assertEquals(1, res.length);
			assertEquals(a2, res[0]);
		}
		
		public function test_iteratingOverNull():void {
			var list:Array = null;
			for each (var a:String in list) {
				trace("");
			}
		}
	}
}