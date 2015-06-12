package com.leyou.ui.dungeonTeam.childs {

	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.PlayerEnum;
	import com.ace.game.scene.player.part.LivingBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDungeon_Base;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.SOLManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	import com.leyou.net.cmd.Cmd_Ucp;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TimeUtil;

	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class DungeonTGuildRender extends AutoSprite {

		private var enterBtn:ImgButton;
		private var timeLbl:Label;
		private var descLbl:Label;
		private var nameLbl:Label;
		private var getLbl:Label;
		private var enterStateImg:Image;
		private var ytgImg:Image;
		private var succImg:Image;
		private var lockImg:Image;
		private var viewCb:CheckBox;

		private var itemList:ScrollPane;

		private var itemRenderArr:Vector.<DungeonTGuildBtn>

		private var rewardDropArr:Vector.<TeamCopyGrid>;
		private var rewardBossArr:Vector.<TeamCopyGrid>;
		private var rewardFirstArr:Vector.<TeamCopyGrid>;

		private var currentCid:int=-1;

		private var currentIndex:int=-1;

		private var itemSwfVec:Vector.<SwfLoader>

		public function DungeonTGuildRender() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeam/dungeonTGuildRender.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.enterBtn=this.getUIbyID("enterBtn") as ImgButton;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.getLbl=this.getUIbyID("getLbl") as Label;
			this.viewCb=this.getUIbyID("viewCb") as CheckBox;
			this.enterStateImg=this.getUIbyID("enterStateImg") as Image;
			this.ytgImg=this.getUIbyID("ytgImg") as Image;
			this.lockImg=this.getUIbyID("lockImg") as Image;
			this.succImg=this.getUIbyID("succImg") as Image;

			this.enterBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.viewCb.addEventListener(MouseEvent.CLICK, onViewClick);

			this.itemRenderArr=new Vector.<DungeonTGuildBtn>();

			this.rewardDropArr=new Vector.<TeamCopyGrid>();
			this.rewardBossArr=new Vector.<TeamCopyGrid>();
			this.rewardFirstArr=new Vector.<TeamCopyGrid>();

			var obj:Object=SOLManager.getInstance().readCookie("guildCopyViewWin");

			if (obj != null && obj.hasOwnProperty("st")) {
				if (obj.st == 1)
					this.viewCb.turnOn()
				else
					this.viewCb.turnOff();
			} else
				this.viewCb.turnOn();

			this.itemSwfVec=new Vector.<SwfLoader>();

			this.scrollRect=new Rectangle(0, 0, 770, 396);

			this.x=-27;
			this.y=4;
		}

		private function updateData():void {



		}

		private function onViewClick(e:MouseEvent):void {
			SOLManager.getInstance().saveCookie("guildCopyViewWin", {"st": (this.viewCb.isOn ? 1 : 0)});
		}

		public function get isOn():Boolean {
			return this.viewCb.isOn;
		}

		private function onClick(e:MouseEvent):void {

			if (this.currentCid != -1)
				Cmd_Ucp.cm_GuildCpEnter(this.currentCid);

		}

		private function onItemClick(e:MouseEvent):void {

			var render:DungeonTGuildBtn=e.target.parent as DungeonTGuildBtn;
			if (render == null || this.currentIndex == this.itemRenderArr.indexOf(render))
				return;

			if (this.currentIndex != -1)
				this.itemRenderArr[this.currentIndex].y=-40;

			this.currentCid=-1;
			this.currentIndex=this.itemRenderArr.indexOf(render);

			var data:Object=render.data;

			if (data.hasOwnProperty("funame") && data.funame != null && data.funame != "") {
				this.getLbl.htmlText=StringUtil.substitute(PropUtils.getStringById(1692), ["<font color='#00ff00'>" + data.funame + "</font>"]);
				this.ytgImg.visible=true;
			} else {
				this.getLbl.text="";
				this.ytgImg.visible=false;
			}

			this.currentCid=data.cid;
//			render.setSelect(true);

			var info:TDungeon_Base=TableManager.getInstance().getGuildCopyInfo(data.cid);

			if (info == null)
				return;

			this.nameLbl.text=info.Dungeon_Name + "";

			var str:String="";
			var arr:Array=info.Key_Week.split("|");
			for (var i:int=0; i < arr.length; i++) {

				str+=TimeUtil.getWeekStringByInt(arr[i]);

				if (info.Key_Hour == null) {
					str+=PropUtils.getStringById(1693);
				} else
					str+=" " + info.Key_Hour.replace("|", "-").replace(/(\d\d)\,(\d\d)\,(\d\d)\-(\d\d)\,(\d\d)\,(\d\d)/g, "$1:$2\-$4:$5") + "\n";

			}

			var sl:SwfLoader;
			for each (sl in this.itemSwfVec) {
				if (sl != null)
					this.removeChild(sl);
			}

			this.itemSwfVec.length=0;

			var _x:int=282;

			var c:int=0;
			var d:int=0;
			var dbArr:Array=info.DB_Monster.split("|");
			var pinfo:TLivingInfo;
			if (dbArr != null) {
				for (i=0; i < dbArr.length; i++) {

					if (i >= 3)
						break;

					pinfo=TableManager.getInstance().getLivingInfo(dbArr[i]);
					if (pinfo == null)
						continue;

					sl=new SwfLoader(pinfo.pnfId);
					sl.playAct(PlayerEnum.ACT_STAND, PlayerEnum.DIR_S);
					this.addChild(sl);

					this.itemSwfVec.push(sl);

					if (i == 0) {
						sl.y=339;
						sl.x=_x;

						d++;
					} else {

						sl.y=339 - d * 80;

						if (c % 2 == 0) {

							sl.x=_x - d * 150;

						} else {

							sl.x=_x + d * 150;
						}


						if (c % 2 != 0) {

							d++;
						}
						c++;
					}
				}
			}

			var grender:DungeonTGuildBtn;
			for each (grender in this.itemRenderArr) {
				this.addChild(grender);
			}

			this.timeLbl.text=str + "";
			this.descLbl.text=info.Dungeon_Des + "";

			this.updateDropGrid(info);
			this.updateBossGrid(info);
			this.updateFirstGrid(info);

			this.succImg.visible=false;

			//st:副本状态 (0未解锁 1已解锁 2未通关 3已通关,4 未开启)
			if (data.st == 0 || data.st == 3 || data.st == 4) {
				this.enterBtn.setActive(false, .6, true);

				if (data.st == 3) {
					this.enterStateImg.updateBmp("ui/guild/btn_ytg.png");
					this.succImg.visible=true;
				} else {
					this.enterStateImg.updateBmp("ui/guild/btn_jrfb.png");
					this.succImg.visible=false;
				}

			} else
				this.enterBtn.setActive(true, 1, true);

			if (!data.hasOwnProperty("st") || data.st == 0) {
				this.lockImg.visible=true;
			} else {
				this.lockImg.visible=false;
			}

			this.addChild(this.succImg)
			this.addChild(this.lockImg)

		}

		private function updateDropGrid(info:TDungeon_Base):void {

			var render:TeamCopyGrid;
			for each (render in this.rewardDropArr) {
				this.removeChild(render);
			}

			this.rewardDropArr.length=0;

			var str:Array=info.Base_Drop.split("|");
			var ctx:Array=[];

			for (var i:int=0; i < str.length; i++) {

				ctx=str[i].split(",");

				render=new TeamCopyGrid();
				render.updataInfo(TableManager.getInstance().getItemInfo(int(ctx[0])));
				render.canMove=false;

				if (ctx.length == 2)
					render.setTipsNum(int(ctx[1]));

				if (int(ctx[1]) > 1)
					render.setNum((ctx[1]));

				render.y=141;
				render.x=568 + i * render.width;

				this.addChild(render);
				this.rewardDropArr.push(render);

			}

		}

		private function updateBossGrid(info:TDungeon_Base):void {

			var render:TeamCopyGrid;
			for each (render in this.rewardBossArr) {
				this.removeChild(render);
			}

			this.rewardBossArr.length=0;
			var _x:int=568;

			var str:Array=info.Boss_Drop.split("|");
			var ctx:Array=[];

			for (var i:int=0; i < str.length; i++) {

				ctx=str[i].split(",");

				render=new TeamCopyGrid();
				render.updataInfo(TableManager.getInstance().getItemInfo(int(ctx[0])));
				render.canMove=false;

				if (ctx.length == 2) {
					render.setTipsNum(int(ctx[1]));
				}

				if (int(ctx[1]) > 1)
					render.setNum((ctx[1]));

				render.y=211;
				render.x=568 + i * render.width;

				this.addChild(render);
				this.rewardBossArr.push(render);

			}

		}

		private function updateFirstGrid(info:TDungeon_Base):void {

			var render:TeamCopyGrid;
			for each (render in this.rewardFirstArr) {
				this.removeChild(render);
			}

			this.rewardFirstArr.length=0;

			var _x:int=568;
			var _y:int=281;

			if (info.First_Exp > 0) {

				render=new TeamCopyGrid();
				render.updataInfo(TableManager.getInstance().getItemInfo(65534));
				render.setNum(info.First_Exp + "");
				render.setTipsNum(info.First_Exp);
				render.y=_y;
				render.x=_x + this.rewardFirstArr.length * render.width;

				this.addChild(render);
				this.rewardFirstArr.push(render);
			}

			if (info.First_energy > 0) {

				render=new TeamCopyGrid();
				render.updataInfo(TableManager.getInstance().getItemInfo(65533));
				render.setNum(info.First_energy + "");
				render.setTipsNum(info.First_energy);

				render.y=_y;
				render.x=_x + this.rewardFirstArr.length * render.width;

				this.addChild(render);
				this.rewardFirstArr.push(render);
			}

			if (info.First_Money > 0) {

				render=new TeamCopyGrid();
				render.updataInfo(TableManager.getInstance().getItemInfo(65535));
				render.setNum(info.First_Money + "");
				render.setTipsNum(info.First_Money);

				render.y=_y;
				render.x=_x + this.rewardFirstArr.length * render.width;

				this.addChild(render);
				this.rewardFirstArr.push(render);
			}

			if (info.First_Item1 > 0) {

				render=new TeamCopyGrid();
				render.updataInfo(TableManager.getInstance().getItemInfo(int(info.First_Item1)));
				render.setNum(info.Fitem_Num1 + "");

				render.y=_y;
				render.x=_x + this.rewardFirstArr.length * render.width;

				this.addChild(render);
				this.rewardFirstArr.push(render);
			}

			if (info.First_Item2 > 0) {

				render=new TeamCopyGrid();
				render.updataInfo(TableManager.getInstance().getItemInfo(int(info.First_Item2)));
				render.setNum(info.Fitem_Num2 + "");

				render.y=_y;
				render.x=_x + this.rewardFirstArr.length * render.width;

				this.addChild(render);
				this.rewardFirstArr.push(render);
			}

		}

		public function updateInfo(o:Object):void {

			var render:DungeonTGuildBtn;
//			for each (render in this.itemRenderArr) {
//				this.removeChild(render);
//			}
//
//			this.itemRenderArr.length=0;

			if (o.hasOwnProperty("cl")) {

				var obj:Object;
				var info:TDungeon_Base;

				var i:int;
				var ctx:Array=o.cl;

//				ctx.reverse();

//				var isactive:int=(this.currentIndex != -1 ? this.currentIndex : ctx.length - 1);

				for each (obj in ctx) {

					if (this.itemRenderArr.length > i) {
						render=this.itemRenderArr[i];
					} else {
						render=new DungeonTGuildBtn();

						render.x=10 + i * 58;
						render.y=-40;

						render.addEventListener(MouseEvent.CLICK, onItemClick);
						render.addEventListener(MouseEvent.MOUSE_OVER, onItemOver);
						render.addEventListener(MouseEvent.MOUSE_OUT, onItemOut);

						this.addChild(render);
						this.itemRenderArr.push(render);
					}

					render.updateInfo(obj, i);

//					if (obj.st == 1 || obj.st == 2)
//						isactive=i;

					i++;
				}

				if (this.itemRenderArr.length > 0) {


					this.itemRenderArr[0].getChildAt(0).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					this.itemRenderArr[0].y=0;


				}

			}
		}

		private function onItemOver(e:MouseEvent):void {
			if (e.target.parent is DungeonTGuildBtn)
				e.target.parent.y=0
		}

		private function onItemOut(e:MouseEvent):void {
			if (this.currentIndex != this.itemRenderArr.indexOf(e.target.parent as DungeonTGuildBtn) && e.target.parent is DungeonTGuildBtn)
				e.target.parent.y=-40;
		}


	}
}
