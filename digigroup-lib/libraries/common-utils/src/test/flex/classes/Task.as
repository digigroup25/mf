package classes {

	public dynamic class Task {
		public var name:String;

		public var priority:int;

		public var committed:Boolean;

		/*public var done:int;
		public var description:String;
		public var date:Date;*/

		public function toString():String {
			return name;
		}

		public function setName(name:String):Task {
			this.name = name;
			return this;
		}

		public function setPriority(priority:int):Task {
			this.priority = priority;
			return this;
		}

		public function setCommitted(committed:Boolean):Task {
			this.committed = committed;
			return this;
		}
	}
}
