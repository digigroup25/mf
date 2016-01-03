
package xprolog {
	//////////////////////////////////////////////////////////////////////
 public  class KnowledgeBase
///////////////////////////////////////////////////////////////////////
{
    var ht:Hashtable;
    var primitives:HashSet;
    
    var oldIndex:String;
    
    public function KnowledgeBase() 
    {
        reset();
    }
        
    public function get( key:Object):Object {   return ht.get(key); }
    
    public function put( key:Object, value:Object):void {   ht.put(key,value); }
            
    public function toString():String {    return ht.toString(); }
    
    public function elements():Enumeration {    return ht.elements(); }

            
    public function reset():void {
        ht = new Hashtable();
        primitives = new HashSet();    
        oldIndex = "" ;      
    }
       
    public function consult( fName:String):void
    {
        oldIndex = "" ;      
        new Parser( new FileReader(fName)).Program( this );
    }

// ==========================================================
    public function addPrimitive( clause:Clause):void // ----------------------------------------------------------
    {
        var term:Term= clause.term;
        
        var index:String= term.getfunctor() + "/" + term.getarity();
        var c:Clause= Clause(ht.get(index));
        if ( c!= null) 
        {
            while (c.nextClause != null) c = c.nextClause;
            c.nextClause = clause;
        }
        else {
            primitives.add( index );
            ht.put(index, clause);    
        }
    }

    public function addClause( clause:Clause):void // -----------------------------------------------------------
    {
        var term:Term= clause.term;
        
        var index:String= term.getfunctor() + "/" + term.getarity();
        if (primitives.contains(index))
        {
            System.out.println("Trying to modify primitive predicate: " + index);
            return;
        }
        
        if (!oldIndex.equals(index)) {
            ht.remove( index );
            ht.put(index, clause);    
            oldIndex = index;
        }
        else {
        
            var c:Clause= Clause(ht.get(index));
            while (c.nextClause != null) 
                c = c.nextClause;
            c.nextClause = clause;
        }
    }

// ==========================================================
    public function assert(term:Term):void // -----------------------------------------------------------------------
    {
        term = term.cleanUp();
        var newC:Clause= new Clause( term.deref(), null );
        
        var index:String= term.getfunctor() + "/" + term.getarity();
        if (primitives.contains(index))
        {
            IO.error("Assert","Trying to insert a primitive: " 
                  + index);
            return;
        }
            
        var c:Clause= Clause(ht.get(index));
        if ( c!= null) 
        {
                while (c.nextClause != null) c = c.nextClause;
                c.nextClause = newC;
        }
        else {
                ht.put(index, newC);    
        }
    }

// ==========================================================
    public function asserta(term:Term):void // -----------------------------------------------------------------------
    {
        var index:String= term.getfunctor() + "/" + term.getarity();
        if (primitives.contains(index)){
            IO.error("Assert","Trying to insert a primitive: " + index);
            return;
        }

        term = term.cleanUp();
        var newC:Clause= new Clause( term.deref(), null);        
        var c:Clause= Clause(ht.get(index));
        newC.nextClause = c;
        ht.put(index, newC);            
    }

// ==========================================================
    public function retract(term:Term, stack:Stack):Boolean // -----------------------------------------------------------------------
    {
        var newC:Clause= new Clause( term, null );
        var index:String= term.getfunctor() + "/" + term.getarity();
        if (primitives.contains(index)){
            IO.error("Retract","Trying to retract a primitive: " + index);
            return false;
        }
        var cc:Clause= null,
            c = Clause(ht.get(index));

        while ( c!=null) 
        {
            var vars:Array = new Array();
            var xxx:Term= c.term.refresh(vars);
            var top:int= stack.size();
            if (xxx.unify(term, stack))
            {
                if ( cc != null )
                    cc.nextClause = c.nextClause;
                else if ( c.nextClause==null )
                    ht.remove(index);
                else 
                    ht.put(index, c.nextClause);
                return true;
            }
            for (var i:int= stack.size()-top; i>0; i--)
            {
                var t:Term= Term(stack.pop());
                t.unbind();
            }
            cc = c;
            c = c.nextClause;
        }
        return false;
    }
    
// ==========================================================
    public function retractall( term:Term, arity:Term):Boolean // ----------------------------------------------------------
    {
	var key:String= term.getfunctor() + "/" + arity.getfunctor();
        if (primitives.contains(key)){
            IO.error("Retractall","Trying to retract a primitive: " + key);
            return false;
        }
	ht.remove( key );
	return true;
    }

// ==========================================================
    public function get_(key:Term):Term // ----------------------------------------------------------
	{	
		return ht.get_( key.toString() );
	}
	
// ==========================================================
    public function set(key:Term, value:Term):void // ----------------------------------------------------------
	{	
		ht.put( key.toString(), value.cleanUp() );
	}

// =======================================================

    public function dump():void { dump(false);}
    
    public function dump(full:Boolean):void {
        System.out.println();
        var i:int= 1;
        var e:Enumeration= ht.keys();
        while (e.hasMoreElements() )
        {
            var key:Object= e.nextElement();
            if (!full && primitives.contains(key)) 
                continue;
            var val:Object= ht.get(key);
            if (val instanceof Clause) 
            {
            	System.out.println(i++ + ". " + key + ": " );
				var head:Clause= Clause(ht.get(key));
				do {
					System.out.print("    " + head.term);
					if (head.next != null) 
						System.out.print ( " :- " + head.next );
					System.out.println(".");
					head = head.nextClause;
				}
				while ( head != null );
			}
			else   // get/set pair
				System.out.println(i++ + ". " + 
				          key + " = " + val);
        }
        System.out.println();
    }

    public function list( term:Term, arity:Term):void {
        var key:String= term.getfunctor() + "/" + arity.getfunctor();
	System.out.println();
	System.out.println( key + ": " );
	var head:Clause= Clause(ht.get(key));
	while ( head != null )
	    {
		System.out.print("    " + head.term);
		if (head.next != null) 
		    System.out.print ( " :- " + head.next );
		System.out.println(".");
		head = head.nextClause;
	    }
    }
}
}
