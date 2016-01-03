//////////////////////////////////////////////////////
//
//  PostOffice.java:  Dispatcher for messages between Prolog Agents.
//  ================
//  Author: J. Vaucher (vaucher@iro.umontreal.ca)
//  Date: 2002/5/10
//  URL:  www.iro.umontreal.ca/~vaucher/~XProlog
//

package xprolog {
public class PostOffice {

    static var agents:ArrayList= new ArrayList();

    public static function register( l:List):int {
	agents.add( l );
        return agents.size()-1;
    }
	
    public static function send( src:int, dest:int, msg:Term):void {
	if ( dest>=agents.size()) return;
	var m:Message= new Message(src, msg);
        var l:List= List(agents.get(dest));
	l.add( m );
    }

    public static function broadcast( src:int, msg:Term):void {
	var m:Message= new Message(src, msg);

	for (var i:int= 0; i<agents.size(); i++) {
	    var l:List= List(agents.get(i));
	    l.add( new Message(src, msg) );
	}
    }

}
	
class Message 
{
    var source:int;
    var content:Term;

    public function Message(s:int, m:Term)
    {
	source = s;
	content = m;
    }
    public function toString():String {
	return source + ":" + content ;
    }
}
}