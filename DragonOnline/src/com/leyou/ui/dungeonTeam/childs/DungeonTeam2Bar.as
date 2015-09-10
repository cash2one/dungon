package com.leyou.ui.dungeonTeam.childs {


	import com.ace.config.Core;
	import com.ace.enum.FontEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCopyInfo;
	import com.ace.gameData.table.TDungeon_Base;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.FilterUtil;

	import flash.events.MouseEvent;

	public class DungeonTeam2Bar extends AutoSprite {

		private var nameLbl:Label;
		private var lvLbl:Label;
		private var countLbl:Label;

		private var overImg:Image;
		private var outImg:Image;

		public var seleceted:Boolean=false;

		public var id:int=0;

		public var baseGrid:TeamCopyGrid;

		public var dbGridVec:Vector.<TeamCopyGrid>;

		public function DungeonTeam2Bar() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeam/dungeonTeam2Bar.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;

//			this.scrollRect=new Rectangle(0, 0, 456, 446);
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.countLbl=this.getUIbyID("countLbl") as Label;

			this.overImg=this.getUIbyID("overImg") as Image;
			this.outImg=this.getUIbyID("outImg") as Image;

			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.overImg.visible=false;

			this.baseGrid=new TeamCopyGrid();
			this.addChild(this.baseGrid);

			this.baseGrid.x=111;
			this.baseGrid.y=25;

			this.baseGrid.higtEffect=this.dispEvent;

			this.dbGridVec=new Vector.<TeamCopyGrid>();

			var tgrid:TeamCopyGrid;
			for (var i:int=0; i < 4; i++) {
				tgrid=new TeamCopyGrid();

				this.addChild(tgrid);
				this.dbGridVec.push(tgrid);

				tgrid.higtEffect=this.dispEvent;

				tgrid.x=197 + i * 45;
				tgrid.y=25;
			}


		}

		private function onMouseOver(e:MouseEvent):void {
			this.overImg.visible=true;
		}

		private function onMouseOut(e:MouseEvent):void {
			if (!this.seleceted) {
				this.overImg.visible=false;
			}
		}

		public function setSelect(v:Boolean):void {
			this.seleceted=v;
			if (this.seleceted) {
				this.overImg.visible=true;
			} else {
				this.overImg.visible=false;
			}
		}

		public function updateInfo(o:Object):void {
			var tcopyinfo:TDungeon_Base=TableManager.getInstance().getGuildCopyInfo(o[0])
			if (tcopyinfo == null)
				return;
//
//			if (Core.me.info.level < tcopyinfo.Key_Level || int(o[1]) <= 0)
//				this.filters=[FilterUtil.enablefilter];
//			else
//				this.filters=[];

			this.id=o[0];
			this.nameLbl.text="" + tcopyinfo.Dungeon_Name;

			if (Core.me.info.level >= tcopyinfo.Key_Level)
				this.lvLbl.defaultTextFormat=FontEnum.getTextFormat("DefaultFont");
			else
				this.lvLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");

			this.lvLbl.text="" + tcopyinfo.Key_Level;

			if (int(o[1]) > 0)
				this.countLbl.defaultTextFormat=FontEnum.getTextFormat("DefaultFont");
			else
				this.countLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");

			this.countLbl.text="" + int(o[1]);

			if (tcopyinfo.Base_Drop == "") {
				this.baseGrid.visible=false;
			} else {
				this.baseGrid.visible=true;

				if (String(tcopyinfo.Base_Drop.split("|")[0].split(",")[0]).length == 4)
					this.baseGrid.updataInfo(TableManager.getInstance().getEquipInfo(int(tcopyinfo.Base_Drop.split("|")[0].split(",")[0])));
				else
					this.baseGrid.updataInfo(TableManager.getInstance().getItemInfo(int(tcopyinfo.Base_Drop.split("|")[0].split(",")[0])));
			}

			var ctx:Array=[];
			var render:TeamCopyGrid;

			for (var i:int=0; i < 4; i++) {

				ctx=tcopyinfo["DBC_ITEM" + (i + 1)].split(",");

				render=this.dbGridVec[i] as TeamCopyGrid;
				if (String(ctx[0]).length == 4)
					render.updataInfo(TableManager.getInstance().getEquipInfo(int(ctx[0])));
				else
					render.updataInfo(TableManager.getInstance().getItemInfo(int(ctx[0])));

				render.canMove=false;

				if (ctx.length == 2)
					render.setTipsNum(int(ctx[1]));

				if (int(ctx[1]) > 1)
					render.setNum((ctx[1]));

			}

		}

		public function dispEvent():void {
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		public function get level():int {
			return int(this.lvLbl.text);
		}

		public function get count():int {
			return int(this.countLbl.text);
		}


	}
}
