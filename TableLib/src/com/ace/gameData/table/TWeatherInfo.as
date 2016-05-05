/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2015-12-10 下午4:09:02
 */
package com.ace.gameData.table {
	import flash.geom.Point;

	public class TWeatherInfo {
//		<data id="1" type="1风/2花/3雨/4雪/5叶" gravity="重力加速度" friction="风阻力" intervalOfWind="生成风的时间间隔" intervalOfLighting="生成闪电的时间间隔" forceXMin="横向风力范围" forceXMax="横向风力范围" forceYMin="竖向风力范围" forceYMax="竖向风力范围" zeroV="速度小于多少近似为0" weightMin="特效的重量范围" weightMax="特效的重量范围"/>
//		<data id="1"  type="3" perNum="2" gravity="0.15" friction="0.4" intervalOfWind="5000" intervalOfLighting="8000" forceXMin="0.5" forceXMax="5" forceYMin="0.05" forceYMax="1" zeroV="0.001" weightMin="0.5" weightMax="1"/>
		public var type:int;//1风/2花/3雨/4雪/5叶
		public var perNum:int; //每帧产生数量
		public var gravity:Number; //重力加速度  
		public var friction:Number; //风阻力
		public var intervalOfWind:int; //生成风的时间间隔
		public var intervalOfLighting:int; //生成闪电的时间间隔
		public var forceX:Point=new Point(); //横向风力范围
		public var forceY:Point=new Point(); //竖向风力范围
		public var zeroV:Number; //速度小于多少近似为0
		public var weight:Point=new Point(); //特效的重量范围

		public function TWeatherInfo(xml:XML) {
			this.read(xml);
		}

		private function read(xml:XML):void {
			this.type=xml.@type;
			this.perNum=xml.@perNum;
			this.gravity=xml.@gravity;
			this.friction=xml.@friction;
			this.intervalOfWind=xml.@intervalOfWind;
			this.intervalOfLighting=xml.@intervalOfLighting;
			this.forceX.x=xml.@forceXMin;
			this.forceX.y=xml.@forceXMax;
			this.forceY.x=xml.@forceYMin;
			this.forceY.y=xml.@forceYMax;
			this.zeroV=xml.@zeroV;
			this.weight.x=xml.@weightMin;
			this.weight.y=xml.@weightMax
		}
	}
}
