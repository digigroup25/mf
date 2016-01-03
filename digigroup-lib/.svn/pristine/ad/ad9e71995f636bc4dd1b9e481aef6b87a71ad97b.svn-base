package actions
{
	public class FailAsyncCompositeRepeatableAction extends SuccessAsyncRepeatableAction
	{
		public function FailAsyncCompositeRepeatableAction(name:String="FailAsyncCompositeRepeatableAction", 
			repeatCount:int=2, time:int=100)
		{
			super(name, repeatCount, time);
			this.type = ActionType.SEQUENTIAL;
			this.logicType = LogicType.AND;
			this.addChildren([new SuccessAsyncAction(), new FailAsyncAction()]);
		}
		
	}
}