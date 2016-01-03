package mindmaps2.ui
{
	import actions.AbstractAction;
	import actions.AbstractUserAction;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mf.framework.Container2;
	import mf.framework.IMessageBroker;
	import mf.framework.IModelProvider;
	
	import mindmaps2.ApplicationContainer;
	
	public class InteractiveMenuUserActionSimulator extends InteractiveMenuController
	{
		private var availableUserActions:Array;
		private var timer:Timer = new Timer(2000);
		
		public function InteractiveMenuUserActionSimulator(model:IModelProvider, mb:IMessageBroker, rootAction:AbstractAction,
			rootContainer:ApplicationContainer)
		{
			super(model, mb, rootAction, rootContainer);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		//get all user actions available, wait for 2 sec, pick a random action and execute it
		protected override function showMenu(invocationContainer:Container2):void {
			availableUserActions = userActions.getAvailableUserActions(rootAction);
			timer.start();
		}
		
		private function onTimer(event:TimerEvent):void {
			timer.stop();
			
			//pick random action
			var numberActions:int = availableUserActions.length;
			var randomActionIndex:int = Math.floor(Math.random()*numberActions);
			var randomAction:AbstractUserAction = availableUserActions[randomActionIndex];
			randomAction.initialize();
			
			if (randomAction.userInvocationOnly)
				randomAction.userExecute();
			else
				randomAction.execute();
			trace("InteractiveMenuUserActionSimulator.onTimer: executing action "+randomAction.toString());
			
			menu.start();
		}
	}
}