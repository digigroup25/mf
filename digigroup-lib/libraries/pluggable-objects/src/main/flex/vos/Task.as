package vos {

	import collections.*;

	import flash.net.registerClassAlias;

	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	registerClassAlias("vos.Task", Task);

	[Bindable]
	public dynamic class Task implements IPluggableObject {
		public var name:String;

		public var priority:int;

		public var complexity:int;

		public var done:int;

		public var committed:Boolean;

		public var reviewed:Boolean;

		public var description:String;

		public var date:Date;

		public var assignedTo:String;

		public var estimatedHours:Number = NaN;

		public var actualHours:Number = NaN;

		public var value:int;

		public function toString():String {
			return name;
		}

		public function toLongString():String {
			//return StringUtil.substitute("{0}, {1}, {2}, {3}, {4}, {5}", name, priority, complexity, done, description, date);
			return ObjectUtil.toString(this);
		}

		public function setName(name:String):Task {
			this.name = name;
			return this;
		}

		public function setPriority(priority:int):Task {
			this.priority = priority;
			return this;
		}

		public function setComplexity(complexity:int):Task {
			this.complexity = complexity;
			return this;
		}

		public function setDone(done:int):Task {
			this.done = done;
			return this;
		}

		public function setCommitted(committed:Boolean):Task {
			this.committed = committed;
			return this;
		}

		public function setReviewed(reviewed:Boolean):Task {
			this.reviewed = reviewed;
			return this;
		}

		public function setDescription(description:String):Task {
			this.description = description;
			return this;
		}

		public function setDate(date:Date):Task {
			this.date = date;
			return this;
		}

		public function setAssignedTo(assignedTo:String):Task {
			this.assignedTo = assignedTo;
			return this;
		}

		public function setEstimatedHours(estimatedHours:Number):Task {
			this.estimatedHours = estimatedHours;
			return this;
		}

		public function setActualHours(actualHours:Number):Task {
			this.actualHours = actualHours;
			return this;
		}

		public function setValue(value:int):Task {
			this.value = value;
			return this;
		}
	}
}
