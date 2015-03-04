package com.leyou.ui.mail {
	import com.ace.manager.UIManager;
	import com.leyou.data.mail.MailInfo;
	import com.leyou.ui.mail.child.MailLableRender;
	
	import flash.events.MouseEvent;
	
	public class MailWnd extends MailWndView {
		
		public function MailWnd(){
			super();
		}
		
		/**
		 * <T>处理邮件查询回应</T>
		 * 
		 */
		public function onMailListResponse(mailList:Array):void{
			clear();
			// 解析邮件列表
			var length:int = mailList.length;
			var mailInfo:MailInfo = new MailInfo();
			for(var n:int = 0; n < length; n++){
				// 生成一个邮件
				var tmpArr:Array = mailList[n];
				mailInfo.mailId     = tmpArr[0];
				mailInfo.sourceName = tmpArr[1];
				mailInfo.title      = tmpArr[2];
				mailInfo.content    = tmpArr[3];
				mailInfo.tick       = tmpArr[4];
				mailInfo.isRead     = tmpArr[5];
				mailInfo.stuffList  = tmpArr[6];
				var mail:MailLableRender = new MailLableRender();
				mail.loadInfo(mailInfo);
				
				// 加入显示列表
				mail.x = 5;
				mail.y = n * 62;
				itemVec.push(mail);
				scrolllist.addToPane(mail);
				mail.addEventListener(MouseEvent.CLICK, onMouseClick);
			}
		}
		
		/**
		 * <T>处理系统邮件通知</T>
		 * 
		 */
		public function onSystemMailNotify(o:Object):void{	
			// 生成邮件
			var mail:MailLableRender = new MailLableRender();
			var mailInfo:MailInfo = new MailInfo();
			mailInfo.mailId  = o.id;
			mailInfo.title   = o.ti;
			mailInfo.content = o.ct;
			mailInfo.tick    = o.tm;
			mailInfo.isRead  = o.rs;
			mailInfo.sourceName = o.sn;
			mailInfo.stuffList  = o.it;
			MailInfo.serverTime = o.ost;
			mail.loadInfo(mailInfo);
			
			// 加入显示列表
			mail.x = 5;
			mail.y = itemVec.length * 62;
			itemVec.push(mail);
			scrolllist.addToPane(mail);
			mail.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		/**
		 * <T>处理提取附件回应</T>
		 * 
		 */
		public function onAccessoryResponse(o:Object):void{
			var mailId:uint = o.id;
			var length:int = itemVec.length;
			for(var n:int = 0; n < length; n++){
				var mail:MailLableRender = itemVec[n];
				if(mail.mailInfo.mailId == mailId){
					mail.mailInfo.updateStuff(o.it);
					UIManager.getInstance().maillReadWnd.loadMail(mail);
					break;
				}
			}
		}
		
		/**
		 * <T>处理删除回应</T>
		 * 
		 */
		public function onDeleteMailResponse(o:Object):void{
			var mailIdList:Array = o.id;
			var length:int = mailIdList.length;
			for(var n:int = 0; n < length; n++){
				var mailId:uint = mailIdList[n];
				removeMialRender(mailId);
			}
			updateItemPosition();
			scrolllist.scrollTo(0);
		}
		
		/**
		 * <T>删除邮件</T>
		 * 
		 */
		public function removeMialRender(mailId:uint):void{
			// 是否正在阅读
			if(UIManager.getInstance().maillReadWnd.isRead(mailId)){
				UIManager.getInstance().maillReadWnd.hide();
			}
			var length:int = itemVec.length;
			for(var n:int = 0; n < length; n++){
				var mailRender:MailLableRender = itemVec[n];
				if(mailId == mailRender.mailInfo.mailId){
					itemVec.splice(n, 1);
					if(scrolllist.contains(mailRender)){
						scrolllist.delFromPane(mailRender);
						mailRender.die();
					}
					// 是否存在于选中列表中
					var index:int = selectRenders.indexOf(mailRender); 
					if(-1 != index){
						selectRenders.splice(index, 1);
					}
					break;
				}
			}
		}
		
		/**
		 * <T>清空邮件列表</T>
		 * 
		 */		
		public function clear():void{
			var length:int = itemVec.length;
			for(var n:int = 0; n < length; n++){
				var mailRender:MailLableRender = itemVec[n];
				if(scrolllist.contains(mailRender)){
					scrolllist.delFromPane(mailRender);
					mailRender.die();
				}
			}
			itemVec.length = 0;
		}
	}
}