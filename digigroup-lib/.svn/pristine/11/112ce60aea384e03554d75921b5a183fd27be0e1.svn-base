package commonutils
{
    import flash.net.*;
    import flash.utils.ByteArray;
    
    import persistence.*;
	
    /**
     * All static class which defines a single static method in which 
     * objects can be cloned by creating a Deep Copy of a reference 
     * object to a new memory address
     */
    public final class DeepCopy
    {
        /**
         * Creates a deep copy of a specified object which is identical
         * to the referenced object
         *
         * @param   the reference object in which to clone
         * @return  a clone of the original reference object
         */
        public static function clone(obj:*, registerClassAliases:Boolean=true):Object
        {
        	if (registerClassAliases)
				ObjectPersistor.registerClassAliases(obj);
			
            var clone:ByteArray = new ByteArray();
            clone.writeObject(obj);
            clone.position = 0;

            return clone.readObject();
        }
    }
}