package com.leyou.ui.welfare.child.component
{
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.img.child.Image;
	import com.ace.utils.StringUtil;
	import com.leyou.data.calendar.DayInfo;
	import com.leyou.data.calendar.MonthInfo;
	import com.leyou.enum.CalendarEnum;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Welfare;
	import com.leyou.utils.PayUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class CalendarDayRender extends Sprite
	{
		private static const Format:TextFormat = new TextFormat(null, 14, 0xffffff, true, null, null, null, null, TextFormatAlign.CENTER)
		// 底图
		private var bgImg:Image;
		
		// 签到标志图
		private var flagImg:Image;
		
		// 日期显示
		private var dayText:TextField;
		
		// 是否是今天
		private var current:Image;
		
		private var day:int;
		
		private var currentDay:int;

		private var dayInfo:DayInfo;
		
		public function CalendarDayRender(){
			init()
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren = false;
			bgImg = new Image();
			dayText = new TextField();
			flagImg = new Image();
			current = new Image();
			
			addChild(bgImg);
			addChild(dayText);
			addChild(current);
			addChild(flagImg);
			
			dayText.width = 66;
			dayText.height = 27;
			dayText.defaultTextFormat = Format;
			dayText.filters = [FilterEnum.hei_miaobian];
			addEventListener(MouseEvent.CLICK, onMouseClick);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
//			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
//		protected function onMouseOut(event:MouseEvent):void{
//			
//		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var content:String = TableManager.getInstance().getSystemNotice(6007).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			if(null == dayInfo){
				return;
			}
			if(dayInfo.day == currentDay){
				sign();
				return;
			}
			if(CalendarEnum.SIGN_STATUS_REFIT == dayInfo.signStatus){
				var signC:int = UIManager.getInstance().welfareWnd.getSignCount();
				var signVC:int = DataManager.getInstance().vipData.getSignCount(Core.me.info.vipLv);
				if(signC < signVC){
					if(CalendarEnum.SIGN_STATUS_REFIT == dayInfo.signStatus){
						var cc:String = TableManager.getInstance().getSystemNotice(5301).content;
//						cc = StringUtil.substitute(cc, getCost());
						PopupManager.showRadioConfirm(cc, ConfigEnum.welfare11.split("|")[0], ConfigEnum.welfare11.split("|")[1], sign, null, false, "calender.sign");
					}else if(day == currentDay){
						sign();
					}
				}else{
					var count:int = DataManager.getInstance().vipData.getSignCount(Core.me.info.vipLv);
					var content:String = TableManager.getInstance().getSystemNotice(6006).content;
					content = StringUtil.substitute(content, Core.me.info.vipLv+1, count);
					PopupManager.showAlert(content, onOKClick, false, "calender.sign");
				}
			}
		}
		
		private function onOKClick():void{
			PayUtil.openPayUrl();
		}
		
//		private function getCost():int{
//			return UIManager.getInstance().welfareWnd.getCost();
//			var dd:int = currentDay - day;
//			switch(dd){
//				case 1:
//					return ConfigEnum.welfare11;
//				case 2:
//					return ConfigEnum.welfare12;
//				case 3:
//					return ConfigEnum.welfare13;
//				case 4:
//					return ConfigEnum.welfare14;
//				case 5:
//					return ConfigEnum.welfare15;
//				case 6:
//					return ConfigEnum.welfare16;
//				default:
//					return ConfigEnum.welfare17;
//			}
//			return 0;
//		}
		
		protected function sign(type:int=0):void{
			var rtype:int = ((0 == type) ? 1 : 0);
			Cmd_Welfare.cm_SIGN_S(day,rtype);
		}
		
		public function updataInfo(monthInfo:MonthInfo, dayIndex:int):void{
			if((dayIndex < 1) || (dayIndex > monthInfo.count)){
				bgImg.updateBmp("ui/welfare/calendar_3.jpg");
				return;
			}
			dayInfo = monthInfo.getDay(dayIndex);
			day = dayInfo.day;
			var todayInfo:DayInfo = monthInfo.currentDay;
			var bgUrl:String = (todayInfo.day >= dayInfo.day) ? "ui/welfare/calendar_1.jpg" : "ui/welfare/calendar_2.jpg";
			bgImg.updateBmp(bgUrl);
			dayText.text = dayInfo.day+"";
			currentDay = monthInfo.currentDay.day;
			if(monthInfo.isToday(dayInfo)){
				current.updateBmp("ui/welfare/calendar_jin.png");
				current.visible = true;
			}else{
				current.visible = false;
			}
			if((0 == dayInfo.weekDay) || (6 == dayInfo.weekDay)){
				dayText.textColor = 0xf4630b;
			}else{
				dayText.textColor = 0xe3d7af;
			}
			
			switch(dayInfo.signStatus){
				case CalendarEnum.SIGN_STATUS_REFIT:
					flagImg.updateBmp("ui/welfare/calendar.png");
					flagImg.x = 0;
					break;
				case CalendarEnum.SIGN_STATUS_SIGNED:
					flagImg.updateBmp("ui/welfare/calendar_qian.png");
					flagImg.x = 18;
					break;
			}
		}
	}
}