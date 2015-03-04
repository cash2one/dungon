package com.leyou.ui.creatUser {
	import com.ace.ICommon.IResize;
	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ResizeManager;
	import com.ace.manager.TimeManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Login;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	public class CreatUserWnd extends AutoSprite implements IResize {
		
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
		
		public function CreatUserWnd() {
			super(LibManager.getInstance().getXML("config/ui/CreatUserWnd.xml"));
			init();
		}
		
		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			onResize();
			ResizeManager.getInstance().addToOnResize(this);
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
			var str:String=byteArr.readMultiByte(byteArr.length, "gb2132");
			femaleNameQueue=str.split("\r\n");
			byteArr=LibManager.getInstance().getBinary("config/ui/creatUser/playName_malename.txt");
			str=byteArr.readMultiByte(byteArr.length, "gb2132");
			maleNameQueue=str.split("\r\n");
			byteArr=LibManager.getInstance().getBinary("config/ui/creatUser/playName_surname.txt");
			str=byteArr.readMultiByte(byteArr.length, "gb2132");
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
			
			nameInput.input.addEventListener(Event.CHANGE, onTextChange);
			if(waitTime > 0){
				TimeManager.getInstance().addITick(1000, updateTime);
			}
			tick = getTimer();
		}
		
		private function onTextChange(e:Event):void {
			tick = getTimer();
		}
		
		
		private function updateTime():void {
			var interval:int = (getTimer() - tick)/1000;
			if((waitTime - interval) >= 0){
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
				tick = getTimer();
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
			//			ResizeManager.getInstance(). (this);
		}
	}
}
