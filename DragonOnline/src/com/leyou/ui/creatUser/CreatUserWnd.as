package com.leyou.ui.creatUser {
	import com.ace.ICommon.IResize;
	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ResizeManager;
	import com.ace.manager.TimeManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Login;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	public class CreatUserWnd extends AutoSprite implements IResize {
		private static const ROLL_NAME_NUM:int=5;

		private var nameInput:TextInput;
		private var selectTimeLbl:Label;

		private var enterBtn:ImgButton;

		private var randomBtn:ImgButton;

		private var surNameArr:Array;
		private var maleNameQueue:Array;
		private var femaleNameQueue:Array;

		private var zsBtn:ImgButton;
		private var zsMBtn:ImgButton;

		private var fsBtn:ImgButton;
		private var fsMBtn:ImgButton;

		private var ssBtn:ImgButton;
		private var ssMBtn:ImgButton;

		private var yxBtn:ImgButton;
		private var yxMBtn:ImgButton;

		private var selectBtn:ImgButton;

		private var selectRace:int=-1;
		private var selectSex:int=-1;

		private var waitTime:int=0;
		private var tick:int;

		private var confirmChk:CheckBox;
		private var protocolLbl:Label;
		private var holderLbl:Label;
		private var moreLbl:Label;
		private var verificationLbl:Label;
		private var tipImg:Image;
		private var logoImg:Image;

//		private var panel:Sprite;
//		private var texts:Vector.<TextField>;

		private var topIndex:int;

		public function CreatUserWnd() {
			super(LibManager.getInstance().getXML("config/ui/CreatUserWnd.xml"));
			init();
		}

		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			onResize();

			ResizeManager.getInstance().addToOnResize(this);

			//------------------------------------------------------------------
			// begin(奥义平台特有.)
			confirmChk=getUIbyID("confirmChk") as CheckBox;
			protocolLbl=getUIbyID("protocolLbl") as Label;
			holderLbl=getUIbyID("holderLbl") as Label;
			moreLbl=getUIbyID("moreLbl") as Label;
			verificationLbl=getUIbyID("verificationLbl") as Label;
			tipImg=getUIbyID("tipImg") as Image;
			logoImg=getUIbyID("logoImg") as Image;

			confirmChk.visible=Core.isAOYI;
			protocolLbl.visible=Core.isAOYI;
			moreLbl.visible=Core.isAOYI;
			holderLbl.visible=Core.isAOYI;
			verificationLbl.visible=Core.isAOYI;
			logoImg.visible=!Core.isAOYI;
			tipImg.visible=Core.isAOYI;
			if (Core.isAOYI) {
				confirmChk.turnOn(false);
				confirmChk.addEventListener(MouseEvent.CLICK, onCheckClick);

				var spt:Sprite=new Sprite();
				spt.addEventListener(MouseEvent.MOUSE_OVER, onTips);
				tipImg.parent.addChild(spt);
				spt.addChild(tipImg);

				moreLbl.mouseEnabled=true;
				moreLbl.addEventListener(MouseEvent.MOUSE_OVER, onTips);

				protocolLbl.mouseEnabled=true;
				verificationLbl.mouseEnabled=true;
				var style:StyleSheet=new StyleSheet();
				style.setStyle("a:hover", {color: "#ff0000"});
				protocolLbl.styleSheet=style;
				verificationLbl.styleSheet=style;

				var text:String=protocolLbl.text;
				var color:uint=protocolLbl.textColor;
				var htx:String=StringUtil.substitute("<font color='{1}'><u><a href='event:tt'>{2}</a></u></font>", color.toString(16), text);
				protocolLbl.htmlText=htx;
				protocolLbl.addEventListener(TextEvent.LINK, onTextClick);

				text=verificationLbl.text;
				color=verificationLbl.textColor;
				htx=StringUtil.substitute("<font color='{1}'><u><a href='event:tt'>{2}</a></u></font>", color.toString(16), text);
				verificationLbl.htmlText=htx;
				verificationLbl.addEventListener(TextEvent.LINK, onTextClick);
			}
			// end
			//------------------------------------------------------------------

			nameInput=getUIbyID("nameInput") as TextInput;
			nameInput.restrict=StringUtil_II.unusualCharRestrict();

			enterBtn=getUIbyID("enterBtn") as ImgButton;

			selectTimeLbl=new Label();
			enterBtn.addChild(selectTimeLbl);
			selectTimeLbl.x=120;
			selectTimeLbl.y=10;

			randomBtn=getUIbyID("randomBtn") as ImgButton;

			zsBtn=getUIbyID("zsBtn") as ImgButton;
			zsMBtn=getUIbyID("zsMBtn") as ImgButton;
			fsBtn=getUIbyID("fsBtn") as ImgButton;
			fsMBtn=getUIbyID("fsMBtn") as ImgButton;
			ssBtn=getUIbyID("ssBtn") as ImgButton;
			ssMBtn=getUIbyID("ssMBtn") as ImgButton;
			yxBtn=getUIbyID("yxBtn") as ImgButton;
			yxMBtn=getUIbyID("yxMBtn") as ImgButton;
			addEventListener(MouseEvent.CLICK, onMouseClick);

			var byteArr:ByteArray=LibManager.getInstance().getBinary("config/ui/creatUser/playName_femalename.txt");
			var str:String=byteArr.readMultiByte(byteArr.length, "UTF-8");
			femaleNameQueue=str.split("\r\n");
			byteArr=LibManager.getInstance().getBinary("config/ui/creatUser/playName_malename.txt");
			str=byteArr.readMultiByte(byteArr.length, "UTF-8");
			maleNameQueue=str.split("\r\n");
			byteArr=LibManager.getInstance().getBinary("config/ui/creatUser/playName_surname.txt");
			str=byteArr.readMultiByte(byteArr.length, "UTF-8");
			surNameArr=str.split("\r\n");
			femaleNameQueue.pop();
			maleNameQueue.pop();
			surNameArr.pop();
			selectSex=int(Math.random() * 10000) % 2;
			selectRace=int(Math.random() * 10000) % 4 + 1;
			turnOnButton(selectSex, selectRace);
			nameInput.text=randomName();
			UIManager.getInstance().creatWindow(WindowEnum.FIRST_LOGIN);

			waitTime=Core.AUTO_CREAT_TIME;
			nameInput.mouseChildren=true;
			nameInput.mouseEnabled=false;
			nameInput.input.y=4;

			nameInput.input.addEventListener(Event.CHANGE, onTextChange);
			if (waitTime > 0) {
				TimeManager.getInstance().addITick(1000, updateTime);
			}
			tick=getTimer();

//			panel=new Sprite();
//			addChild(panel);
//			panel.y=505;
//
//			texts=new Vector.<TextField>(ROLL_NAME_NUM);
//			for (var n:int=0; n < ROLL_NAME_NUM; n++) {
//				var tf:TextField=new TextField();
//				tf.wordWrap=false;
//				tf.autoSize=TextFormatAlign.LEFT;
//				tf.textColor=0xffffff;
//				tf.y=15 * n;
//				panel.addChild(tf);
//				texts[n]=tf;
//				tf.htmlText="<FONT size='12' color='#9f8657'>" + randomName() + "</FONT> " + PropUtils.getStringById(1675);
//			}
//			rollName();
		}

//		private function rollName():void {
//			for (var n:int=0; n < ROLL_NAME_NUM; n++) {
//				var tf:TextField=texts[n];
//				var obj:Object;
//				if (0 == n) {
//					obj={y: (n - 1) * 15, alpha: 0, ease: Linear.easeNone, onComplete: onMoveOver, onCompleteParams: [tf]};
//				} else {
//					obj={y: (n - 1) * 15, ease: Linear.easeNone, onComplete: onMoveOver, onCompleteParams: [tf]};
//				}
//				TweenMax.to(tf, 1.5, obj);
//			}
//		}

		public function onMoveOver(tf:TextField):void {
			if (tf.y <= -15) {
				tf.y=(ROLL_NAME_NUM - 1) * 15;
			}
			if (0 == tf.alpha) {
				tf.htmlText="<FONT size='12' color='#9f8657'>" + randomName() + "</FONT> "+PropUtils.getStringById(1675);
				tf.alpha=1;
			}
			var obj:Object;
			if (tf.y <= 0) {
				obj={y: tf.y - 15, alpha: 0, ease: Linear.easeNone, onComplete: onMoveOver, onCompleteParams: [tf]};
			} else {
				obj={y: tf.y - 15, ease: Linear.easeNone, onComplete: onMoveOver, onCompleteParams: [tf]};
			}
			TweenMax.to(tf, 1.5, obj);
		}

		protected function onTips(event:MouseEvent):void {
			var content:String=TableManager.getInstance().getSystemNotice(10014).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}

		protected function onTextClick(event:TextEvent):void {
			switch (event.target.name) {
				case "protocolLbl":
					PayUtil.openUserProtocol();
					break;
				case "verificationLbl":
					PayUtil.openVerifyUser();
					break;
			}
		}

		protected function onCheckClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "confirmChk":
					enterBtn.setActive(confirmChk.isOn, 1, true);
					break;
			}
		}

		private function onTextChange(e:Event):void {
			tick=getTimer();
		}


		private function updateTime():void {
			var interval:int=(getTimer() - tick) / 1000;
			if ((waitTime - interval) >= 0) {
				selectTimeLbl.text="(" + (waitTime - interval) + ")";
			} else {
				TimeManager.getInstance().removeITick(updateTime);
				enterBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}

		protected function onMouseClick(event:MouseEvent):void {
			var tar:*=event.target;
			if (!(tar is ImgButton)) {
				return;
			}
			if ((tar.name != "enterBtn") && (tar.name != "randomBtn")) {
				if (null != selectBtn) {
					selectBtn.turnOff();
				}
				selectBtn=tar;
				selectBtn.turnOn();
			}
			if (tar.name != "enterBtn") {
				tick=getTimer();
			}
			var sex:int;
			switch (tar.name) {
				case "enterBtn":
					onLogin();
					return;
				case "randomBtn":
					nameInput.text=randomName();
					return;
				case "zsBtn":
					selectRace=1;
					sex=PlayerEnum.SEX_BOY;
					break;
				case "zsMBtn":
					selectRace=1;
					sex=PlayerEnum.SEX_GIRL;
					break;
				case "fsBtn":
					selectRace=2;
					sex=PlayerEnum.SEX_BOY;
					break;
				case "fsMBtn":
					selectRace=2;
					sex=PlayerEnum.SEX_GIRL;
					break;
				case "ssBtn":
					selectRace=3;
					sex=PlayerEnum.SEX_BOY;
					break;
				case "ssMBtn":
					selectRace=3;
					sex=PlayerEnum.SEX_GIRL;
					break;
				case "yxBtn":
					selectRace=4;
					sex=PlayerEnum.SEX_BOY;
					break;
				case "yxMBtn":
					selectRace=4;
					sex=PlayerEnum.SEX_GIRL;
					break;
			}
			if (selectSex != sex) {
				selectSex=sex;
				nameInput.text=randomName();
			}

		}

		private function turnOnButton(sex:int, race:int):void {
			//			var ss:int = PlayerEnum.SEX_BOY;
			//			ss = PlayerEnum.SEX_GIRL;
			if (PlayerEnum.SEX_BOY == sex) {
				if (1 == race) {
					selectBtn=zsBtn;
				} else if (2 == race) {
					selectBtn=fsBtn;
				} else if (3 == race) {
					selectBtn=ssBtn;
				} else if (4 == race) {
					selectBtn=yxBtn;
				}
			} else if (PlayerEnum.SEX_GIRL == sex) {
				if (1 == race) {
					selectBtn=zsMBtn;
				} else if (2 == race) {
					selectBtn=fsMBtn;
				} else if (3 == race) {
					selectBtn=ssMBtn;
				} else if (4 == race) {
					selectBtn=yxMBtn;
				}
			}
			selectBtn.turnOn();
		}

		//登陆发协议
		private function onLogin():void {
			if (checkNameValid()) {
				Cmd_Login.cm_createRole(nameInput.text, selectSex, selectRace);
			}
		}

		private function checkNameValid():Boolean {
			//			var n:String = nameInput.text;
			//			if(StringUtil.hasIllegalWord(n)){
			//				var warnStr:String = TableManager.getInstance().getSystemNotice(5701).content;
			//				PopupManager.showAlert(warnStr);
			//				trace("非法名称");
			//				return false;
			//			}
			return true;
		}

		private function randomName():String {
			var availableArr:Array=(PlayerEnum.SEX_BOY == selectSex) ? maleNameQueue : femaleNameQueue;
			var index:int=int(Math.random() * 100000) % availableArr.length;
			var idx:int=int(Math.random() * 100000) % surNameArr.length;
			var rName:String=availableArr[index] + "·" + surNameArr[idx];
			return rName;
		}

		//后续是一个数字，表示错误类型( 1名字太短了  2名字太长了  3名字包含敏感字符(过滤表)  4名字包含非法字符(字母数字以外的ascll码)  5名字为空  6名字重复 )
		public function serError(o:Object):void {
			//			trace("错误", o.e)
			var warnStr:String;
			switch (o.e) {
				case 1:
					warnStr=TableManager.getInstance().getSystemNotice(5702).content;
					//					trace("名字为空");
					break;
				case 2:
					warnStr=TableManager.getInstance().getSystemNotice(5703).content;
					//					trace("名字太长了");
					break;
				case 3:
					warnStr=TableManager.getInstance().getSystemNotice(5701).content;
					//					trace("名字包含敏感字符(过滤表)");
					break;
				case 4:
					warnStr=TableManager.getInstance().getSystemNotice(5701).content;
					//					trace("名字包含非法字符(字母数字以外的ascll码) ");
					break;
				case 5:
					warnStr=TableManager.getInstance().getSystemNotice(5704).content;
					//					trace("名字重复");
					break;
				default:
					throw new Error("creat user unknow error");
					break;
			}
			PopupManager.showAlert(warnStr, null, false, "creat.user");
		}

		public function onResize($w:Number=0, $h:Number=0):void {
			x=(UIEnum.WIDTH - width) >> 1;
			y=(UIEnum.HEIGHT - height) >> 1;
		}

		public override function die():void {
			parent.removeChild(this);
			surNameArr=null;
			maleNameQueue=null;
			femaleNameQueue=null;
//			for (var n:int=0; n < ROLL_NAME_NUM; n++) {
//				TweenMax.killTweensOf(texts[n]);
//			}
//			texts=null;
			//			ResizeManager.getInstance(). (this);
		}
	}
}
