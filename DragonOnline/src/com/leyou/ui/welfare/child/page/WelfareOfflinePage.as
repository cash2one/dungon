package com.leyou.ui.welfare.child.page
{
	import com.ace.config.Core;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Welfare;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	public class WelfareOfflinePage extends AutoSprite
	{
		private var desLbl:Label;
		
		private var doubleLbl:Label;
		
		private var threefoldLbl:Label;
		
		private var payBtn:ImgButton;
		
		private var baseRBtn:ImgButton;
		
		private var doubleRBtn:ImgButton;
		
		private var threefoldRBtn:ImgButton;
		
		private var num1:RollNumWidget;
		private var num2:RollNumWidget;
		private var num3:RollNumWidget;
		
		private var hoursLbl:Label;
		private var minutesLbl:Label;
		private var secondsLbl:Label;

		private var baseexp:int;

		private var ofltime:int;

		public function WelfareOfflinePage(){
			super(LibManager.getInstance().getXML("config/ui/welfare/welfareOutLine.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
//			timeLbl = getUIbyID("timeLbl") as Label;
			desLbl = getUIbyID("delLbl") as Label;
			doubleLbl = getUIbyID("doubleLbl") as Label;
			threefoldLbl = getUIbyID("threefoldLbl") as Label;
			payBtn = getUIbyID("payBtn") as ImgButton;
			baseRBtn = getUIbyID("baseRBtn") as ImgButton;
			doubleRBtn = getUIbyID("doubleRBtn") as ImgButton;
			threefoldRBtn = getUIbyID("threefoldRBtn") as ImgButton;
			if(!Core.PAY_OPEN){
				payBtn.setActive(false, 1, true);
			}else{
				payBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			}
			baseRBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			doubleRBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			threefoldRBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			var tf:TextFormat = desLbl.defaultTextFormat;
			tf.leading = 3;
			desLbl.defaultTextFormat = tf;
			desLbl.htmlText = TableManager.getInstance().getSystemNotice(5312).content;
			var doubleVipLv:int = DataManager.getInstance().vipData.doubleExpVipLv();
			var threeflodVipLv:int = DataManager.getInstance().vipData.threeflodExpVipLv();
			var content:String;
			content = TableManager.getInstance().getSystemNotice(5313).content;
			content = StringUtil.substitute(content, doubleVipLv);
			doubleLbl.htmlText = content;
			content = TableManager.getInstance().getSystemNotice(5314).content;
			content = StringUtil.substitute(content, threeflodVipLv, ConfigEnum.welfare18);
			threefoldLbl.htmlText = content;
			num1 = new RollNumWidget();
			num2 = new RollNumWidget();
			num3 = new RollNumWidget();
			num1.loadSource("ui/num/{num}_lz.png");
			num2.loadSource("ui/num/{num}_lz.png");
			num3.loadSource("ui/num/{num}_lz.png");
			addChild(num1);
			addChild(num2);
			addChild(num3);
			num1.x = 190;
			num1.y = 188;
			num2.x = 190;
			num2.y = 273;
			num3.x = 190;
			num3.y = 356;
			num1.alignLeft();
			num2.alignLeft();
			num3.alignLeft();
			
			hoursLbl = getUIbyID("hoursLbl") as Label;
			minutesLbl = getUIbyID("minutesLbl") as Label;
			secondsLbl = getUIbyID("secondsLbl") as Label;
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "payBtn":
					PayUtil.openPayUrl();
					break;
				case "baseRBtn":
					Cmd_Welfare.cm_OFL_L(1);
					break;
				case "doubleRBtn":
					Cmd_Welfare.cm_OFL_L(2);
					break;
				case "threefoldRBtn":
					Cmd_Welfare.cm_OFL_L(3);
					break;
			}
		}
		
		public function updateInfo(obj:Object):void{
			ofltime = obj.offtime;
			baseexp = obj.baseexp;
			var hours:int = ofltime/60/60;
			var minutes:int = ofltime/60%60;
			var seconds:int = ofltime%60;
			hoursLbl.text = StringUtil_II.lpad(hours+"", 2, "0");
			minutesLbl.text = StringUtil_II.lpad(minutes+"", 2, "0");
			secondsLbl.text = StringUtil_II.lpad(seconds+"", 2, "0");
			var st:int = obj.st;
//			timeLbl.text = DateUtil.formatTime(ofltime*1000, 2);
			num1.setNum(baseexp);
			num2.setNum(baseexp*2);
			num3.setNum(baseexp*3);
			if(0 == st){
				baseRBtn.setActive(false, 1, true);
				doubleRBtn.setActive(false, 1, true);
				threefoldRBtn.setActive(false, 1, true);
			}else{
				var vipLv:int = Core.me.info.vipLv;
				baseRBtn.setActive(true, 1, true);
				doubleRBtn.setActive(false, 1, true);
				threefoldRBtn.setActive(false, 1, true);
				if(vipLv >= 1 && vipLv < 6){
					doubleRBtn.setActive(true, 1, true);
				}else if(vipLv >= 6){
					doubleRBtn.setActive(true, 1, true);
					threefoldRBtn.setActive(true, 1, true);
				}
			}
		}
		
		public function hasReward():Boolean{
			return (baseexp > 0);
//			return (ofltime >= ConfigEnum.OutLine1);
		}
	}
}