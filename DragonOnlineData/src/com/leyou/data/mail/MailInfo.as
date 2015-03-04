package com.leyou.data.mail
{
	public class MailInfo
	{
		/**
		 * 服务器时间
		 */		
		public static var serverTime:int;
		
		/**
		 * <T>邮件编号</T>
		 */
		public var mailId:uint;
		
		/**
		 * <T>发件人名称</T>
		 */
		public var sourceName:String="";
		
		/**
		 * <T>邮件标题</T>
		 */
		public var title:String="";
		
		/**
		 * <T>邮件内容</T>
		 */
		public var content:String="";
		
		/**
		 * <T>发送时间戳</T>
		 */
		public var tick:Number;
		
		/**
		 * <T>阅读状态</T>
		 */
		public var isRead:Boolean;
		
		/**
		 * <T>是否有附件</T>
		 */
		public var hasStuff:Boolean;
		
		/**
		 * <T>物品列表</T>
		 */
		public var stuffList:Object={};
		
		/**
		 * <T>...</T>
		 * 
		 */
		public function assign(data:MailInfo):void{
			mailId = data.mailId;
			sourceName = data.sourceName;
			title = data.title;
			content = data.content;
			tick = data.tick;
			isRead = data.isRead;
			mailId = data.mailId;
			updateStuff(data.stuffList);
//			var o:Object = data.stuffList;
//			for(var key:String in o){
//				stuffList[key] = o[key];
//			}
		}
		
		/**
		 * <T>...</T>
		 * 
		 */
		public function updateStuff(o:Object):void{
			for(var lk:String in stuffList){
				stuffList[lk] = null;
				delete stuffList[lk];
			}
			hasStuff = false;
			for(var nk:String in o){
				hasStuff = true;
				stuffList[nk] = o[nk];
			}
		}
		
		/**
		 * <T>...</T>
		 * 
		 */
		public function die():void{
//			sourceName = null;
//			title = null;
//			content = null;
//			stuffList = null;
		}
	}
}