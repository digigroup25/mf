package actions
{
	import mx.controls.Alert;
	
	public class RegisterAction extends AbstractUserAction
	{
		public function RegisterAction(name:String=null)
		{
			super(name, 2);
			this.logicType = LogicType.AND;
			this.addChild(new RegisterFirstNameAction());
			this.addChild(new RegisterLastNameAction());
		}
		
		/* protected override function doExecute():void {
			Alert.show("Registration successful");
			super.doExecute();
		}
		
		protected override function doAbort():void {
			Alert.show("Registration failed");
			super.doAbort();
		} */
		
	}
}