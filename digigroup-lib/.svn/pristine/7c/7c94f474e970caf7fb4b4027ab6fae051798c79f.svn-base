package mindmaps.elementderivatives
{
	import mx.utils.StringUtil;
	
	public class ProjectParser
	{
		public function ProjectParser()
		{
		}
		
		//format: {label:<label>, groups:<[group1,group2]>}
		public function parse(text:String):Array {
			var res:Array = [];
			text = replaceMultiple(text, "\t", "");
			text = replaceMultiple(text, "\n", "\n");
			var onlyTasks:RegExp = new RegExp("^-\\s*.*$", "gm");
			var lines:Array = text.match(onlyTasks);
			for each (var line:String in lines) {
				var lineComponents:Array = line.split("- ");
				var taskName:String = String(lineComponents[1]);
				var groupLine:String = String(lineComponents[2]);
				groupLine = replaceMultiple(groupLine, " ", "");
				var groups:Array = groupLine.split(",");
				res.push({label:taskName, groups:groups});
			}
			
			return res;
		}
		
		public function replaceMultiple(s:String, replaceWhat:String, replaceWith:String):String {
			var regExp:RegExp = new RegExp(StringUtil.substitute("{0}+", "\\"+replaceWhat), "g");
			var res:String = s.replace(regExp, replaceWith);
			return res;
		} 
	}
}