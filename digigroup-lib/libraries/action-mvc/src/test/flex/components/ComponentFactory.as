package components
{
	public class ComponentFactory
	{
		public function createInputBox(name:String):InputDataBox
		{
			var res:InputDataBox = new InputDataBox();
			res.inputFieldName = name;
			return res;
		}

	}
}