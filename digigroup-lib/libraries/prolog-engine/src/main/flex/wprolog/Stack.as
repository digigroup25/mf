package wprolog
{
	public dynamic class Stack extends Array
	{
		public  function Stack(numElements:int=0)
		{
			super(numElements);
		}
		
		public function empty():Boolean {
			return this.length==0;
		}
	}
}