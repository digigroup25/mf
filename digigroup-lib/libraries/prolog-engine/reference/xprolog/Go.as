// A simple program which interfaces to the XProlog engine.
// Author: J. Vaucher
// Author: Michael Winikoff (winikoff@cs.mu.oz.au)
// Date: 6/3/97
//
// Usage: java Go util.pro
// 
// 

package xprolog {
	public class Go 
	
{
    static public function main(args:Array):void {
        var F:BufferedReader; 
        var out:PrintStream= System.out;
        var program:String; 
        var query:String;

        try 
        {
            F = new BufferedReader() ;
                                
            var eng:Engine = new Engine();
                
            System.out.println("\n" + XProlog.VERSION );

            while (! eng.fini ) 
                try     
                {
                    System.out.println();
                    System.out.print("?- "); System.out.flush(); 
                    query = F.readLine();

                    var res:Boolean= eng.setQuery( query );
                    while (! eng.fini)
                    {
                        if(!res){ 
                            System.out.println("> No. ");
                            break;
                        }       
                        System.out.println();
                        System.out.println(">>> Answer: " + eng.answer()
                                         + "   ( " + eng.getTime() + " ms.)" );
                        out.print("More (y/n)? "); out.flush();
                        var ans:String=  F.readLine().trim();
                        if ( ans.equals("y") | ans.equals(";")){
                            res = eng.more();
                        }
                        else 
                            break;
                    }       
                }
	            catch (x:ParseException) {
	                System.out.println("Parsing Problem");
	                x.printStackTrace();
	            }
	            catch (x:TokenMgrError) {
	                System.out.println("Token Manager Problem");
	                x.printStackTrace();
	            }
                                
        } 
        catch (x:FileNotFoundException) {
            System.out.println("Can't find: " +args[0]);
        }
        catch (f:Exception) { 
            f.printStackTrace();
        }
    }
}
}
