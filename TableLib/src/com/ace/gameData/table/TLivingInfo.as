package com.ace.gameData.table {
	import com.ace.utils.StringUtil;

	public class TLivingInfo {
		public var id:int;
		public var name:String;
		public var species:int;
		public var pnfId:int;
		public var level:int;
		public var deadTime:int;
		public var titleName:String;
//		public var isAggressive:Boolean;
		public var baseAI:int;
		public var NPCfunction:int;
		public var type:int;
		public var npcType:int;

		public var talkOnStand:String;
		public var talkOnClick:String;
		public var talkOnAttack:String;
		public var talkOnDead:String;

		public var isHitOff:Boolean;
		public var collectTime:int;

		public var soundSelect:int;
		public var soundAttack:int;
		public var soundDead:int;

		public function TLivingInfo(info:XML) {
			//			<data id="1" eb_name="丽娜" title="厨师" modelId="11001" radius="80" type="1" paoStand="晚餐做点什么呢" 
			//			paoStandRate="2" paoClick="今天我休假，不开工" skillDead="1" bodyExist="3" attack="0" lv="99" properId="99" 
			//			exp="100" baseAi="1" revive="1" reviveScript="0" liveTime="-1" reviveScript2="0" liveTime2="-1" 
			//			reviveScript3="0" liveTime3="-1" reviveScript4="0" liveTime4="-1"/>
			this.id=info.@id;
			this.name=info.@eb_name;
			this.pnfId=info.@modelId;
			this.level=info.@lv;
			this.deadTime=info.@bodyExist;
			this.titleName=info.@title;
			this.baseAI=info.@baseAi;
			this.NPCfunction=info.@NPCfunction;
			this.type=info.@boss;
			this.npcType=info.@type;

			this.talkOnStand=info.@paoStand;
			this.talkOnClick=info.@paoClick;
			this.talkOnAttack=info.@paoBattle;
			this.talkOnDead=info.@paoDead;
			this.collectTime=info.@Open_Time;

			this.isHitOff=StringUtil.intToBoolean(info.@blowup);
			
			
			this.soundSelect=info.@sound1;
			this.soundAttack=info.@sound2;
			this.soundDead=info.@sound3;
		}

		public function get isAggressive():Boolean {
			if (this.baseAI == 4 || this.baseAI == 5)
				return true;
			return false;
		}
	}
}
