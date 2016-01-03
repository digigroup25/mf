package mindmaps.history
{
	public class OperationRepository
	{
		private var operations:Array = new Array();
		
		public function OperationRepository()
		{
		}
		
		public function register (operation:Operation, complement:Operation=null):void {
			operations.push({operation:operation, complement:complement});
		}
		
		public function getComplement (operation:Operation) : Operation {
			var res:Operation = null;
			var item:Object = findByOperation(operation);
			var isComplement:Boolean = false;
			if (item==null) {
				item = findByComplement(operation);
				isComplement = true;
				if (item==null) return null;
			}
			if (isComplement) return item.operation;
				else return item.complement;
		}
		
		private function findByOperation(operation:Operation):Object {
			for each (var o:Object in operations) {
				if (o.operation==operation)
					return o;
			}
			return null;
		}
		
		private function findByComplement(complement:Operation):Object {
			for each (var o:Object in operations) {
				if (o.complement == complement) 
					return o;
			}
			return null;
		}
	}
}