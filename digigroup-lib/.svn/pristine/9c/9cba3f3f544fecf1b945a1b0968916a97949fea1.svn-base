package tests
{
	
	import events.*;
	
	import factories.*;
	
	import flexunit.framework.TestSuite;
	
	import mf.framework.ActionContainerDecoratorTest;
	
	import mindmaps.elementderivatives.*;
	import mindmaps.elementderivatives.subway.*;
	import mindmaps.elements.task.operations.*;
	import mindmaps.elements.task.queries.*;
	import mindmaps.history.*;
	import mindmaps.importexport.MapTextExporterTest;
	import mindmaps.inputqueue.InputQueueControllerTest;
	import mindmaps.models.search.SearcherTest;
	
	import mindmaps2.actions.element.CreateElementActionsTest;
	import mindmaps2.actions.element.SelectAndActOnElementTest;
	import mindmaps2.actions.UserActionCollectorTest;
	import mindmaps2.actions.UserTriggeredActionTest;
	
	import persistence.*;
	
	
	public class TestControlObjectsTests
	{		
		public function createCurrentTests():TestSuite
		{
			var ts:TestSuite = new TestSuite();
			ts.addTestSuite(CreateElementActionsTest);
			ts.addTestSuite(SelectAndActOnElementTest);
			ts.addTestSuite(UserTriggeredActionTest);
			ts.addTestSuite(ActionContainerDecoratorTest);
			//ts.addTest(SelectAndActOnElementTest.suite());
			return ts;
		}		
		
		public function createAllTests():TestSuite
		{
 			var ts:TestSuite = new TestSuite();
 			ts.addTestSuite(UserActionCollectorTest);
			//ts.addTestSuite(MenuAssemblerTest);
			ts.addTestSuite(TaskServiceTest);
			ts.addTestSuite(RankTasksTest);
			ts.addTestSuite( SearcherTest);
			ts.addTestSuite(MapTextExporterTest);
			
			ts.addTestSuite(HistoryManagerTest);
			//ts.addTestSuite(OperationRepositoryTest);
			ts.addTestSuite(HistoryControllerTest);
			ts.addTestSuite(PrioritizeLeafTasksHierarchicallyQueryTest);
			
 			ts.addTestSuite( SearcherTest);
 			ts.addTestSuite(InputQueueControllerTest);
 			
 			ts.addTestSuite(TreeToSubwayConverterTest);
			ts.addTestSuite(LineTest);
			ts.addTestSuite(LineIteratorTest);
			ts.addTestSuite(SubwayTest);
			ts.addTestSuite(SubwayLayouterTest);
			ts.addTestSuite(ProjectParserTest);
			ts.addTestSuite(SubwayFactoryTest);
			ts.addTestSuite(SubwayLayoutTest);
			
 			return ts;
 		}
	}
}