package com.leyou.ui.mail.child {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.mail.MailInfo;
	
	import flash.events.MouseEvent;

	public class MailLableRender extends AutoSprite {

		private var stateImg:Image;
		private var accessoryLbl:Label;
		private var groundImage:Image;
		
		private var fromLbl:Label;
		private var dataLbl:Label;
		private var subjectLbl:Label;
		private var surplusLbl:Label;
		
		private var selectCb:CheckBox;
		private var currentRead:Boolean;
		
		public var selected:Boolean;
		
		public var mailInfo:MailInfo;
		
		public function MailLableRender() {
			super(LibManager.getInstance().getXML("config/ui/mail/MailLableRender.xml"));
			this.mouseChildren=true;
			this.mouseEnabled = true;
			this.init();
		}

		private function init():void {
			mailInfo = new MailInfo();
			this.stateImg = this.getUIbyID("stateImg") as Image;
			this.accessoryLbl = this.getUIbyID("accessoryLbl") as Label;
			
			this.fromLbl = this.getUIbyID("fromLbl") as Label;
			this.dataLbl = this.getUIbyID("dataLbl") as Label;
			this.subjectLbl = this.getUIbyID("subjectLbl") as Label;
			
			this.selectCb = this.getUIbyID("selectCb") as CheckBox;
			this.surplusLbl = this.getUIbyID("surplusLbl") as Label;
			
			this.groundImage = this.getUIbyID("groundImg") as Image;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
//			this.selectCb.addEventListener(MouseEvent.CLICK, onCheckClick, false, 0, true);
		}
		
		/**
		 * <T>鼠标移入监听</T>
		 * 
		 */
		protected function onMouseOver(event:MouseEvent):void{
			if(null != groundImage){
				groundImage.updateBmp("ui/mail/mail_bg_1.jpg");
			}
		}
		
		/**
		 * <T>鼠标移出监听</T>
		 * 
		 */
		protected function onMouseOut(event:MouseEvent):void{
			if(!currentRead && (null != groundImage)){
				groundImage.updateBmp("ui/mail/mail_bg_0.jpg");
			}
		}
		
		/**
		 * <T>设置为当前打开邮件</T>
		 * 
		 */
		public function setCurrent():void{
			currentRead = true;
		}
		
		/**
		 * <T>取消当前打开邮件</T>
		 * 
		 */
		public function resetCurrent():void{
			currentRead = false;
			if(null != groundImage){
				groundImage.updateBmp("ui/mail/mail_bg_0.jpg");
			}
		}
		
		/**
		 * <T>选中效果</T>
		 * 
		 */
		public function select(value:Boolean):void{
			selected = value;
			selected ? selectCb.turnOn() : selectCb.turnOff();
		}
		
//		/**
//		 * 点击监听
//		 * 
//		 */
//		private function onCheckClick(e:MouseEvent):void{
//		}
		
		/**
		 * <T>加载信息</T>
		 * 
		 */
		public function reLoad():void{
			if(null != mailInfo){
//				mailInfo.assign(mailInfo);
				//				fromLbl.text = mailInfo.sourceName;
				subjectLbl.text = mailInfo.title;
				var date:Date = new Date(mailInfo.tick*1000);
				dataLbl.text = (date.month+1) + "月" + date.date + "日";
				var remain:int = mailInfo.isRead ? 259200 : 2592000;
				remain = remain - (new Date().time/1000 - mailInfo.tick);
				var hours:int = remain/60/60;
				var day:int = hours/24;
				var minute:int = hours/60;
				if(day > 0){
					surplusLbl.text = day + "天";
				}else if(hours > 0){
					surplusLbl.text = hours + "小时";
				}else{
					surplusLbl.text = minute + "分";
				}
				var hasStuff:Boolean = false;
				var stuffList:Object = mailInfo.stuffList;
				for(var key:String in stuffList){
					hasStuff = true;
					break;
				}
				mailInfo.hasStuff = hasStuff;
				accessoryLbl.visible = hasStuff;
				var url:String = "ui/mail/mail_icon_"+ (mailInfo.isRead ? "":"un") + "open.png";
				stateImg.updateBmp(url);
			}
		}
		
		/**
		 * <T>加载信息</T>
		 * 
		 */
		public function loadInfo(info:MailInfo):void{
			if(null != info){
				mailInfo.assign(info);
//				fromLbl.text = mailInfo.sourceName;
				subjectLbl.text = mailInfo.title;
				var date:Date = new Date(mailInfo.tick*1000);
				dataLbl.text = (date.month+1) + "月" + date.date + "日";
				var remain:uint = mailInfo.isRead ? 259200 : 2592000;
				remain = remain - (MailInfo.serverTime - mailInfo.tick);
				var hours:int = remain/60/60;
				var day:int = hours/24;
				surplusLbl.text = (day > 0) ? (day + "天") : (hours + "小时");
				var hasStuff:Boolean = false;
				var stuffList:Object = mailInfo.stuffList;
				for(var key:String in stuffList){
					hasStuff = true;
					break;
				}
				mailInfo.hasStuff = hasStuff;
				accessoryLbl.visible = hasStuff;
				var url:String = "ui/mail/mail_icon_"+ (mailInfo.isRead ? "":"un") + "open.png";
				stateImg.updateBmp(url);
			}
		}
		
		/**
		 * <T>生命周期结束</T>
		 * 
		 */
		public override function die():void{
			stateImg.die();
			groundImage.die();
			mailInfo.die();
			
			mailInfo = null;
			stateImg = null;
			groundImage = null;
			accessoryLbl = null;
			accessoryLbl = null;
			
			fromLbl = null;
			dataLbl = null;
			selectCb = null;
			subjectLbl = null;
			surplusLbl = null;
			
		}
		
		public function turnTo(isOn:Boolean):void{
			isOn ? selectCb.turnOn() : selectCb.turnOff();
		}
	}
}
