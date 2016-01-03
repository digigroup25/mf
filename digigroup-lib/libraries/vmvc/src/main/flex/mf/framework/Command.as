package mf.framework
{
	public class Command implements ICommand
	{
		private var _context:CommandContext;
		
		public function get context():CommandContext {
			return _context;
		}
		
		public function set context(val:CommandContext):void {
			this._context = val;
		}
		
		public function Command()
		{
		}
		
		public function execute() : void {
			throw new Error("abstract operation, override in your command");
		}
		
	}
}