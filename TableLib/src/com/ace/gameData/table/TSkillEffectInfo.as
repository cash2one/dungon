/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-8-14 下午2:30:32
 */
package com.ace.gameData.table {
	import com.ace.utils.StringUtil;


	/**
	 * 技能特效表格
	 * @author ace
	 *
	 */
	public class TSkillEffectInfo {
		public static const ACT_ENUM_ARR:Array=["", "stand", "run", "sit", "attack", "attack2", "attack3", "attack4", "attack5", "dead", "born"];

		public var id:int; //技能特效id
		public var actName:String; //动作id
		public var livingEffect1:int; //身上特效1
		public var livingEffect2:int; //身上特效2
		public var sceneEffect1:int; //场景特效1
		public var sceneEffect2:int; //场景特效2
		public var bulletId:int; //子弹id
		public var bombId:int; //爆炸id
		public var hurtId:int;//受伤特效
		public var shackFrame:int;//震屏
		public var isHitOff:Boolean;//是否击飞
		public var sound:int;//音效


		public function TSkillEffectInfo(info:XML) {

//			effectId	actionID	castFrontEff	castBackEff	scnFrontEFF	scnBackEff	buffEff	hitEff

			this.id=info.@id;
			this.actName=ACT_ENUM_ARR[info.@actionID];
			this.livingEffect1=info.@castFrontEff;
			this.livingEffect2=info.@castBackEff;
			this.sceneEffect1=info.@scnFrontEFF;
			this.sceneEffect2=info.@scnBackEff;
			this.bulletId=info.@buffEff;
			this.hurtId=info.@hitEff;
			this.bombId=info.@bombId;
			this.shackFrame=info.@shockFps;
			this.isHitOff=StringUtil.intToBoolean(info.@punch);
			this.sound=info.@sound;
		}
	}
}

/*

<skillEffect id="1" actName="attack" livingEffect1="2" livingEffect2="" sceneEffect1="" sceneEffect2="" bulletId="" des=""/>

*/


