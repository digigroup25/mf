package mindmaps2.elements {
	import vos.Appointment;
	import vos.Contact;
	import vos.Note;
	//import vos.Program;
	import vos.Task;

	public class ElementsTestFactory {
		public function ElementsTestFactory() {
		}

		public function importantTask():Task {
			var res:Task = new Task();
			res.name = "important task";
			res.priority = 3;
			res.done = 0;
			res.assignedTo = "importantPerson";
			return res;
		}

		public function taskDoneBeforeDeadline():Task {
			var res:Task = new Task();
			res.name = "task before deadline";
			res.done = 1;
			res.date = new Date(2009, 3, 1);
			return res;
		}

		public function shortNote():Note {
			var res:Note = new Note();
			res.name = "short note";
			res.description = "short note description";
			return res;
		}

		public function contact():Contact {
			var res:Contact = new Contact();
			res.name = "vlad";
			res.company = "demandbase";
			res.phone = "(415) 218-5395";
			res.email = "vladrodeski@gmail.com";
			return res;
		}

		public function appointment():Appointment {
			var res:Appointment = new Appointment();
			res.name = "meet with Jon";
			res.description = "discuss semantic web";
			res.location = "embarcadero building";
			res.date = new Date(2009, 4, 22, 14, 2);
			return res;
		}
	/*public function program():Program {
		var res:Program = new Program();
		res.name = "prolog list program";
		res.text = 	"member(X, [X|V1]).\n"+
					"member(X, [V1|Tail]):-member(X, Tail).";
		return res;
	}*/
	}
}
