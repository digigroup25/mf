package assertions {

	import mx.utils.StringUtil;
	
	
	
	/**
	 *
	 */
	public class Require {
		
	    private static const NEW_LINE:String = "\n";
		
		private static function throwError(errorMessage:String):void {
			throw new ArgumentError(errorMessage);
		}
		
		public static function isTrue(value:Boolean, parameterName:String):void{
			if (!value){
				throwError(parameterName + " is false");
			}
		}
		
		public static function isFalse(value:Boolean, parameterName:String):void{
			if (value){
				throwError(parameterName + " is true");
			}
		}
		
	    /**
	     * Verifies that the provided parameter is not null.
	     *
	     * @param parameter - The parameter value to check
	     * @param parameterName - The name of the parameter
	     * @throws ArgumentError - thrown if parameter is NULL
	     */
	    public static function notNull(parameter:Object, parameterName:String):void {
	        if (parameter == null) {
	        	var message:String = parameterName==null ? "Cannot be null" : parameterName + " cannot be null";
	            throwError(message);
	        }
	    }
		
		public static function hasProperty(parameter:Object, parameterName:String, propertyName:String):void {
			notNull(parameter, parameterName);
			notNull(propertyName, "propertyName");
			
			if (!parameter.hasOwnProperty(propertyName)) {
				throwError(StringUtil.substitute("{0} does not have a property {1}", parameterName, propertyName));
			}
		}
	   
	    /**
	     * Verifies that the provided Collection is not empty, implicitly this also means that the collection cannot be null
	     * as well
	     *
	     * @param collection - The collection to be verified
	     * @param collectionName - The name of the collection
	     * @throws ArgumentError - thrown when collection is empty or null
	     */
	    public static function notEmpty(collection:Object, collectionName:String):void {
	        collectionSize(collection, collectionName, 0);
	    }
	    
	    public static function collectionSize(collection:Object, collectionName:String, size:uint):void {
	    	notNull(collection, collectionName);
			hasProperty(collection, collectionName, "length");
			
	        if (collection["length"]!=size) {
	            throwError(collectionName + " is not of size " + size);
	        }
	    }
	
	    /**
	     * Requires that the provided parameter is an instance of the provided target type
	     * @param parameter - The value whose type is to be verified
	     * @param targetType - The target class that the parameter is an instance of
	     * @param parameterName - The name of the parameter
	     * @throws ArgumentError
	     */
	    public static function instanceOf(parameter:Object, targetType:Class, parameterName:String):void {
	        notNull(parameter, "parameterName");
	        notNull(targetType, "targetType");
	
	        if (!(parameter is targetType)) {
	            throwError(parameterName + " is not of type " + targetType);
	        }
	    }
	}
    
}
