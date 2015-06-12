package com.ace.gameData.table
{
	public class TFarmPlantInfo
	{
		// 编号
		public var id:int;
		
		// 名称
		public var name:String;
		
		// 类型
		//		0 仅在普通农场商店出现，不需要花费
		//		1 仅在元宝农场商店出现，需要花费元宝
		public var type:int;
		
		//收益ID
		//0 游戏币
		//1 绑定元宝
		//2 元宝
		//3 魂力
		//4 经验
		public var plantId:int;
		
		//收益数值
		public var plantNum:int;
		
		//成长时间（s）
		public var growTime:int;
		
		
		//售卖价格（游戏币）
		public var sellMoney:int;
		
		public var sellIB:int;
		
		public var accIB:int;
		
		//图标
		public var icon:String;
		
		//资源名称
		public var avatar1:String;
		
		public var avatar2:String;
		
		public var effectId:int;
		
		public var color:int;
		
		public function TFarmPlantInfo(xml:XML=null){
			if(xml == null)
				return;
			this.id=xml.@index;
			this.name=xml.@name;
			this.type=xml.@type;
			this.plantId=xml.@plantId;
			this.plantNum=xml.@plantNum;
			this.growTime=xml.@growTime;
			this.sellMoney=xml.@sellMoney;
			this.sellIB=xml.@sellIB;
			this.accIB=xml.@accIB;
			this.icon=xml.@icon;
			this.avatar1=xml.@avatar1;
			this.avatar2=xml.@avatar2;
			this.effectId=xml.@eft;
			this.color=xml.@colour;
		}
	}
}