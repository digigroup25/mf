package actions
{
	public class TestActionFactory
	{
		protected const factory:ActionFactory = new ActionFactory();
		protected const tester:ActionChecker = new ActionChecker();


		private function successAction(sync:Boolean, success:Boolean):Object
		{
			var a:AbstractAction;
			if (sync)
			{
				if (success)
				{
					a = new SuccessSyncAction();
				}
				else
				{
					a = new FailSyncAction();
				}
			}
			else
			if (success)
			{
				a = new SuccessAsyncAction();
			}
			else
			{
				a = new FailAsyncAction();
			}

			var res:Object = {result:a, accessors:{a0:a}, validate:success ?
																   validate_singleSuccessAction : validate_singleFailAction};
			return res;
		}


		public function syncSuccessAction():Object
		{
			return successAction(true, true);
		}


		public function asyncSuccessAction():Object
		{
			return successAction(false, true);
		}


		private function validate_singleSuccessAction(factoryObject:Object, eventQueue:Array = null):void
		{
			tester.assertStatuses(factoryObject, [
				"a0,CD"
			]);

			tester.assertEvents(factoryObject, eventQueue, [
				"a0,CI",
				"a0,CD"]);
		}


		public function syncFailAction():Object
		{
			return successAction(true, false);
		}


		public function asyncFailAction():Object
		{
			return successAction(false, false);
		}


		private function validate_singleFailAction(factoryObject:Object, eventQueue:Array = null):void
		{
			tester.assertStatuses(factoryObject, [
				"a0,FD"
			]);

			tester.assertEvents(factoryObject, eventQueue, [
				"a0,CI",
				"a0,FI",
				"a0,FD"]);
		}


		//a0(NS, AND, SEQ)
		//--a10(NS, SUC, SYNC)
		//--a11(NS, SUC, ASYNC)
		public function seqAND_2children():Object
		{
			var a10:AbstractAction = new SuccessSyncAction("a10");
			var a11:AbstractAction = new SuccessAsyncAction("a11");
			var a:AbstractAction = factory.sequentialAND("complete_2Children", [a10, a11]);
			var res:Object = {result:a, accessors:{a0:a, a10:a10, a11:a11}, validate:validate_seqAND_2children};
			return res;
		}


		private function validate_seqAND_2children(factoryObject:Object, eventQueue:Array = null):void
		{
			tester.assertStatuses(factoryObject, [
				"a0,CD",
				"a10,CD",
				"a11,CD"
			]);

			tester.assertEvents(factoryObject, eventQueue, [
				"a0,CI",
				"a10,CI",
				"a10,CD",
				"a11,CI",
				"a11,CD",
				"a0,CD"]);
		}


		//a(NS, AND, SEQ)
		//--a10(NS, SUC, SYNC)
		//--a11(NS, FAI, ASYNC)
		public function seqAND_2children_2ndFail():Object
		{
			var a10:AbstractAction = new SuccessSyncAction();
			var a11:AbstractAction = new FailAsyncAction();
			var a:AbstractAction = factory.sequentialAND("fail_2Children", [a10, a11]);
			var res:Object = {result:a, accessors:{a0:a, a10:a10, a11:a11}, validate:validate_seqAND_2children_2ndFail};
			return res;
		}


		private function validate_seqAND_2children_2ndFail(factoryObject:Object, eventQueue:Array = null):void
		{
			tester.assertStatuses(factoryObject, [
				"a0,FD",
				"a10,FD",
				"a11,FD"
			]);

			tester.assertEvents(factoryObject, eventQueue, [
				"a0,CI",
				"a10,CI",
				"a10,CD",
				"a11,CI",
				"a11,FI",
				"a0,FI",
				"a10,FI",
				"a10,FD",

				"a0,FD",
				"a11,FD"
			]);
		}


		//a(NS, OR, SEQ)
		//--a10(NS, SUC, ASYNC)
		//--a11(NS, SUC, ASYNC)
		public function seqOR_2children():Object
		{
			var a10:AbstractAction = new SuccessAsyncAction();
			var a11:AbstractAction = new SuccessAsyncAction();
			var a:AbstractAction = factory.sequentialOR("seqOR_2children", [a10, a11]);
			var res:Object = {result:a, accessors:{a0:a, a10:a10, a11:a11}, validate:validate_seqOR_2Children};
			return res;
		}


		private function validate_seqOR_2Children(factoryObject:Object, eventQueue:Array = null):void
		{
			tester.assertStatuses(factoryObject, [
				"a0,CD",
				"a10,CD",
				"a11,NS"
			]);
		}


		public function seqOR_2children_keepExecutingOrActions():Object
		{
			var res:Object = seqOR_2children();
			res.result.keepExecutingOrActions = true;
			res.validate = validate_seqOR_2Children_keepExecutingOrActions;
			return res;
		}


		private function validate_seqOR_2Children_keepExecutingOrActions(factoryObject:Object,
																		 eventQueue:Array = null):void
		{
			tester.assertStatuses(factoryObject, [
				"a0,CD",
				"a10,CD",
				"a11,CD"
			]);
		}


		//a(NS, OR, SEQ)
		//--a10(NS, FAI, ASYNC)
		//--a11(NS, SUC, ASYNC)
		public function seqOR_2children_1stFail():Object
		{
			var a10:AbstractAction = new FailAsyncAction();
			var a11:AbstractAction = new SuccessAsyncAction();
			var a:AbstractAction = factory.sequentialOR("seqOR_2children_1stFail", [a10, a11]);
			var res:Object = {result:a, accessors:{a0:a, a10:a10, a11:a11}, validate:validate_seqOR_2Children_1stFail};
			return res;
		}


		private function validate_seqOR_2Children_1stFail(factoryObject:Object, eventQueue:Array = null):void
		{
			tester.assertStatuses(factoryObject, [
				"a0,CD",
				"a10,FD",
				"a11,CD"
			]);

			tester.assertEvents(factoryObject, eventQueue, [
				"a0,CI",
				"a10,CI",
				"a10,FI", //failing causes execution of next action, not failed 
				"a11,CI",
				"a10,FD",
				"a11,CD",
				"a0,CD"
			]);
		}


		public function parOR_2children():Object
		{
			var a10:AbstractAction = new FailAsyncAction("a10", 60);
			var a11:AbstractAction = new SuccessAsyncAction("a11", 100);
			var a:AbstractAction = factory.parallelOR("parOR_2children", [a10, a11]);
			var res:Object = {result:a, accessors:{a0:a, a10:a10, a11:a11}, validate:validate_parOR_2Children};
			return res;
		}


		private function validate_parOR_2Children(factoryObject:Object, eventQueue:Array = null):void
		{
			tester.assertStatuses(factoryObject, [
				"a0,CD",
				"a10,FD",
				"a11,CD"
			]);

			tester.assertEvents(factoryObject, eventQueue, [
				"a0,CI",
				"a10,CI",
				"a11,CI",
				"a10,FI",
				"a10,FD",
				"a11,CD",
				"a0,CD"
			]);
		}


		/**
		 *				 a0(SEQ)
		 *		 a10(SEQ)		a11
		 * a20		a21
		 **/
		public function seqAND_3levels():Object
		{
			var a10:AbstractAction = factory.sequentialAND("a10", [new SuccessAsyncAction("a20"),
																   new FailAsyncAction("a21")]);
			var a11:AbstractAction = new SuccessSyncAction("a11");
			var a:AbstractAction = factory.sequentialAND("fail_3levels", [a10, a11]);
			var res:Object = {result:a, accessors:{a0:a, a10:a10, a11:a11, a20:a10.children[0], a21:a10.children[1]},
				validate:validate_seqAND_3levels};
			return res;
		}


		private function validate_seqAND_3levels(factoryObject:Object, eventQueue:Array = null):void
		{
			tester.assertStatuses(factoryObject, [
				"a0,FD",
				"a10,FD",
				"a11,NS",
				"a20,FD",
				"a21,FD"
			]);

			tester.assertEvents(factoryObject, eventQueue, [
				"a0,CI",
				"a10,CI",
				"a20,CI",
				"a20,CD",
				"a21,CI",
				"a21,FI",
				"a10,FI",
				"a0,FI",
				"a20,FI",
				"a20,FD",
				"a10,FD",
				"a0,FD",
				"a21,FD"
			]);
		}


		public function parAND_3levels():Object
		{
			var res:Object = seqAND_3levels();
			res.accessors.a0.type = ActionType.PARALLEL;
			res.accessors.a10.type = ActionType.PARALLEL;
			res.validate = validate_parAND_3levels;
			return res;
		}


		private function validate_parAND_3levels(factoryObject:Object, eventQueue:Array = null):void
		{
			tester.assertStatuses(factoryObject, [
				"a0,FD",
				"a10,FD",
				"a11,FD",
				"a20,FD",
				"a21,FD"
			]);

			tester.assertEvents(factoryObject, eventQueue, [
				"a0,CI",
				"a10,CI",
				"a20,CI",
				"a21,CI",
				"a11,CI",
				"a11,CD",
				"a20,CD",
				"a21,FI",
				"a10,FI",
				"a0,FI",
				"a11,FI",
				"a11,FD",
				"a0,FD",
				"a20,FI",
				"a20,FD",
				"a10,FD",
				"a21,FD"

			]);
		}


		public function seqOR_3levels():Object
		{
			var a10:AbstractAction = factory.sequentialOR("a10", [new FailAsyncAction("a20"),
																  new SuccessAsyncAction("a21")]);
			var a11:AbstractAction = new SuccessSyncAction("a11");
			var a:AbstractAction = factory.sequentialOR("fail_3levels", [a10, a11]);
			var res:Object = {result:a, accessors:{a0:a, a10:a10, a11:a11, a20:a10.children[0], a21:a10.children[1]},
				validate:validate_seqOR_3levels};
			return res;
		}


		private function validate_seqOR_3levels(factoryObject:Object, eventQueue:Array = null):void
		{
			tester.assertStatuses(factoryObject, [
				"a0,CD",
				"a10,CD",
				"a11,NS",
				"a20,FD",
				"a21,CD"
			]);

			tester.assertEvents(factoryObject, eventQueue, [
				"a0,CI",
				"a10,CI",
				"a20,CI",
				"a20,FI",
				"a21,CI",
				"a20,FD",
				"a21,CD",
				"a10,CD",
				"a0,CD"
			]);
		}


		public function parOR_3levels():Object
		{
			var a10:AbstractAction = factory.parallelOR("a10", [new FailAsyncAction("a20", 60),
																new SuccessAsyncAction("a21", 180)]);
			var a11:AbstractAction = new FailAsyncAction("a11", 100);
			var a:AbstractAction = factory.parallelOR("fail_3levels", [a10, a11]);
			var res:Object = {result:a, accessors:{a0:a, a10:a10, a11:a11, a20:a10.children[0], a21:a10.children[1]},
				validate:validate_parOR_3levels};
			return res;
		}


		private function validate_parOR_3levels(factoryObject:Object, eventQueue:Array = null):void
		{
			tester.assertStatuses(factoryObject, [
				"a0,CD",
				"a10,CD",
				"a11,FD",
				"a20,FD",
				"a21,CD"
			]);

			tester.assertEvents(factoryObject, eventQueue, [
				"a0,CI",
				"a10,CI",
				"a20,CI",
				"a21,CI",
				"a11,CI",
				"a20,FI",
				"a20,FD",
				"a11,FI",
				"a11,FD",
				"a21,CD",
				"a10,CD",
				"a0,CD"
			]);
		}


		public function repeatable3timesSync():Object
		{
			var a:AbstractAction = new SuccessSyncRepeatableAction("", 3);
			var res:Object = {result:a,	accessors:{a0:a}, validate:validate_repeatable3times,
				validate2:validate_repeatable3times_2nd};
			return res;
		}


		public function repeatable3timesAsync():Object
		{
			var a:AbstractAction = new SuccessAsyncRepeatableAction("", 3);
			var res:Object = {result:a,	accessors:{a0:a}, validate:validate_repeatable3times,
				validate2:validate_repeatable3times_2nd};
			return res;
		}


		private function validate_repeatable3times(factoryObject:Object, eventQueue:Array = null):void
		{
			tester.assertEquals_("Number of children after initialization and 1st execution", 2, factoryObject.result.numChildren);
			//testing by index instead of by accessor
			tester.assertStatuses(factoryObject, [
				",CD",
				"0,CD",
				"1,NS"
			]);

			tester.assertEvents(factoryObject, eventQueue, [
				",CI",
				"0,CI",
				"0,CD",
				",CD"
			], true);
		}


		private function validate_repeatable3times_2nd(factoryObject:Object, eventQueue:Array = null):void
		{
			tester.assertEquals_("Number of children after initialization and 2nd execution", 3, factoryObject.result.numChildren);
			//testing by index instead of by accessor
			tester.assertStatuses(factoryObject, [
				",CD",
				"0,CD",
				"1,CD",
				"2,NS"
			]);

			tester.assertEvents(factoryObject, eventQueue, [
				"1,CI",
				"1,CD"
			], true);
		}


		public function repeatableSuccessCompositeAsync():Object
		{
			var a:AbstractAction = new SuccessAsyncCompositeRepeatableAction();
			var res:Object = {result:a,	accessors:{a0:a}, validate:validate_repeatableSuccessCompositeAsync};
			return res;
		}


		private function validate_repeatableSuccessCompositeAsync(factoryObject:Object, eventQueue:Array = null):void
		{
			tester.assertEquals_("Number of children after initialization and 1st execution", 2, factoryObject.result.numChildren);
			//testing by index instead of by accessor
			tester.assertStatuses(factoryObject, [
				",CD",
				"0,CD",
				"00,CD",
				"01,CD",
				"1,NS",
				"10,NS",
				"11,NS"
			]);

			tester.assertEvents(factoryObject, eventQueue, [
				",CI",
				"0,CI",
				"00,CI",
				"00,CD",
				"01,CI",
				"01,CD",
				"0,CD",
				",CD"
			], true);
		}


		public function repeatableFailCompositeAsync():Object
		{
			var a:AbstractAction = new FailAsyncCompositeRepeatableAction();
			var res:Object = {result:a,	accessors:{a0:a}, validate:validate_repeatableFailCompositeAsync,
				validate2:validate_repeatableFailCompositeAsync_2ndTime};
			return res;
		}


		private function validate_repeatableFailCompositeAsync(factoryObject:Object, eventQueue:Array = null):void
		{
			tester.assertLogicType(LogicType.OR, AbstractAction(factoryObject.result));

			//ensure that logic types of copied actions are preserved 
			tester.assertLogicType(LogicType.AND, AbstractAction(factoryObject.result.children[0]));
			tester.assertLogicType(LogicType.AND, AbstractAction(factoryObject.result.children[1]));

			//testing by index instead of by accessor
			tester.assertStatuses(factoryObject, [
				",CI",
				"0,FD",
				"00,FD",
				"01,FD",
				"1,NS",
				"10,NS",
				"11,NS"
			]);

			tester.assertEvents(factoryObject, eventQueue, [
				",CI",
				"0,CI",
				"00,CI",
				"00,CD",
				"01,CI",
				"01,FI",
				"0,FI",
				"00,FI",
				"00,FD",
				"0,FD",
				"01,FD"
			], true);

		}


		private function validate_repeatableFailCompositeAsync_2ndTime(factoryObject:Object,
																	   eventQueue:Array = null):void
		{
			tester.assertLogicType(LogicType.OR, AbstractAction(factoryObject.result));

			//ensure that logic types of copied actions are preserved 
			tester.assertLogicType(LogicType.AND, AbstractAction(factoryObject.result.children[0]));
			tester.assertLogicType(LogicType.AND, AbstractAction(factoryObject.result.children[1]));

			//testing by index instead of by accessor
			tester.assertStatuses(factoryObject, [
				",FD",
				"0,FD",
				"00,FD",
				"01,FD",
				"1,FD",
				"10,FD",
				"11,FD"
			]);

			tester.assertEvents(factoryObject, eventQueue, [
				"1,CI",
				"10,CI",
				"10,CD",
				"11,CI",
				"11,FI",
				"1,FI",
				"10,FI",
				"10,FD",
				"1,FD",
				",FI",
				"11,FD",
				",FD"
			], true);
		}


		public function repeatableFailCompositeAsync2():Object
		{
			var a:AbstractAction = new FailAsyncCompositeRepeatableAction();
			//swap children
			var a2:AbstractAction = a.children[1];
			a.children[1] = a.children[0];
			a.children[0] = a2;

			var res:Object = {result:a,	accessors:{a0:a}, validate:validate_repeatableFailCompositeAsync2};
			return res;
		}


		private function validate_repeatableFailCompositeAsync2(factoryObject:Object, eventQueue:Array = null):void
		{
			//testing by index instead of by accessor
			tester.assertStatuses(factoryObject, [
				",FI",
				"0,FD",
				"00,FD",
				"01,NS",
				"1,FD",
				"10,FD",
				"11,NS"
			]);

			tester.assertEvents(factoryObject, eventQueue, [
				",CI",
				"0,CI",
				"00,CI",
				"00,FI",
				"0,FI",
				"00,FD",
				"0,FD"
			], true);
		}
	}
}