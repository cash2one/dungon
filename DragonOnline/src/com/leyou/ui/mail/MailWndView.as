package com.leyou.ui.mail {
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Mail;
	import com.leyou.ui.mail.child.MailLableRender;
	
	import flash.events.MouseEvent;

	public class MailWndView extends AutoWindow {
		protected var scrolllist:ScrollPane;
		protected var deleteBtn:NormalButton;
		protected var fullSelectCb:RadioButton;
		protected var onlyReadCb:RadioButton;
		protected var selectAll:CheckBox;

		protected var itemVec:Vector.<MailLableRender>;
		protected var selectRenders:Vector.<MailLableRender>;
		
		protected var currentMail:MailLableRender;
		
		/**
		 * <T>构造</T>
		 * 
		 */	
		public function MailWndView() {
			super(LibManager.getInstance().getXML("config/ui/MailWnd.xml"));
			this.init();
		}
		
		public override function onWndMouseMove($x:Number, $y:Number):void{
			super.onWndMouseMove($x, $y);
			var maillRead:MaillReadWnd = UIManager.getInstance().maillReadWnd;
			if(($x + width + maillRead.width+UILayoutManager.SPACE_X) > UIEnum.WIDTH){
				x = UIEnum.WIDTH - width - maillRead.width-UILayoutManager.SPACE_X;
			}
			if($x < 0){
				x = 0;
			}
			maillRead.x = x + width + UILayoutManager.SPACE_X;
			maillRead.y = y + (height - maillRead.height);
		}
		
//		public override function get width():Number{
//			var maillRead:MaillReadWnd = UIManager.getInstance().maillReadWnd;
//			if(maillRead.visible){
//				return super.width + maillRead.width;
//			}
//			return super.width;
//		}
		
		/**
		 * <T>初始化</T> 
		 * 
		 */	
		private function init():void {
			this.mouseChildren=true;
			this.scrolllist = this.getUIbyID("scrolllist") as ScrollPane;
			this.deleteBtn = this.getUIbyID("deleteBtn") as NormalButton;
			this.fullSelectCb = this.getUIbyID("fullSelectCb") as RadioButton;
			this.onlyReadCb = this.getUIbyID("onlyReadCb") as RadioButton;
			this.selectAll = this.getUIbyID("selectAll") as CheckBox;
			this.fullSelectCb.turnOn();

			this.deleteBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.fullSelectCb.addEventListener(MouseEvent.CLICK, onClick);
			this.onlyReadCb.addEventListener(MouseEvent.CLICK, onClick);
			this.selectAll.addEventListener(MouseEvent.CLICK, onClick);

			this.itemVec = new Vector.<MailLableRender>();
			this.selectRenders = new Vector.<MailLableRender>();
		}
		
		/**
		 * <T>显示界面</T>
		 * 
		 */	
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			Cmd_Mail.cm_MailMsg_I();
		}
		
		public override function hide():void{
			super.hide();
			UIManager.getInstance().maillReadWnd.hide();
			UILayoutManager.getInstance().composingWnd(WindowEnum.MAILL);
		}
		
//		public override function onWndMouseDown():void{
//			if(UIManager.getInstance().maillReadWnd.visible){
//				UIManager.getInstance().maillReadWnd.show();
//			}
//		}

		/**
		 * <T>点击响应</T>
		 * 
		 */
		private function onClick(e:MouseEvent):void {
			switch (e.target.name) {
				case "deleteBtn":
					var unread:Boolean = hasUnread();
					var accessory:Boolean = hasAccessory();
					if(unread || accessory){
						var warnStr:String = unread ? "删除邮件中有未读邮件，是否确认删除？" : "邮件中有未提取物品，是否确认删除？";
						PopupManager.showConfirm(warnStr, deleteMailRequest, null, false, "wnd.mail.delete");
//						var pWnd:WindInfo = WindInfo.getConfirmInfo(warnStr, deleteMailRequest);
//						PopWindow.showWnd(UIEnum.WND_TYPE_CONFIRM, pWnd, "wnd.mail.delete");
					}else{
						deleteMailRequest();
					}
					break;
				case "fullSelectCb":
				case "onlyReadCb":
					checkShowMode();
					break;
				case "selectAll":
					selectAllLabel();
					break;
			}
		}
		
		private function selectAllLabel():void{
			selectRenders.length = 0;
			var isOn:Boolean = selectAll.isOn;
			var length:int = itemVec.length;
			for(var n:int = 0; n < length; n++){
				var label:MailLableRender = itemVec[n];
				label.turnTo(isOn);
				if(isOn){
					selectRenders.push(label);
				}
			}
		}
		
		/**
		 * <T>判断选中的邮件中是否有未读邮件</T>
		 *  
		 * @return Boolean
		 */
		private function hasUnread():Boolean{
			var length:int = selectRenders.length;
			for(var n:int = 0; n < length; n++){
				var mLable:MailLableRender = selectRenders[n];
				if(!mLable.mailInfo.isRead){
					return true;
				}
			}
			return false;
		}
		
		/**
		 * <T>判断选中的邮件中是否有未提取附件</T>
		 *  
		 * @return Boolean
		 */
		private function hasAccessory():Boolean{
			var length:int = selectRenders.length;
			for(var n:int = 0; n < length; n++){
				var mLable:MailLableRender = selectRenders[n];
				if(mLable.mailInfo.hasStuff){
					return true;
				}
			}
			return false;
		}
		
		/**
		 * <T>删除邮件请求</T>
		 *  
		 */
		private function deleteMailRequest():void{
			var mailIdList:Array = new Array();
			var length:int = selectRenders.length;
			for(var n:int = 0; n < length; n++){
				mailIdList.push(selectRenders[n].mailInfo.mailId);
			}
			Cmd_Mail.cm_MailMsg_D(mailIdList);
		}
		
		/**
		 * <T>检查显示模式</T>
		 * 
		 */
		public function checkShowMode():void {
			var length:int = itemVec.length;
			for(var n:int = 0; n < length; n++){
				var mLable:MailLableRender = itemVec[n];
				if(onlyReadCb.isOn){
					// 若隐藏已读邮件开关打开
					hideReadMail(mLable);
				}else{
					// 若显示全部邮件开关打开
					mLable.visible = true;
				}
			}
			updateItemPosition();
		}
	    
		/**
		 * <T>隐藏已读邮件</T>
		 * 
		 */
		public function hideReadMail(mLable:MailLableRender):void {
			if(mLable.mailInfo.isRead){
				// 隐藏已读邮件，并从选中列表中删除
				mLable.visible = false;
				var index:int = selectRenders.indexOf(mLable);
				if(-1 != index){
					selectRenders.splice(index, 1);
					mLable.select(false);
				}
			}
		}
		
		/**
		 * <T>更新邮件显示位置</T>
		 * 
		 */
		public function updateItemPosition():void {
			var validCount:int = 0;
			var length:int = itemVec.length;
			for(var n:int = 0; n < length; n++){
				var mLable:MailLableRender = itemVec[n];
				if(mLable.visible){
					if(!scrolllist.contains(mLable)){
						scrolllist.addToPane(mLable);
					}
					mLable.x = 5;
					mLable.y = 8 + (validCount++)*62;
				}else{
					if(scrolllist.contains(mLable)){
						scrolllist.delFromPane(mLable);
					}
				}
			}
		}
		
		/**
		 * <T>根据自身状态确定改变状态</T>
		 * 
		 */
		public function changeBySelfStatus(sr:MailLableRender):void{
			var index:int = selectRenders.indexOf(sr);
			if(sr.selected){
				selectRenders.splice(index, 1);
			}else{
				selectRenders.push(sr);
			}
			sr.select(!sr.selected);
		}
		
		/**
		 * <T>取消正在阅读邮件</T>
		 * 
		 */		
		public function resetCurrent():void{
			if(null != currentMail){
				currentMail.resetCurrent();
				currentMail = null;
			}
		}
		
		/**
		 * <T>点击列表项监听</T>
		 * 
		 */
		protected function onMouseClick(event:MouseEvent):void{
			var check:CheckBox = event.target as CheckBox;
			if(null != check){
				changeBySelfStatus(MailLableRender(event.currentTarget));
			}
			resetCurrent();
			var mailLabel:MailLableRender = event.target as MailLableRender;
			if(null != mailLabel){
				mailLabel.setCurrent();
				currentMail = mailLabel;
				var readWnd:MaillReadWnd = UIManager.getInstance().maillReadWnd;
				if(!readWnd.visible){
					UILayoutManager.getInstance().show(WindowEnum.MAILL, WindowEnum.MAILL_READ, -18);
				}
				readWnd.loadMail(mailLabel);
				if(!mailLabel.mailInfo.isRead){
					mailLabel.mailInfo.isRead = true;
					mailLabel.reLoad();
					if(onlyReadCb.isOn){
						hideReadMail(mailLabel)
					}
					Cmd_Mail.cm_MailMsg_R(mailLabel.mailInfo.mailId);
				}
			}
			updateItemPosition();
			event.stopImmediatePropagation();
		}

	}
}
