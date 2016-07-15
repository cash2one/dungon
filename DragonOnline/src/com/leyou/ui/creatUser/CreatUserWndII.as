package com.leyou.ui.creatUser {
	import com.ace.enum.PlayerEnum;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.tools.MathTools;
	import com.ace.utils.XmlUtil;

	import flash.events.MouseEvent;



	public class CreatUserWndII extends CreatUserModel {

		private var avtArr:Vector.<CreatUserAvatar>=new Vector.<CreatUserAvatar>;
		private var xml:XML;

		public function CreatUserWndII() {
			this.xml=LibManager.getInstance().getXML("config/ui/CreatUserWndII.xml");
			super(xml);

		}

		private function initUser(userXml:XML):void {
			var singleXml:XML;
			var info:FeatureInfo;
			var avt:CreatUserAvatar;
			for (var i:uint=0; i < userXml.children().length(); i++) {
//				singleXml=userXml.children()[i];
				singleXml=userXml.creatUser.(@layer == (i + 1))[0];
				info=new FeatureInfo();
				info.suit=singleXml.@modId1;
				info.weapon=singleXml.@modId2;
				avt=new CreatUserAvatar();
				avt.info=singleXml;
				avt.show(info, false, singleXml.@race);
				avt.x=singleXml.@x;
				avt.y=singleXml.@y;
				avt.img.updateBmp("ui/creatUser/" + singleXml.@pic, null, true);


				avt.x+=120;
				avt.y+=240;


				this.addChild(avt);
				avt.playAct(PlayerEnum.ACT_STAND, PlayerEnum.DIR_S, true);
				avt.lighten=false;

				this.avtArr.push(avt);
			}
		}


		override protected function init():void {
			this.initUser(XmlUtil.findDataProvider("user", xml));
			super.init();

			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
		}

		override protected function randomUser():void {
			var i:int=MathTools.randomAtoB(0, 7);
			this.selectAvt=this.avtArr[i];
			this.onSelect(selectAvt);
		}

		private var selectAvt:CreatUserAvatar;
		private var overAvt:CreatUserAvatar;
		private var preLayer:int;

		private function findAvt():CreatUserAvatar {
			for (var i:int=0; i < this.avtArr.length; i++) {
				if (this.avtArr[i].isOpacity()) {
					return this.avtArr[i];
				}
			}
			return null;
		}

		private function onMouseMove(evt:MouseEvent):void {
			var avt:CreatUserAvatar=this.findAvt();


			if (!avt) {
				if (this.overAvt) {
					this.overAvt.cancelOver();
					if (this.overAvt == this.selectAvt)
						this.selectAvt.lighten=true;
					this.overAvt=null;
					this.addChild(selectAvt);
					return;
				}

			} else {
				if (avt != this.overAvt) {
					if (this.overAvt)
						this.overAvt.cancelOver();
					if (this.overAvt == this.selectAvt)
						this.selectAvt.lighten=true;

					avt.onOver();
					this.addChild(avt);
					this.overAvt=avt;
				}
			}
		}


		private function onMouseClick(evt:MouseEvent):void {
			var avt:CreatUserAvatar=this.findAvt();
			if (avt == this.selectAvt)
				return;
			if (!avt)
				return;

			if (this.selectAvt)
				this.selectAvt.lighten=false;

			this.selectAvt=avt;
			this.onSelect(this.selectAvt);
		}

		private function onSelect(avt:CreatUserAvatar):void {
			avt.lighten=true;
//			avt.playActII(PlayerEnum.ACT_ATTACK, PlayerEnum.ACT_STAND);
			SoundManager.getInstance().play(avt.info.@sound);
			this.selectRace=avt.info.@race;
			this.selectSex=avt.info.@sex;
			this.addChild(avt);
		}

		override public function get width():Number {
			return 1000;
		}

		override public function get height():Number {
			return 600;
		}

	}
}
