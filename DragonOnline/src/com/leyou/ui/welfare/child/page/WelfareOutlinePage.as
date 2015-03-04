package com.leyou.ui.welfare.child.page
{
	import com.ace.config.Core;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Welfare;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PayUtil;
	
	import flash.events.MouseEvent;
	
	public class WelfareOutlinePage extends AutoSprite
	{
		private var timeLbl:Label;
		
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

		private var baseexp:int;

		public function WelfareOutlinePage(){
			super(LibManager.getInstance().getXML("config/ui/welfare/welfareOutLine.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			timeLbl = getUIbyID("timeLbl") as Label;
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
			num1.x = 173;
			num1.y = 177;
			num2.x = 173;
			num2.y = 275;
			num3.x = 173;
			num3.y = 373;
			num1.alignLeft();
			num2.alignLeft();
			num3.alignLeft();
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
			var ofltime:int = obj.offtime;
			baseexp = obj.baseexp;
			var st:int = obj.st;
			timeLbl.text = DateUtil.formatTime(ofltime*1000, 2);
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
		}
	}
}