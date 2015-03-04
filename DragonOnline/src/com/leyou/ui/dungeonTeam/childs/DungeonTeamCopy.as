package com.leyou.ui.dungeonTeam.childs {

	import com.ace.config.Core;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCopyInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.net.cmd.Cmd_CpTm;
	
	import flash.events.MouseEvent;
	import flash.utils.setInterval;

	public class DungeonTeamCopy extends AutoSprite {

		private var itemList:ScrollPane;
		private var ruleLbl:Label;

		private var teamItem:DungeonTeam1Render;

		private var itemsList:Vector.<DungeonTeam2Bar>

		private var selectIndex:int=-1;

		private var setTime:int=0;

		public function DungeonTeamCopy() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeam/dungeonTeamRender.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;

//			this.scrollRect=new Rectangle(0, 0, 456, 446);
		}

		private function init():void {
			this.itemList=this.getUIbyID("itemList") as ScrollPane;
			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;

			this.itemList.addEventListener(MouseEvent.CLICK, onClick);

			this.teamItem=new DungeonTeam1Render();
			this.addChild(this.teamItem);
			this.teamItem.x=418;
			this.teamItem.y=0;

			this.itemsList=new Vector.<DungeonTeam2Bar>();

//			var item:DungeonTeam2Bar;
//			for (var i:int=0; i < 6; i++) {
//
//				item=new DungeonTeam2Bar();
//
//				item.updateInfo([96 + i, 3, 5]);
//
//				this.itemList.addToPane(item);
//				this.itemsList.push(item);
//
//				item.x=0;
//				item.y=i * 77;
//			}
			
			this.ruleLbl.setToolTip(TableManager.getInstance().getSystemNotice(6612).content);

			this.x=-29;
			this.y=3;
		}

		private function onClick(e:MouseEvent):void {

			if (!(e.target is DungeonTeam2Bar))
				return;

			if (this.selectIndex != -1) {
				this.itemsList[this.selectIndex].setSelect(false);
			}

			this.selectIndex=this.itemsList.indexOf(e.target as DungeonTeam2Bar);

			if (this.selectIndex != -1) {

				if (!UIManager.getInstance().isCreate(WindowEnum.DUNGEON_TEAM_CREATE))
					UIManager.getInstance().creatWindow(WindowEnum.DUNGEON_TEAM_CREATE);

				UIManager.getInstance().teamCopyCreateWnd.setSelectItem(this.itemsList[this.selectIndex].id);

				Cmd_CpTm.cmTeamCopyTeam(this.itemsList[this.selectIndex].id);
				Cmd_CpTm.cmTeamCopyMy();
			}

			if (this.setTime == 0)
				this.setTime=setInterval(updateCurrentList, 5000);
		}

		public function updateCurrentList():void {
			if (this.selectIndex != -1) {
				Cmd_CpTm.cmTeamCopyTeam(this.itemsList[this.selectIndex].id);
			}
		}

		public function updateList(o:Object):void {
			if (this.selectIndex != -1) {
				this.itemsList[this.selectIndex].setSelect(true);

				this.teamItem.cpid=this.itemsList[this.selectIndex].id;
				this.teamItem.level=this.itemsList[this.selectIndex].level;
				this.teamItem.count=this.itemsList[this.selectIndex].count;

				this.teamItem.updateTeamList(o);
			}
		}

		public function updateMy(o:Object):void {
			this.teamItem.updatePlayList(o);
		}

		public function updateInfo(o:Object):void {

			var item:DungeonTeam2Bar;

			for each (item in this.itemsList) {
				if (item == null)
					this.itemList.delFromPane(item);
			}

			this.itemsList.length=0;

			for (var i:int=0; i < o.cplist.length; i++) {

				item=new DungeonTeam2Bar();

				item.updateInfo(o.cplist[i]);

				this.itemList.addToPane(item);
				this.itemsList.push(item);

				item.x=0;
				item.y=i * 77;
			}

			this.itemsList[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK));

			if (!UIManager.getInstance().isCreate(WindowEnum.DUNGEON_TEAM_CREATE))
				UIManager.getInstance().creatWindow(WindowEnum.DUNGEON_TEAM_CREATE);

			UIManager.getInstance().teamCopyCreateWnd.updateList(o.cplist);

		}


	}
}
