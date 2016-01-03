//  Play.java  :  Testbench to have two Prolog agents interacting
//  ================
//  Author: J. Vaucher (vaucher@iro.umontreal.ca)
//  Date: 2002/5/10
//  URL:  www.iro.umontreal.ca/~vaucher/~XProlog
//  ----------------------------------------------------------------------
//  Usage: java Play <KB for env> <KB for agent1> 
// 
//   The system first executes the query "init" in context of ENV
//   then queries user for AGENT queries
//   After doing each AGENT query, the system automatically executes
//    a "doTurn" on ENV

package xprolog {


	public class Play 
	{
	    static var F:BufferedReader= null ; 
	
	
	    static public function main(args:Array):void {
	        var out:PrintStream= System.out;
	        var query:String;
		var time:Number= System.currentTimeMillis();
	
	        System.out.println("\nXProlog v.1.2, May 2002");
	        if ( args.length < 2) {
	            System.out.println("Usage: java Play robot_env.pro robot.pro ");
	            System.exit(1);
	        }
	        try 
	        {
	            F = new BufferedReader(null/* new InputStreamReader( System.in ) */) ;
	                                
	            var env:Engine;
	            var ag1:Engine;
	            env = new Engine(new FileReader( args[0]));
	            ag1 = new Engine(new FileReader( args[1]));
	            Term.trace = true;
	            getAnswer( env, "init.");
	            
	            var i:int=0;
	            while (! ag1.fini && ++i<65)     
	            {
	                submit( ag1, "go.");
	                submit( env, "go." );
	            }                                
	            getAnswer( ag1, "listing( [visited/2, contains/3]).");
	       } 
	        catch (x:FileNotFoundException) {
	            System.out.println("Can't find: " +args[0]);
	        }
	        catch (f:Exception) { 
	            f.printStackTrace();
	        }
		System.out.println("Time: " + (System.currentTimeMillis()-time) 
		    + " ms.");
	    }
	
	    static function getQuery():String {
	        System.out.println();
	        System.out.print("Agent ?- "); System.out.flush();
	        try { 
	           return F.readLine();
	        } 
	        catch (e:IOException) {
	            e.printStackTrace(); return ".";
	        }
	
	    }   
	
	    static function getAnswer( e:Engine, query:String):void {
	        var res:Boolean= false;
	        try {
	            res = e.setQuery( query );
	        }
	        catch (x:ParseException) {
	            System.out.println("Parsing Problem");
	            x.printStackTrace();
	        }
	        if(res) 
	            System.out.println(">>> Answer: " + e.answer());
	        else
	            System.out.println("> No. ");
	    }   
	    static function submit( e:Engine, query:String):Boolean {
	        var res:Boolean= false;
	        try {
	            res = e.setQuery( query );
	        }
	        catch (x:ParseException) {
	            System.out.println("Parsing Problem");
	            x.printStackTrace();
	        }
		return res;
	    }   
	}
}
