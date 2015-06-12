package com.leyou.ui.guild.child {

	import com.ace.delayCall.DelayCallManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDungeon_Base;
	import com.ace.manager.LibManager;
	import com.ace.manager.SOLManager;
	import com.ace.manager.UIManager;
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

	public class GuildDungeon extends AutoSprite {

		private var enterBtn:ImgButton;
		private var timeLbl:Label;
		private var descLbl:Label;
		private var nameLbl:Label;
		private var getLbl:Label;
		private var enterStateImg:Image;
		private var ytgImg:Image;
		private var viewCb:CheckBox;

		private var itemList:ScrollPane;

		private var itemRenderArr:Vector.<GuildDungeonRender>

		private var rewardDropArr:Vector.<GuildGrild>;
		private var rewardBossArr:Vector.<GuildGrild>;
		private var rewardFirstArr:Vector.<GuildGrild>;

		private var currentCid:int=-1;

		private var currentIndex:int=-1;

		public function GuildDungeon() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildDungeon.xml"));
//			super(LibManager.getInstance().getXML("config/ui/guild/dungeonTGuildRender.xml"));
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
			this.itemList=this.getUIbyID("itemList") as ScrollPane;

			this.itemList.addEventListener(MouseEvent.CLICK, onItemClick);
			this.enterBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.viewCb.addEventListener(MouseEvent.CLICK, onViewClick);

			this.itemRenderArr=new Vector.<GuildDungeonRender>();

			this.rewardDropArr=new Vector.<GuildGrild>();
			this.rewardBossArr=new Vector.<GuildGrild>();
			this.rewardFirstArr=new Vector.<GuildGrild>();

			var obj:Object=SOLManager.getInstance().readCookie("guildCopyViewWin");

			if (obj != null && obj.hasOwnProperty("st")) {
				if (obj.st == 1)
					this.viewCb.turnOn()
				else
					this.viewCb.turnOff();
			} else
				this.viewCb.turnOn();

			this.x=-17;
			this.y=1;
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

			if (this.currentIndex != -1)
				this.itemRenderArr[this.currentIndex].setSelect(false);

			this.currentCid=-1;
			this.currentIndex=this.itemRenderArr.indexOf(e.target as GuildDungeonRender);

			var render:GuildDungeonRender=e.target as GuildDungeonRender;
			if (render == null)
				return;

			var data:Object=render.data;

			if (data.hasOwnProperty("funame") && data.funame != null && data.funame != "") {
				this.getLbl.htmlText=StringUtil.substitute(PropUtils.getStringById(1692), ["<font color='#00ff00'>" + data.funame + "</font>"]);
				this.ytgImg.visible=true;
			} else {
				this.getLbl.text="";
				this.ytgImg.visible=false;
			}

			this.currentCid=data.cid;
			render.setSelect(true);

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

			this.timeLbl.text=str + "";
			this.descLbl.text=info.Dungeon_Des + "";

			this.updateDropGrid(info);
			this.updateBossGrid(info);
			this.updateFirstGrid(info);

//			st:副本状态 (0未解锁 1已解锁 2未通关 3已通关,4 未开启)
			if (data.st == 0 || data.st == 3 || data.st == 4) {
				this.enterBtn.setActive(false, .6, true);

				if (data.st == 3) {
					this.enterStateImg.updateBmp("ui/guild/btn_ytg.png");
				} else {
					this.enterStateImg.updateBmp("ui/guild/btn_jrfb.png");
				}

			} else
				this.enterBtn.setActive(true, 1, true);
		}

		private function updateDropGrid(info:TDungeon_Base):void {

			var render:GuildGrild;
			for each (render in this.rewardDropArr) {
				this.removeChild(render);
			}

			this.rewardDropArr.length=0;

			var str:Array=info.Base_Drop.split("|");
			var ctx:Array=[];

			for (var i:int=0; i < str.length; i++) {

				ctx=str[i].split(",");

				render=new GuildGrild();
				render.updataInfo(TableManager.getInstance().getItemInfo(int(ctx[0])));
				render.canMove=false;

				if (ctx.length == 2)
					render.setTipsNum(int(ctx[1]));

				if (int(ctx[1]) > 1)
					render.setNum((ctx[1]));

				render.y=221;
				render.x=410 + i * render.width;

				this.addChild(render);
				this.rewardDropArr.push(render);

			}

		}

		private function updateBossGrid(info:TDungeon_Base):void {

			var render:GuildGrild;
			for each (render in this.rewardBossArr) {
				this.removeChild(render);
			}

			this.rewardBossArr.length=0;

			var str:Array=info.Boss_Drop.split("|");
			var ctx:Array=[];

			for (var i:int=0; i < str.length; i++) {

				ctx=str[i].split(",");

				render=new GuildGrild();
				render.updataInfo(TableManager.getInstance().getItemInfo(int(ctx[0])));
				render.canMove=false;

				if (ctx.length == 2) {
					render.setTipsNum(int(ctx[1]));
				}

				if (int(ctx[1]) > 1)
					render.setNum((ctx[1]));

				render.y=144;
				render.x=410 + i * render.width;

				this.addChild(render);
				this.rewardBossArr.push(render);

			}

		}

		private function updateFirstGrid(info:TDungeon_Base):void {

			var render:GuildGrild;
			for each (render in this.rewardFirstArr) {
				this.removeChild(render);
			}

			this.rewardFirstArr.length=0;

			if (info.First_Exp > 0) {

				render=new GuildGrild();
				render.updataInfo(TableManager.getInstance().getItemInfo(65534));
				render.setNum(info.First_Exp + "");
				render.setTipsNum(info.First_Exp);
				render.y=293;
				render.x=410 + this.rewardFirstArr.length * render.width;

				this.addChild(render);
				this.rewardFirstArr.push(render);
			}

			if (info.First_energy > 0) {

				render=new GuildGrild();
				render.updataInfo(TableManager.getInstance().getItemInfo(65533));
				render.setNum(info.First_energy + "");
				render.setTipsNum(info.First_energy);

				render.y=293;
				render.x=410 + this.rewardFirstArr.length * render.width;

				this.addChild(render);
				this.rewardFirstArr.push(render);
			}

			if (info.First_Money > 0) {

				render=new GuildGrild();
				render.updataInfo(TableManager.getInstance().getItemInfo(65535));
				render.setNum(info.First_Money + "");
				render.setTipsNum(info.First_Money);

				render.y=293;
				render.x=410 + this.rewardFirstArr.length * render.width;

				this.addChild(render);
				this.rewardFirstArr.push(render);
			}

			if (info.First_Item1 > 0) {

				render=new GuildGrild();
				render.updataInfo(TableManager.getInstance().getItemInfo(int(info.First_Item1)));
				render.setNum(info.Fitem_Num1 + "");

				render.y=293;
				render.x=410 + this.rewardFirstArr.length * render.width;

				this.addChild(render);
				this.rewardFirstArr.push(render);
			}

			if (info.First_Item2 > 0) {

				render=new GuildGrild();
				render.updataInfo(TableManager.getInstance().getItemInfo(int(info.First_Item2)));
				render.setNum(info.Fitem_Num2 + "");

				render.y=293;
				render.x=410 + this.rewardFirstArr.length * render.width;

				this.addChild(render);
				this.rewardFirstArr.push(render);
			}

		}

		public function updateInfo(o:Object):void {

			var render:GuildDungeonRender;
			for each (render in this.itemRenderArr) {
				this.itemList.delFromPane(render);
			}

			this.itemRenderArr.length=0;

			if (o.hasOwnProperty("cl")) {

				var obj:Object;
				var info:TDungeon_Base;

				var i:int;
				var ctx:Array=o.cl;

				ctx.reverse();

				var isactive:int=(this.currentIndex != -1 ? this.currentIndex : ctx.length - 1);

				for each (obj in ctx) {

					render=new GuildDungeonRender();

					render.updateInfo(obj);

					if (i % 2 == 0) {
						render.x=199;
						render.y=40 + int(i / 2) * 387;
					} else {
						render.y=40 + i * (387 / 2);
					}

					this.itemList.addToPane(render);
					this.itemRenderArr.push(render);

					if (obj.st == 1 || obj.st == 2)
						isactive=i;

					i++;
				}

				if (this.itemRenderArr.length > isactive)
					this.itemRenderArr[isactive].dispatchEvent(new MouseEvent(MouseEvent.CLICK));


				DelayCallManager.getInstance().add(this, this.itemList.updateUI, "updateUI", 4);
				this.itemList.scrollTo(1);
			}
		}

	}
}
