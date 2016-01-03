package collections 
{
	import classes.*;

	import org.flexunit.asserts.assertEquals;


	public class SingletonTest
 	{
		[Test]
  	    public function getInstance():void
  		{
  			var node:MyNode = Singleton.getInstance(MyNode);
  			node.name = "vova";
  			var node2:MyNode = Singleton.getInstance(MyNode);
  			node2.name = "chia";
  			
  			assertEquals(node.name, "chia");
  			assertEquals(node2.name, "chia");
  		}

		[Test]
  		public function getInstanceDerived():void
  		{
  			var node:MyNodeDerived = Singleton.getInstance(MyNodeDerived);
  			node.name = "vova";
  			var node2:MyNodeDerived = Singleton.getInstance(MyNodeDerived);
  			node2.name = "chia";
  			
  			var node3:MyNode = Singleton.getInstance(MyNodeDerived);
  			
  			assertEquals(node.name, "chia");
  			assertEquals(node2.name, "chia");
  			assertEquals(node3.name, "chia");
  			
  			node3.name = "vilen";
  			assertEquals(node.name, "vilen");
  			assertEquals(node2.name, "vilen");
  			assertEquals(node3.name, "vilen");
  		}
  	}
}