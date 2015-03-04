package com.ace.gameData.table
{
	
	public class TTitle
	{
		
		/**
		 *	声望ID
		 */
		public var titleId:int;
		
		/**
		 *	分类
		 *	0 人物历程
		 *	1 身份象征
		 *	2 竞技排名
		 */
		public var type:int;
		
		/**
		 *	称号名
		 */
		public var name:String;
		
		/**
		 *	称号达成条件描述
		 */
		public var des:String;
		
		/**
		 *	调用动画
		 *	不填则读取后面颜色选项
		 *	填则不读后面颜色选项
		 */
		public var model:int;
		
		
		/**
		 *	底层图片
		 *	
		 *	填写图片ID，该图片将置于调用动画和称号文字的底层
		 */
		public var Bottom_Pic:String;
		
		/**
		 *	称号颜色
		 */
		public var fontColour:String;
		
		/**
		 *	描边颜色
		 */
		public var borderColour:String;
		
		/**
		 *	条件达成类型
		 *	1 等级
		 *	2 杀死怪物
		 *	3 杀死怪物数量
		 */
		public var factor:String;
		
		/**
		 *	条件达成值
		 *	等级
		 *	怪物ID
		 *	数量值
		 */
		public var factorNum:String;
		
		/**
		 *	有效期（秒）
		 *	0 永久
		 */
		public var time:int;
		
		/**
		 *	增加属性ID1
		 */
		public var attribute1:String;
		
		/**
		 *	数值1
		 */
		public var value1:String;
		
		/**
		 *	增加属性ID2
		 */
		public var attribute2:String;
		
		/**
		 *	数值2
		 */
		public var value2:String;
		
		/**
		 *	增加属性ID3
		 */
		public var attribute3:String;
		
		/**
		 *	数值3
		 */
		public var value3:String;
		
		
		
		public function TTitle(data:XML=null)
		{
			if(data==null) return ;
			
			this.titleId=data.@titleId;
			this.type=data.@type;
			this.name=data.@name;
			this.des=data.@des;
			this.model=data.@model;
			this.Bottom_Pic=data.@Bottom_Pic;
			this.fontColour=data.@fontColour;
			this.borderColour=data.@borderColour;
			this.factor=data.@factor;
			this.factorNum=data.@factorNum;
			this.time=data.@time;
			this.attribute1=data.@attribute1;
			this.value1=data.@value1;
			this.attribute2=data.@attribute2;
			this.value2=data.@value2;
			this.attribute3=data.@attribute3;
			this.value3=data.@value3;
			
			
		}
		
		
		
	}
}
