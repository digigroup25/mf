package mindmaps.elementderivatives.subway
{
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	public class Station
	{
		private var _lines:ArrayCollection = new ArrayCollection();
		private var _name:String;
		public var visited:Boolean = false;
		
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			_name = value;
		}
		
		public function get fullName():String {
			return this.toString();
		} 
		
		public function get lines():ArrayCollection {
			return _lines;
		}
		
		public function Station(name:String="")
		{
			this._name = name;
		}
		
		public function isTransferStation():Boolean {
			return lines.length>1;
		}
		
		internal function addLine(line:Line):void {
			if (lines.contains(line)) return;
			lines.addItem(line);
		}
		
		public function toString():String {
			return StringUtil.substitute("l{0}s{1}", this.lines[0].name, this.name);
		}
		
		public function containsLine(line:Line):Boolean {
			for each (var curLine:Line in lines) {
				if (curLine==line) return true;
			}
			return false;
		}
	}
}