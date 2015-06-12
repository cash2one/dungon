package com.leyou.data.net.scene {
	import com.ace.enum.PlayerEnum;
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.item.LivingItemInfo;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.utils.DebugUtil;
	import com.ace.utils.HexUtil;

	import flash.utils.ByteArray;

	public class PAddPlayerInfo {
		public var idTag:String;
		public var id:uint;
		public var race:int;
		public var avTag:int;
		public var px:int;
		public var py:int;
		public var dir:int;
		public var followId:int;
		public var tId:int; //表格id
		public var num:int; //数量

//		1字节，0：玩家，1：NPC，2：怪物，3:宠物，4：掉落物			
		private var SM_RACE_DIC:Object={0: PlayerEnum.RACE_HUMAN, 1: PlayerEnum.RACE_NPC, 2: PlayerEnum.RACE_MONSTER, //
				3: PlayerEnum.RACE_PET, 4: PlayerEnum.RACE_ITEM, 5: PlayerEnum.RACE_COLLECT, 6: PlayerEnum.RACE_NPC_MONSTER, 7: PlayerEnum.RACE_ESCORT, 8: PlayerEnum.RACE_NPC_HERO};

		public function PAddPlayerInfo(br:ByteArray) {
			br.position++;

//			trace(HexUtil.toHexDump("测试", br, 0, br.bytesAvailable));
			this.idTag=br.readMultiByte(br.readUnsignedByte(), "utf-8");
			br.position++;
			this.id=br.readUnsignedShort();
			br.position++;
			this.avTag=br.readUnsignedShort();
			br.position++;
			this.race=SM_RACE_DIC[br.readByte()];

			br.position++;
			this.tId=br.readUnsignedShort();
			br.position++;
			this.px=br.readUnsignedShort();
			br.position++;
			this.py=br.readUnsignedShort();
			br.position++;
			this.dir=br.readUnsignedByte();
			br.position++;
			this.followId=br.readUnsignedShort();

			if (this.race == PlayerEnum.RACE_ITEM) {
				br.position++;
				this.tId=br.readUnsignedShort();
				br.position++;
				this.num=br.readUnsignedShort();
			}

			if (dir < 0 || dir > 7) {
				DebugUtil.throwError("方向不对" + dir);
			}
		}

		static public function copyToLivingInfo(from:PAddPlayerInfo, to:LivingInfo):void {
			to.id=from.id;
			to.tId=from.tId;
			to.idTag=from.idTag;
			to.race=from.race;
			to.avTag=from.avTag;
			to.nextTile=SceneUtil.screenToTile(from.px, from.py);
			to.currentDir=from.dir;
			to.changeFollowOwner(from.followId);
		}

		//xxxxxxxxxxxxxxxxxxxx
		static public function copyToItemInfo(from:PAddPlayerInfo):LivingItemInfo {
			var to:LivingItemInfo=new LivingItemInfo();
			var info:*=TableManager.getInstance().getItemInfo(from.tId);
			//<1000是装备
			!info && (info=TableManager.getInstance().getEquipInfo(from.tId));
			to.id=from.id;
			to.race=from.race;
			to.tId=from.tId;
			to.name=info.name;
			to.icoName=info.icon;
			to.num=from.num;
			to.type=info.classid;
			to.ps=SceneUtil.screenToTile(from.px, from.py);
			return to;
		}
	}
}
