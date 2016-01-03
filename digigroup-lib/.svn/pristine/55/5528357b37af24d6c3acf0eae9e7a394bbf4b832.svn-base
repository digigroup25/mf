package testClasses
{


	import actions.AbstractIOAction;


	public class ChildABIOAction extends AbstractIOAction
	{
		public function ChildABIOAction() {
			super("childAB");
		}
		
		override protected function doExecute():void {
			if (this.input.hasOwnProperty("a"))
				this.output["b"]=0;
			this.forceComplete();
		} 
	}
}