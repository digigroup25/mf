package mindmaps.importexport {
	import mx.utils.ObjectUtil;

	public class Match {

		/*public function get value():* {
			return _value;
		}*/

		public function Match(type:String, value:*) {
			this._type = type;
			this.value = value;
			this.score = 0;
		}

		public var value:*;

		public var inputValue:*;

		public var score:Number;

		private var _type:String;

		public function get type():String {
			return _type;
		}

		public function setInputValue(inputValue:*):Match {
			this.inputValue = inputValue;
			return this;
		}

		public function setScore(score:Number):Match {
			this.score = score;
			return this;
		}

		public function setValue(value:*):Match {
			this.value = value;
			return this;
		}

		public function setType(type:String):Match {
			this._type = type;
			return this;
		}
	/*
	public function setValue(value:*):Token {
		this.value = value;
		return this;
	}*/
	}
}
