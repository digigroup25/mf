package mindmaps.map.ui.tree {
	import actions.AbstractAction;

	import logging.LogUtil;

	import mapstorage.MapStorageContainer;

	import mf.framework.*;

	import mindmaps.map.MapContext;
	import mindmaps.map.ui.actions.messages.MapMessages;
	import mindmaps.map.ui.tree.containers.Main;
	import mindmaps.map.ui.tree.messages.TreeTabMessageFactory;
	import mindmaps.map.ui.tree.messages.TreeTabMessages;

	import mindmaps2.map.ui.MindMapMessages;
	import mindmaps2.storage.*;

	import mx.controls.RichTextEditor;
	import mx.logging.ILogger;

	public class MainContainer extends Container2 {

		private static const logger:ILogger = LogUtil.getLogger(MainContainer);

		public function MainContainer(view:Main, mapContext:MapContext, mb:IMessageBroker, rootAction:AbstractAction) {
			this.tabMessages = new TreeTabMessageFactory(this);
			this.mapStorageMessages = new MapStorageMessageFactory(this);
			tabContainer = new TreeTabContainer(view.mapArea, mb, rootAction);

			var mapStorageContainer:MapStorageContainer = new MapStorageContainer(view, mb, null, null, null, null, mapContext.nodeTypes, rootAction);
			super(mb, null, null, null, [ tabContainer, mapStorageContainer ]); //calling this ctor overrides view value to null
			//therefore set view here
			this.view = view;
			this.mapContext = mapContext;
			this.rootAction = rootAction;
			//thisView.addEventListener(Event.RESIZE, onResize);
		}

		protected var mapContext:MapContext;

		private var tabMessages:TreeTabMessageFactory;

		private var mapStorageMessages:MapStorageMessageFactory;

		private var tabContainer:IContainer;

		private var view:Object;

		private var rootAction:AbstractAction;

		/* private function showHideMapStorage(show:Boolean):void {
			thisView.mapStorage.visible = thisView.mapStorage.includeInLayout = show;
			//if (show) thisView.invalidateDisplayList();
		}

		private function onResize(e:Event):void {
			showHideMapStorage(thisView.width>=MIN_WIDTH);

		} */
		override public function receive(m:Message):void {
			switch (m.name) {
				case MapStorageMessages.GOT_MAP:
					logger.debug("receive: GOT_MAP");
					//treeContainer.send(treeTabMessageFactory.createOpenMap(m.body.map));
					//this.send(tabMessages.createOpenMap(m.body.map, rootAction));
					break;
				case TreeTabMessages.MAP_TAB_INDEX_CHANGED:
				case TreeTabMessages.TAB_CREATED:
					//update menu?
					break;
				case MindMapMessages.CLOSE_MAP:
					//this.send(new Message(TreeTabMessages.CLOSE_MAP_IN_TAB, this, m.body));
					break;
				case MapMessages.NEW_MAP:
					var newM:Message = mapStorageMessages.NewMap("New map");
					newM.body.doNotPersist = true;
					this.send(newM);
					break;

				/* case MapMessages.MINI_VIEW:
					showHideMapStorage(false); break;
				case MapMessages.MAX_VIEW:
					showHideMapStorage(true); break; */

				/* case MenuMessages.CLOSE_MAP:
					trace("treeappcontainer sending close msg");
					this.containers[0].send(m);
					break; */
				/* case MenuMessages.SAVE_MAP:
					trace("save map", this);
					break; */
				/* case MapMessages.MAP_RENAMED:
					break; */
				/*this.send(m);
				//this.send(treeTabMessageFactory.createRenameMap(m.body.map, m.body.oldMapName));
				break;  */
			}
		}

		protected function get thisView():Main {
			return Main(view);
		}

		override protected function doInitialize():void {
			super.doInitialize();
			//onResize(null);
		/* var fade:Fade = new Fade();
		fade.alphaFrom = 0;
		fade.alphaTo = 1;
		fade.duration = 2000;
		fade.play([view]); */
		}

		override protected function doUninitialize():void {

			/* var timer:Timer = new Timer(1500, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, uninit);
			timer.start();


			var fade:Fade = new Fade();
			fade.alphaFrom = 0;
			fade.alphaTo = 1;
			fade.duration = 2000;

			uninit();
		}

		private function uninit(event:TimerEvent=null):void {
			view=null;
			fade.play([view], true); */
			//thisView.removeEventListener(Event.RESIZE, onResize);
			mapContext = null;
			this.tabMessages = null;
			super.doUninitialize();
		}
	}
}
