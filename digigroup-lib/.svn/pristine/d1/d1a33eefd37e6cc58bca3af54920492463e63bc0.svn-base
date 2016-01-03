package testClasses
{


	import actions.AbstractUserAction;


	public class CreateSoftwareProjectAction extends AbstractUserAction
	{
		public function CreateSoftwareProjectAction()
		{
			super("Create Software Project");
			this.addChild(new CreateProject());
			var firstTaskAction:CreateTaskAction = new CreateTaskAction();
			this.addChild(firstTaskAction);
		}

	}
}