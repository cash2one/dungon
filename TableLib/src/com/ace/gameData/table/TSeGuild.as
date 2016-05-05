package com.ace.gameData.table
{
	
	public class TSeGuild
	{
		
		/**
		 *	id
		 */
		public var id:String;
		
		/**
		 *	激活等级
		 */
		public var actLv:String;
		
		/**
		 *	激活类型
		 *	0 激活后每级检测
		 *	   +登录检测
		 *	1 仅在激活等级检测1次
		 */
		public var actType:String;
		
		/**
		 *	type
		 *	1.背包
		 *	2.星座
		 *	3.货币
		 *	4.特殊星期
		 */
		public var type:String;
		
		/**
		 *	typeId
		 *	1.道具ID
		 *	2.星座ID
		 *	3.货币ID 0金币,1绑钻2,钻,3,魂力,4,荣誉,5,贡献,8,功勋,9,龙魂
		 *	4.特殊星期X
		 */
		public var typeId:String;
		
		/**
		 *	typeNum
		 *	1.道具数量
		 *	
		 *	3.货币数量
		 */
		public var typeNum:String;
		
		/**
		 *	UIid
		 */
		public var uiId:String;
		
		/**
		 *	标签ID
		 */
		public var tagId:String;
		
		/**
		 *	弹窗显示图标
		 */
		public var icon:String;
		
		/**
		 *	弹窗显示描述
		 */
		public var des:String;
		
		/**
		 *	弹窗按钮文字
		 */
		public var btnDes:String;
		
		/**
		 *	箭头类型
		 *	1.1号窗口-左箭头
		 *	2.2号窗口-右箭头
		 *	3.3号窗口-上箭头
		 *	4.4号窗口-下箭头
		 *	5.图标闪烁
		 */
		public var arrowType:String;
		
		/**
		 *	箭头坐标X
		 */
		public var arrowX:String;
		
		/**
		 *	箭头坐标Y
		 */
		public var arrowY:String;
		
		/**
		 *	箭头文字
		 */
		public var arrowDes:String;
		
		/**
		 *	关闭控件Id
		 */
		public var closeAct:String;
		
		
		
		public function TSeGuild(data:XML=null)
		{
			if(data==null) return ;
			
			this.id=data.@id;
			this.actLv=data.@actLv;
			this.actType=data.@actType;
			this.type=data.@type;
			this.typeId=data.@typeId;
			this.typeNum=data.@typeNum;
			this.uiId=data.@uiId;
			this.tagId=data.@tagId;
			this.icon=data.@icon;
			this.des=data.@des;
			this.btnDes=data.@btnDes;
			this.arrowType=data.@arrowType;
			this.arrowX=data.@arrowX;
			this.arrowY=data.@arrowY;
			this.arrowDes=data.@arrowDes;
			this.closeAct=data.@closeAct;
			
			
		}
		
		
		
	}
}
