package collections
{
	import mx.utils.ObjectUtil;

	public class Set
	{
		private var list:Array;
		
		private var compareByValue:Boolean = false;
		
		public function Set(compareByValue:Boolean=false)
		{
			this.compareByValue = compareByValue;
		}
		
		public function get size():uint {
			return (list==null) ? 0 : list.length;
		}
		
		public function isEmpty():Boolean {
			return size==0;
		}
		
		public function contains(item:*):Boolean {
			if (isEmpty())
				return false;
			else 
				return indexOf(item)!=-1; 
		}
		
		public function indexOf(item:*):int {
			if (isEmpty()) 
				return -1;
			else if (compareByValue)
				return indexOfCompareByValue(item);
			else 
				return list.indexOf(item);
		}
		
		private function indexOfCompareByValue(item:*):int {
			for (var i:uint=0; i<list.length; i++) {
				var curItem:* = list[i];
				
				if (ObjectUtil.compare(item, curItem)==0)
					return i;
			}
			return -1;
		}
		
		public function add(item:*):void {
			if (list==null)
				list = new Array();
			if (!contains(item))
				list.push(item);
		}
		
		public function remove(item:*):void {
			if (list==null) return;
			if (contains(item)) {
				var index:int = indexOf(item);
				list.splice(index, 1);
			}
		}
		
		public function toArray():Array {
			if (list==null) return [];
			return list.concat();
		}
		
		public function fromArray(list:Array):void {
			for each (var item:* in list) {
				this.add(item);
			}
		}
		
		public function clear():void {
			list = new Array;
		}
		
		public function containsAll(set:Set):Boolean {
			for each (var item:* in set.toArray()) {
				if (!this.contains(item))
					return false;
			}
			return true;
		}
		
		public function addAll(set:Set):void {
			for each (var item:* in set.toArray()) {
				this.add(item);
			}
		}
		
		public function removeAll(set:Set):void {
			for each (var item:* in set.toArray()) {
				this.remove(item);
			}
		}
		
		public function retainAll(set:Set):void {
			var intersection:Array = [];
			for each (var item:* in set.toArray()) {
				if (this.contains(item)) {
					intersection.push(item);
				}
			}
			this.clear();
			this.fromArray(intersection);
		}
	}
}