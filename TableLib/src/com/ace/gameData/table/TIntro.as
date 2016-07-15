package com.ace.gameData.table
{
	
	public class TIntro
	{
		
		/**
		 */
		public var id:int;
		
		/**
		 *	类型
		 */
		public var type:int;
		
		/**
		 *	类型名
		 */
		public var typeName:String;
		
		/**
		 *	左侧按钮用图片
		 */
		public var imgBtn:String;
		
		/**
		 *	右侧功能描述
		 */
		public var des:String;
		
		/**
		 *	星级
		 */
		public var starNum:int;
		
		/**
		 *	按钮文字
		 */
		public var btnDes:String;
		
		/**
		 *	UIid
		 */
		public var uiId:int;
		
		/**
		 *	tabId
		 */
		public var tabId:String;
		
		/**
		 *	显示等级
		 */
		public var lv:int;
		
		
		
		public function TIntro(data:XML=null)
		{
			if(data==null) return ;
			
			this.id=data.@id;
			this.type=data.@type;
			this.typeName=data.@typeName;
			this.imgBtn=data.@imgBtn;
			this.des=data.@des;
			this.starNum=data.@starNum;
			this.btnDes=data.@btnDes;
			this.uiId=data.@uiId;
			this.tabId=data.@tabId;
			this.lv=data.@lv;
			
			
		}
		
		
		
	}
}
