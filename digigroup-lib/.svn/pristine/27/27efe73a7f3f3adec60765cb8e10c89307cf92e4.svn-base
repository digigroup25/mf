package testClasses
{


	import actions.AbstractIOAction;


	public class ChildBCIOAction extends AbstractIOAction
	{
		public function ChildBCIOAction() {
			super("childBC");
		}
		
		override protected function doExecute():void {
			if (this.input.hasOwnProperty("b"))
				this.output["c"]=0;
			this.output["d"]=0;
			
			this.forceComplete();
		} 
	}
}