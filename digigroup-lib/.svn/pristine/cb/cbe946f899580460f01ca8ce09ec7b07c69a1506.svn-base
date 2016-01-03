package wprolog {		

/** The class IO simply centralises all IO for easy modification */
public class IO {

	public static function error(caller:String, mesg:String):void {
		WPrologOutput.addResult(
			"ERROR: in " + caller + " : " + mesg + "\n");
	}
	
	// fatal error ...
	public static function fatalerror(caller:String, mesg:String):void {
		WPrologOutput.addResult(
			"FATAL ERROR: in " + caller + " : " + mesg + "\n");
	}
	
	
	public static function result(s:String):void {
		WPrologOutput.addResult(s+"\n");
	}
	
	public static function diagnostic(s:String):void {
		WPrologOutput.addResult("*** "+s+"\n");
	}
	
	public static function trace_(s:String):void {
		WPrologOutput.addResult(s+"\n");
	}
	
	public static function prologprint(s:String):void {
		WPrologOutput.addResult(s);
	}
}
}