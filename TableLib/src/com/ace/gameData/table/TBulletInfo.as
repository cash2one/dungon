package com.ace.gameData.table {
	import com.ace.enum.UIEnum;
	import com.ace.tools.FPS;
	import com.ace.utils.StringUtil;
	
	public class TBulletInfo {
		public var id:int;
		public var type:int; //子弹类型
		public var pnfId:int; //子弹特效id
		public var radius:int; //子弹半径
		public var isRotation:Boolean; //子弹是否旋转
//		public var follow:int; //跟随谁显示
		public var px:int; //相对于人出现的位置偏移X
		public var py:int; //相对于人出现的位置偏移Y
		public var carrier:int; //载体类型
		public var lastTime:int; //持续时间
		public var distance:int;//持续距离
		public var track:int; //轨迹
		private var _speed:Number; //速度
		public var crash:Boolean; //是否碰撞爆炸
		public var crashNum:int; //碰撞的次数
		public var bombImg:int; //爆炸特效id
		
		public function TBulletInfo(info:XML) {
			//										buRange	
			this.id=info.@effConfigId;
			this.type=info.@effType;
			this.pnfId=info.@modelId;
			this.radius=info.@buWide;
			this.isRotation=StringUtil.intToBoolean(info.@isRotation);
//			this.follow=info.@followType;
			this.px=info.@x;
			this.py=info.@y;
			this.carrier=info.@carrier;
			this.lastTime=info.@effTime;
			this.distance=info.@buRange;
			this.track=info.@track;
			this.speed=info.@buspeed;
			//			this.speed/=Number(UIEnum.FRAME / UIEnum.SERVER_FRAME); //按照服务器的速度配置
			this.crash=StringUtil.intToBoolean(info.@crash);
			this.crashNum=info.@penetrate;
			this.bombImg=info.@bombImg;
		}
		
		public function get speed():Number {
			//			return this._speed / Number(UIEnum.FRAME / UIEnum.SERVER_FRAME); //按照服务器的速度配置;
			return this._speed / Number(FPS.getInstance().avgFrame / UIEnum.SERVER_FRAME); //按照服务器的速度配置;
		}
		
		public function set speed(value:Number):void {
			_speed=value;
		}
		
	}
}


/*
<!-- id="" name="" 类型="1静止的/2直线飞/3抛物线/4火枪的" 子弹img="" 是否旋转="0/1" 跟随="1鼠标/2发送者/3接受者" 偏移=""
载体="1场景/2发送者/3接受者" 持续时间="buff时候用(载体为2)" 轨迹="1/原地/2直线/3抛物线/" 速度="" 是否碰撞="0/1" 爆炸img="" -->
*/
