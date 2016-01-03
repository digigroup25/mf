package mindmaps.history
{
	public class Action
	{
		private var _operation:Operation;
		private var _data:Object;
		
		public function get operation():Operation {
			return _operation;
		}
		
		public function get data():Object {
			return _data;
		}
		public function Action(operation:Operation, data:Object)
		{
			this._operation = operation;
			this._data = data;
		}

	}
}