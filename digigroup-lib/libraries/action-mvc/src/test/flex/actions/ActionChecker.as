package actions
{
	import flexunit.framework.TestCase;
	
	import mx.utils.StringUtil;

	import actions.ActionParser;
	import actions.ActionParserResult;

	import org.flexunit.asserts.assertEquals;


	public class ActionChecker
	{
		private const parser:ActionParser = new ActionParser();
		
		public function assertEquals_(message:String, expectedValue:*, actualValue:*):void {
			assertEquals(message, expectedValue, actualValue);
		}
		
		public function assertStatus(action:Object, status:String):void {
			assertEquals(AbstractAction(action).toString(), status, action.status);
		}
		
		public function assertStatuses(factoryObject:Object, expectedResults:Array):void {
			for (var i:int=0; i<expectedResults.length; i++) {
				var expectedResult:String = expectedResults[i];
				var parsedExpectedResult:ActionParserResult = parser.parse(factoryObject, expectedResult);
				assertStatus(parsedExpectedResult.action, parsedExpectedResult.status);
			}
		} 
		
		private function assertEvent_(factoryObject:Object, expectedResults:Array, eventSequence:int, 
			events:Array, action:Object, status:String, actionsByIndex:Boolean):void {
			var event:ActionEvent = events[eventSequence];
			var eventErrorMessage:String = getDescription(eventSequence) + 
				getEventsDescription(factoryObject, expectedResults, events, actionsByIndex);
			assertEquals(eventErrorMessage, action, event.targetAction);
			assertEquals(getDescription(eventSequence, "action status"), status, event.status);
			assertEquals(getDescription(eventSequence, "action target"), action, event.targetAction);
		}
		
		public function assertEvent(event:ActionEvent, action:Object, status:String, targetAction:AbstractAction):void {
			assertEquals("action status", status, event.status);
			assertEquals("action target", targetAction, event.targetAction);
		}
		
		private function getEventsDescription(factoryObject:Object, expectedResults:Array, events:Array, 
			actionsByIndex:Boolean):String {
			return StringUtil.substitute("\nExpected\t{0}\nbut was\t{1}", arrayToString(expectedResults),
				eventsToString(factoryObject, events, actionsByIndex));
		}
		
		private function getDescription(eventSequence:int, message:String=""):String {
			return StringUtil.substitute("Event{0}: {1}", eventSequence, message);
		}
		
		private function arrayToString(items:Array):String {
			var res:String = "";
			for each (var item:String in items) {
				res += StringUtil.substitute("({0})", item);
			}
			return res;
		}
		
		private function eventsToString(factoryObject:Object, events:Array, actionsByIndex:Boolean):String {
			var res:String = "";
			for each (var event:ActionEvent in events) {
				var actionNameOrIndex:String = actionsByIndex ? 
					getIndex(AbstractAction(factoryObject.result), event.targetAction) 
					: getAccessorName(factoryObject, event.targetAction);
				res += StringUtil.substitute("({0},{1})", actionNameOrIndex, 
					parser.toShortStatus(event.status));
			}
			return res;
		}
		
		private function getAccessorName(factoryObject:Object, action:AbstractAction):String {
			for (var name:String in factoryObject.accessors) {
				if (factoryObject.accessors[name]==action)
					return name;
			}
			throw new Error("Unable to locate name for action "+action.toString());
		}
		
		private function getIndex(root:AbstractAction, descendant:AbstractAction):String {
			var res:String = "";
			var ancestorActions:Array = descendant.getPath(root);
			if (ancestorActions.length==0) 
				return res;
			var parent:AbstractAction = root;
			
			var childIndex:int;
			for (var i:int=1; i<ancestorActions.length; i++) {
				var child:AbstractAction = ancestorActions[i];
				childIndex = parent.getChildIndex(child);
				if (childIndex==-1) {
					throw new Error(StringUtil.substitute("Action {0} is not a child of action {1}",
						child.name, parent.name));
				}
				parent = child;
				res += childIndex.toString();
			}
			//last node
			childIndex = parent.getChildIndex(descendant);
			res += childIndex.toString();
			return res;
		}
		
		public function assertEvents(factoryObject:Object, eventQueue:Array, expectedResults:Array, 
			actionsByIndex:Boolean=false):void {
			assertEquals(getEventsDescription(factoryObject, expectedResults, eventQueue
				, actionsByIndex), expectedResults.length, eventQueue.length);
			for (var i:int=0; i<expectedResults.length; i++) {
				var expectedResult:String = expectedResults[i];
				var parsedExpectedResult:ActionParserResult = parser.parse(factoryObject, expectedResult);
				assertEvent_(factoryObject, expectedResults, i, eventQueue, parsedExpectedResult.action, 
					parsedExpectedResult.status, actionsByIndex);
			}
		}
		
		public function assertLogicType(expectedLogicType:String, action:AbstractAction):void {
			assertEquals(expectedLogicType, action.logicType);
		}
	}
}