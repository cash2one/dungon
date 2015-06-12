package com.leyou.ui.fieldBoss.chlid {
	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFieldBossInfo;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.data.fieldboss.FieldBossInfo;
	import com.leyou.data.fieldboss.FieldBossTipInfo;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.utils.PropUtils;

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class FieldBossRender extends AutoSprite {
		private var refreshLbl:Label;

		private var refreshedLbl:Label;

		private var nameLbl:Label;

		private var flyBtn:ImgButton;

		private var challengeBtn:NormalButton;

		private var big:SwfLoader;

		private var remindCbx:CheckBox;

		private var tipInfo:FieldBossTipInfo;

		private var _bossId:int;

		private var _listener:Function;

		public function FieldBossRender() {
			super(LibManager.getInstance().getXML("config/ui/fieldBoss/dungeonBossOutRender.xml"));
			init();
		}

		public function setRemindListener(fun:Function):void {
			_listener=fun;
		}

		public function get bossId():int {
			return _bossId;
		}

		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;

			tipInfo=new FieldBossTipInfo();
			big=new SwfLoader();
			big.mouseEnabled=false;
			big.x=100;
			big.y=265;
			addChildAt(big, 1);
//			big.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			nameLbl=getUIbyID("nameLbl") as Label;
			flyBtn=getUIbyID("flyBtn") as ImgButton;
			refreshLbl=getUIbyID("refreshLbl") as Label;
			refreshedLbl=getUIbyID("refreshedLbl") as Label;
			remindCbx=getUIbyID("remindCbx") as CheckBox;
			challengeBtn=getUIbyID("challengeBtn") as NormalButton;

			remindCbx.addEventListener(MouseEvent.CLICK, onMouseClick);
			flyBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			challengeBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

			var sp:Sprite=new Sprite();
			var g:Graphics=sp.graphics;
			g.beginFill(0, 0);
			g.drawRect(0, 0, 155, 270);
			g.endFill();
			addChild(sp);
			sp.x=30;
			sp.y=10;
			sp.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}

		protected function onMouseOver(event:MouseEvent):void {
			var info:FieldBossInfo=DataManager.getInstance().fieldBossData.getBossInfo(_bossId);
			if (null == info)
				return;
			tipInfo.bossId=_bossId;
			if ((null == info.killName) || ("" == info.killName)) {
				tipInfo.killName=PropUtils.getStringById(1652);
			} else {
				tipInfo.killName=info.killName;
			}
			if (0 == info.status) {
				// 未刷新
				tipInfo.status=getCurrentRT() + PropUtils.getStringById(1653);
			} else if (1 == info.status) {
				// 已刷新
				tipInfo.status=PropUtils.getStringById(1650);
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_FIELD_BOSS, tipInfo, new Point(stage.mouseX, stage.mouseY));
		}

		protected function onMouseClick(event:MouseEvent):void {
			var bossInfo:TFieldBossInfo=TableManager.getInstance().getFieldBossInfo(_bossId);
			var point:TPointInfo;
			var n:String=event.target.name;
			switch (n) {
				case "flyBtn":
					point=TableManager.getInstance().getPointInfo(bossInfo.pointId);
					Cmd_Go.cmGoPoint(int(bossInfo.sceneId), point.tx, point.ty);
					break;
				case "challengeBtn":
					point=TableManager.getInstance().getPointInfo(bossInfo.pointId);
					Core.me.gotoMap(new Point(point.tx, point.ty), bossInfo.sceneId, true);
					break;
				case "remindCbx":
					if (null != _listener) {
						_listener.call(this, this, remindCbx.isOn);
					}
					break;
			}
		}

		private function getCurrentRT():String {
			var bossInfo:TFieldBossInfo=TableManager.getInstance().getFieldBossInfo(_bossId);
			var timeArr:Array=bossInfo.refreshTimes;
			var tl:int=timeArr.length;
			var date:Date=new Date();
			var ct:int=date.hours * 60 * 60 + date.minutes * 60 + date.seconds;
			for (var n:int=0; n < tl; n++) {
				var tArr:Array=timeArr[n].split(",");
				var rt:int=int(tArr[0]) * 60 * 60 + int(tArr[1]) * 60 + int(tArr[2]);
				if (ct < rt) {
					return tArr.join(":");
				}
			}
			var pa:RegExp=/,/g;
			return timeArr[0].replace(pa, ":");
		}

		public function updateInfoByTable(table:TFieldBossInfo):void {
			_bossId=table.id;
			var monsterInfo:TLivingInfo=TableManager.getInstance().getLivingInfo(table.monsterId);
			nameLbl.text=monsterInfo.name + "[lv" + monsterInfo.level + "]";
			big.update(monsterInfo.pnfId);
			big.playAct(PlayerEnum.ACT_STAND, PlayerEnum.DIR_S);
		}

		public function updateInfo(info:FieldBossInfo):void {
			if (0 == info.status) {
				// 未刷新
				refreshLbl.visible=true;
				refreshedLbl.visible=false;
				refreshLbl.text=getCurrentRT() + PropUtils.getStringById(1653);
			} else if (1 == info.status) {
				// 已刷新
				refreshLbl.visible=false;
				refreshedLbl.visible=true;
			}
		}

		public function setRemind(v:Boolean):void {
			v ? remindCbx.turnOn(false) : remindCbx.turnOff(false);
		}
	}
}
