package actions
{
	public class ActionError extends Error
	{
		public function ActionError(message:String)
		{
			super(message, 0);
		}
		
	}
}