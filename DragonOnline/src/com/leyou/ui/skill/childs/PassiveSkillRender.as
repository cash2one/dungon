package com.leyou.ui.skill.childs {
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TUnion_attribute;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.SwitchButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class PassiveSkillRender extends AutoSprite {

		private var iconImg:Image;
		private var skillNameLbl:Label;
		private var keyLbl:Label;
		private var valueLbl:Label;
		private var lvLbl:Label;
		private var stateBtn:SwitchButton;
		private var effSwf:SwfLoader;

		private var info:TUnion_attribute;

		public function PassiveSkillRender() {
			super(LibManager.getInstance().getXML("config/ui/skill/passiveSkillRender.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.skillNameLbl=this.getUIbyID("skillNameLbl") as Label;
			this.keyLbl=this.getUIbyID("keyLbl") as Label;
			this.valueLbl=this.getUIbyID("valueLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.stateBtn=this.getUIbyID("stateBtn") as SwitchButton;
			this.effSwf=this.getUIbyID("effSwf") as SwfLoader;

//			this.effSwf.update(99989);
			this.effSwf.update(99913);
			this.effSwf.visible=false;

			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}

		private function onMouseMove(e:MouseEvent):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_GUILD_SKILL, this.info, new Point(e.stageX, e.stageY));
			e.stopImmediatePropagation();
		}

		public function updateInfo(id:int):void {

			info=TableManager.getInstance().getguildAttributeInfo(id);

			this.iconImg.updateBmp("ico/skills/" + info.ico + ".png");
			this.skillNameLbl.text=info.name + "";
			this.keyLbl.text=PropUtils.propArr[int(info.att) - 1] + ":";
			this.valueLbl.text=info.uAtt + "";
			this.lvLbl.text=info.lv + "";



		}

		public function get infoData():TUnion_attribute {
			return this.info;
		}

		public function get att():int {
			if (this.info == null)
				return -1;

			return this.info.att;
		}

		public function get ico():int {
			if (this.info == null)
				return -1;

			return this.info.ico;
		}

		public function get money():int {
			if (this.info == null)
				return -1;

			return this.info.uMoney;
		}

		public function get lv():int {
			if (this.info == null)
				return -1;

			return this.info.lv;
		}

		public function get bg():int {
			if (this.info == null)
				return -1;

			return this.info.uCon;
		}

		public function get skillname():String {
			if (this.info == null)
				return null;

			return this.info.name;
		}


		public function set state(v:Boolean):void {
			if (v) {
				this.stateBtn.turnOn();
				this.effSwf.visible=true;
			} else {
				this.stateBtn.turnOff();
				this.effSwf.visible=false;
			}

		}

		public function get state():Boolean {
			return this.stateBtn.isOn
		}


	}
}
