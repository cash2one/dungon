package com.ace.gameData.table
{
	
	public class TTitle
	{
		
		/**
		 *	分类ID
		 *	原(titleId)
		 *	各换装类型的ID
		 *	1-999称号
		 *	1000-1999时装
		 *	2000-3999坐骑
		 *	4000-4999翅膀
		 *	5000-5999技能
		 *	6000-6999足迹
		 *	7000-7999特效
		 */
		public var typeId:int;
		
		/**
		 *	换装类型
		 *	1.称号
		 *	2.时装
		 *	3.坐骑
		 *	4.翅膀
		 *	5.技能
		 *	6.足迹
		 *	7.特效
		 *	(标签页)
		 */
		public var Sz_type:int;
		
		/**
		 *	称号分类
		 *	1 身份象征
		 *	3 世界事件
		 *	4.城主专用
		 *	
		 *	（1.有无获得均会显示
		 *	3.获得才会显示
		 *	4.强制显示）
		 */
		public var type:int;
		
		/**
		 *	实时检测
		 *	
		 *	0，无需检测
		 *	1，实时检测
		 */
		public var testing:int;
		
		/**
		 *	换装名称
		 */
		public var name:String;
		
		/**
		 *	换装达成条件描述1
		 */
		public var des:String;
		
		/**
		 *	换装达成条件描述
		 */
		public var des2:String;
		
		/**
		 *	换装达成条件描述
		 */
		public var des3:String;
		
		/**
		 *	调用动画 pnf表
		 *	不填则读取后面颜色选项
		 *	填则不读后面颜色选项
		 *	
		 *	坐骑、翅膀格式为 A,B
		 *	A为常规模型，B为UI模型
		 */
		public var model:String;
		
		/**
		 *	客户端用展示大图
		 */
		public var model2:String;
		
		/**
		 *	
		 */
		public var flv:String;
		
		/**
		 *	底层图片
		 *	称号读取图片
		 *	其他读取icon
		 *	
		 *	填写图片ID，该图片将置于调用动画和称号文字的底层
		 */
		public var Bottom_Pic:String;
		
		/**
		 *	称号颜色
		 *	其他读取显示文字颜色
		 */
		public var fontColour:String;
		
		/**
		 *	描边颜色
		 *	其他读取显示文字描边颜色
		 */
		public var borderColour:String;
		
		/**
		 *	条件达成类型1
		 */
		public var factor1:String;
		
		/**
		 *	条件达成值
		 *	1
		 */
		public var factorNum1:String;
		
		/**
		 *	条件达成类型2
		 */
		public var factor2:String;
		
		/**
		 *	条件达成值2
		 */
		public var factorNum2:String;
		
		/**
		 *	条件达成类型3
		 */
		public var factor3:String;
		
		/**
		 *	条件达成值3
		 */
		public var factorNum3:String;
		
		/**
		 *	有效期（秒）
		 *	0 永久
		 *	1城主
		 */
		public var time:int;
		
		/**
		 *	出售价格类型
		 *	1.金币
		 *	2.魂力
		 *	3.绑钻
		 *	4.钻石
		 *	5.贡献
		 *	6.荣誉
		 *	7.功勋
		 *	8.道具id
		 */
		public var moneyType:int;
		
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
			
			this.typeId=data.@typeId;
			this.Sz_type=data.@Sz_type;
			this.type=data.@type;
			this.testing=data.@testing;
			this.name=data.@name;
			this.des=data.@des;
			this.des2=data.@des2;
			this.des3=data.@des3;
			this.model=data.@model;
			this.model2=data.@model2;
			this.flv=data.@flv;
			this.Bottom_Pic=data.@Bottom_Pic;
			this.fontColour=data.@fontColour;
			this.borderColour=data.@borderColour;
			this.factor1=data.@factor1;
			this.factorNum1=data.@factorNum1;
			this.factor2=data.@factor2;
			this.factorNum2=data.@factorNum2;
			this.factor3=data.@factor3;
			this.factorNum3=data.@factorNum3;
			this.time=data.@time;
			this.moneyType=data.@moneyType;
			this.attribute1=data.@attribute1;
			this.value1=data.@value1;
			this.attribute2=data.@attribute2;
			this.value2=data.@value2;
			this.attribute3=data.@attribute3;
			this.value3=data.@value3;
			
			
		}
		
		
		
	}
}
