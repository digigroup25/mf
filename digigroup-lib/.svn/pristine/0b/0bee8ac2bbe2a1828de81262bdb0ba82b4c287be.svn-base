package actions
{
	public class SuccessAsyncCompositeRepeatableAction extends SuccessAsyncRepeatableAction
	{
		public function SuccessAsyncCompositeRepeatableAction(name:String="SuccessAsyncCompositeRepeatableAction", 
			repeatCount:int=3, time:int=100)
		{
			super(name, repeatCount, time);
			this.type = ActionType.SEQUENTIAL;
			this.logicType = LogicType.AND;
			this.addChildren([new SuccessAsyncAction(), new SuccessAsyncAction()]);
		}
		
	}
}