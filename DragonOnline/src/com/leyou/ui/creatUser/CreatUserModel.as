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
	import com.ace.tools.MathTools;
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

	public class CreatUserModel extends AutoSprite implements IResize {
		private var nameInput:TextInput;
		private var selectTimeLbl:Label;
		private var enterBtn:ImgButton;
		private var randomBtn:ImgButton;


		protected var waitTime:int=0;
		protected var surNameArr:Array;
		protected var maleNameQueue:Array;
		protected var femaleNameQueue:Array;

		protected var selectRace:int=-1;
		protected var selectSex:int=-1;



		protected var tick:int;
		protected var userArr:Array=[[1, 0], [1, 1], [2, 0], [2, 1], [3, 0], [3, 1], [4, 0], [4, 1]];


		public function CreatUserModel(xml:XML) {
			super(xml);
			this.init();
		}

		protected function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			onResize();
			ResizeManager.getInstance().addToOnResize(this);


			randomBtn=getUIbyID("randomBtn") as ImgButton;
			nameInput=getUIbyID("nameInput") as TextInput;
			nameInput.restrict=StringUtil_II.unusualCharRestrict();
			enterBtn=getUIbyID("enterBtn") as ImgButton;


			this.randomBtn.addEventFn(MouseEvent.CLICK, onCLick);
			this.enterBtn.addEventFn(MouseEvent.CLICK, onCLick);

			selectTimeLbl=new Label();
			enterBtn.addChild(selectTimeLbl);
			selectTimeLbl.x=140;
			selectTimeLbl.y=10;

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

			UIManager.getInstance().creatWindow(WindowEnum.FIRST_LOGIN);

			waitTime=Core.AUTO_CREAT_TIME;
//			waitTime=30;
			nameInput.mouseChildren=true;
			nameInput.mouseEnabled=false;
			nameInput.input.y=4;

			nameInput.input.addEventListener(Event.CHANGE, onTextChange);
			if (waitTime > 0) {
				TimeManager.getInstance().addITick(waitTime, updateTime);
			}
			tick=getTimer();


			nameInput.text=randomName();
			this.randomUser();
		}

		protected function onCLick(evt:Event):void {
			switch (evt.target.name) {
				case "enterBtn":
					onLogin();
					return;
				case "randomBtn":
					nameInput.text=randomName();
					return;
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

		protected function randomUser():void {
			var i:int=MathTools.randomAtoB(0, 7);
			this.selectRace=this.userArr[i][0];
			this.selectSex=this.userArr[i][1];
		}

		private function randomName():String {
			var availableArr:Array=(PlayerEnum.SEX_BOY == selectSex) ? maleNameQueue : femaleNameQueue;
			var index:int=int(Math.random() * 100000) % availableArr.length;
			var idx:int=int(Math.random() * 100000) % surNameArr.length;
			var rName:String=availableArr[index] + "·" + surNameArr[idx];
			return rName;
		}


		public function onResize($w:Number=0, $h:Number=0):void {
			x=(UIEnum.WIDTH - width) >> 1;
			y=(UIEnum.HEIGHT - height) >> 1;
		}


		override public function die():void {
			parent.removeChild(this);
		}


		//登陆发协议
		private function onLogin():void {
			Cmd_Login.cm_createRole(nameInput.text, selectSex, selectRace);
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
	}
}
