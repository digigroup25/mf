package mf.framework
{
	public interface ISender
	{
		function send(message:Message, itself:Boolean=false):void;
	}
}