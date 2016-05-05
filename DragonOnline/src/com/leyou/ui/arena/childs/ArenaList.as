package com.leyou.ui.arena.childs {


	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.tabbar.TabbarModel;
	import com.leyou.net.cmd.Cmd_Arena;

	import flash.events.MouseEvent;

	public class ArenaList extends AutoWindow {

		private var fullCb:RadioButton;
		private var rightCb:RadioButton;
		private var failCb:RadioButton;

		private var itemList:ScrollPane;

		private var logList:Array=[];

		private var logRenderVec:Vector.<ArenaListRender>;

		public function ArenaList() {
			super(LibManager.getInstance().getXML("config/ui/arena/arenaList.xml"));
			this.init();
//			this.clsBtn.y-=10;
		}

		private function init():void {
			this.fullCb=this.getUIbyID("fullCb") as RadioButton;
			this.rightCb=this.getUIbyID("rightCb") as RadioButton;
			this.failCb=this.getUIbyID("failCb") as RadioButton;

			this.itemList=this.getUIbyID("itemList") as ScrollPane;

			this.fullCb.addEventListener(MouseEvent.CLICK, onClick);
			this.rightCb.addEventListener(MouseEvent.CLICK, onClick);
			this.failCb.addEventListener(MouseEvent.CLICK, onClick);

			this.logRenderVec=new Vector.<ArenaListRender>();

			this.fullCb.turnOn();
		}

		private function onClick(e:MouseEvent):void {
			this.updateList();
		}

		/**
		 *	-- ftime     战斗时间戳秒
		  -- fresult   战斗结果 (1胜利 0失败 )
		  -- fscore    积分
		  -- fname     战斗对象名称
		  -- frev      是否可复仇(0可复仇，1不可复仇)
		 * @param o
		 *
		 */
		public function updateInfo(o:Object):void {

			if (o.hasOwnProperty("rlist")) {

				this.logList=o.rlist;
//				this.logList.reverse();
				UIManager.getInstance().arenaWnd.updateLog(o.rlist);
				this.updateList();
			}

		}

		private function updateList():void {

			var render:ArenaListRender;

			for each (render in this.logRenderVec) {
				this.itemList.delFromPane(render);
			}

			this.logRenderVec.length=0;

			for (var i:int=0; i < this.logList.length; i++) {

				if ((this.rightCb.isOn && this.logList[i][1] != 1) || (this.failCb.isOn && this.logList[i][1] != 0))
					continue;

				render=new ArenaListRender();

				render.setContentTxt(this.logList[i]);
				render.y=this.logRenderVec.length * 30;

				this.itemList.addToPane(render);
				this.logRenderVec.push(render);
			}

		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			Cmd_Arena.cm_ArenaRecord(50);
		}


	}
}
