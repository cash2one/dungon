package com.leyou.ui.dungeonTeam.childs {


	import com.ace.config.Core;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.net.cmd.Cmd_CpTm;
	
	import flash.events.MouseEvent;

	public class DungeonTeam1Team extends AutoSprite {

		private var createBtn:NormalButton;
		private var enterBtn:NormalButton;
		private var addCb:CheckBox;
		private var itemList:ScrollPane;

		private var itemsList:Vector.<DungeonTeam1TeamBar>

		private var data:Array=[];

		private var myTeam:Boolean=false;
		private var count:int=0;
		private var level:int=0;

		public function DungeonTeam1Team() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeam/dungeonTeam1Team.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;

//			this.scrollRect=new Rectangle(0, 0, 456, 446);
		}

		private function init():void {

			this.createBtn=this.getUIbyID("createBtn") as NormalButton;
			this.enterBtn=this.getUIbyID("enterBtn") as NormalButton;
			this.addCb=this.getUIbyID("addCb") as CheckBox;
			this.itemList=this.getUIbyID("itemList") as ScrollPane;

			this.createBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.enterBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.addCb.addEventListener(MouseEvent.CLICK, onClick);
//			this.itemList.addEventListener(MouseEvent.CLICK, onClick);

			this.itemsList=new Vector.<DungeonTeam1TeamBar>();
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "createBtn":
					UIManager.getInstance().showWindow(WindowEnum.DUNGEON_TEAM_CREATE);
					break;
				case "enterBtn":

					Cmd_CpTm.cmTeamCopyAdd(this.getEasyTeam());
					break;
				case "addCb":
					this.updateEasyList();
					break;
				case "itemList":
					break;
			}

		}

		private function updateEasyList():void {

			var data1:Array=[];
			if (this.addCb.isOn) {
				data1=data.filter(function(item:*, index:int, arr:Array):Boolean {
					if (item[3] == 0)
						return true;

					return false;
				});
			} else {
				data1=data;
			}

			this.updateList(data1);
		}

		public function updateInfo(o:Object, my:Boolean, count:int,level:int):void {

			this.myTeam=my;
			this.count=count;
			this.level=level;

			if (my || count <= 0 || Core.me.info.level<level) {
				this.createBtn.visible=false;
				this.enterBtn.visible=false;
			} else {
				this.createBtn.visible=true;
				this.enterBtn.visible=true;
			}

			this.data=o.team;
			this.updateList(this.data);

		}

		private function updateList(o:Array):void {

			var bar:DungeonTeam1TeamBar;
			for each (bar in this.itemsList) {
				if (bar != null)
					this.itemList.delFromPane(bar);
			}

			this.itemsList.length=0;

			for (var i:int=0; i < o.length; i++) {
				bar=new DungeonTeam1TeamBar();
				this.itemList.addToPane(bar);
				this.itemsList.push(bar);

				bar.updateInfo(o[i], this.level,this.count);

				bar.x=0;
				bar.y=78 * i;
			}
		}

		private function getEasyTeam():String {
			var a:Array;
			for each (a in this.data) {
				if (a[3] == 0)
					return a[0];
			}

			return "";
		}



	}
}
