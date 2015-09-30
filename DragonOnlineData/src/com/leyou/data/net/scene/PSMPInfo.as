package com.leyou.data.net.scene {
	import com.ace.enum.PlayerEnum;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.utils.PnfUtil;
	import com.ace.utils.StringUtil;

	public class PSMPInfo {
//		无	人物的tag	即playerid
//		M	人物的详细信息	逗号分隔。依次是：换装标志(暂不做处理)，速度，名字，称号，性别
//		E	人物的avatar字符串	逗号分隔（reavatarid 替换 ,arm_aid 武器, armour_aid 铠甲,wing_aid 翅膀,mount_aid 坐骑）
//		U	帮派名称	加入的帮派的名称
//		I	人物的部分基础信息	逗号分隔（school 职业(0NPC,1武师，2法师，3道士，4游侠),level 等级,ele 元素(0无元素 1金 2木 3水 4火 5土),hp 当前生命,mhp 最大生命,mp 当前法力,mmp 最大法力,exp 当前经验,mexp 经验上限）

		public function PSMPInfo() {
		}

		static public function readTo(cmd:String, info:LivingInfo):FeatureInfo {
//			P|xdevgs_0000kuDjI1|M7,1,【1区】face22,,0|E,,10,,|U测试帮会名字|A0
			var fInfo:FeatureInfo=new FeatureInfo();

			var arr:Array=cmd.split("|");
//			this.tag=arr[1];

			var tmpStr:String;
			var tmpArr:Array;

			//M
			tmpStr=arr[2];
			tmpStr=tmpStr.substr(1);
			tmpArr=tmpStr.split(",");

//			this.changeAvtTag=tmpArr[0];
			info.speed=tmpArr[1];
//			info.speed=22;
			info.name=tmpArr[2];
//			info.tileNames.push(tmpArr[3]);
			info.sex=tmpArr[3];


			//I
			tmpStr=arr[5];
			tmpStr=tmpStr.substr(1);
			tmpArr=tmpStr.split(",");
//			逗号分隔（school 职业(0NPC,1武师，2法师，3道士，4游侠),level 等级,ele 元素(0无元素 1金 2木 3水 4火 5土),
//			hp 当前生命,mhp 最大生命,mp 当前法力,mmp 最大法力,exp 当前经验,mexp 经验上限,
//			sp 精力，msp 最大精力，so 魂
			info.profession=tmpArr[0];
			info.level=tmpArr[1];
			info.baseInfo.yuanS=tmpArr[2];
			info.baseInfo.hp=tmpArr[3];
			info.baseInfo.maxHp=tmpArr[4];
			info.baseInfo.mp=tmpArr[5];
			info.baseInfo.maxMp=tmpArr[6];
			info.baseInfo.exp=tmpArr[7];
			info.baseInfo.maxExp=tmpArr[8];
			info.baseInfo.jingL=tmpArr[9];
			info.baseInfo.maxJingL=tmpArr[10];
			info.baseInfo.hunL=tmpArr[11];
			info.baseInfo.maxHunL=tmpArr[12];


			//E
			tmpStr=arr[3];
			tmpStr=tmpStr.substr(1);
			tmpArr=tmpStr.split(",");

			fInfo.clear();
//			if (tmpArr[0] != 0) {
//				fInfo.suit=tmpArr[0];
//			} else {
				fInfo.vmAvatar=tmpArr[0];
				fInfo.mount=tmpArr[4];
				if (fInfo.mount == 0) {
					info.isOnMount=false;
					fInfo.weapon=PnfUtil.realAvtId(tmpArr[1], false, info.sex);
					fInfo.suit=PnfUtil.realAvtId(tmpArr[2], false, info.sex);
					fInfo.wing=PnfUtil.realWingId(tmpArr[3], false, info.sex, info.profession);
				} else {
					info.isOnMount=true;
					fInfo.mountWeapon=PnfUtil.realAvtId(tmpArr[1], true, info.sex);
					fInfo.mountSuit=PnfUtil.realAvtId(tmpArr[2], true, info.sex);
					fInfo.mountWing=PnfUtil.realWingId(tmpArr[3], true, info.sex, info.profession);
					fInfo.autoNormalInfo(true, info.profession, info.sex);
				}
//			}
			info.equipLv=tmpArr[5];
			info.equipColor=tmpArr[6];


			//T
			tmpStr=arr[6];
			tmpStr=tmpStr.substr(1);
			tmpArr=tmpStr.split(",");

			info.tId=tmpArr[0];


			//N,没有称号的话没有内容，不会有占位符
			tmpStr=arr[7];
			tmpStr=tmpStr.substr(1);
			if (tmpStr != "") {
				info.tileNames=tmpStr.split(",");
			} else {
				info.tileNames=[];
			}

//			info.tileNames=[6, 12, 18];

			//U
			tmpStr=arr[4];
			tmpStr=tmpStr.substr(1);
			tmpArr=tmpStr.split(",");
			info.tileNames.unshift(tmpArr[0]);


			//S
			tmpStr=arr[8];
			tmpStr=tmpStr.substr(1);
			tmpArr=tmpStr.split(",");
			info.isSit=StringUtil.intToBoolean(tmpArr[0]);

			//V
			tmpStr=arr[9];
			tmpStr=tmpStr.substr(1);
			tmpArr=tmpStr.split(",");
			info.vipLv=tmpArr[0];

			//K
			tmpStr=arr[10];
			tmpStr=tmpStr.substr(1);
			tmpArr=tmpStr.split(",");
			info.pkMode=tmpArr[0];

			//C
			tmpStr=arr[11];
			tmpStr=tmpStr.substr(1);
			tmpArr=tmpStr.split(",");
			info.color=tmpArr[0];

			//Q
			tmpStr=arr[12];
			tmpStr=tmpStr.substr(1);
			tmpArr=tmpStr.split(",");
			info.vipEquipId=tmpArr[0];

			//X
			tmpStr=arr[14];
			tmpStr=tmpStr.substr(1);
			tmpArr=tmpStr.split(",");
			info.pfVipType=tmpArr[0];
			info.pfVipLv=tmpArr[1];

			//Z
			tmpStr=arr[15];
			tmpStr=tmpStr.substr(1);
			tmpArr=tmpStr.split(",");
			info.camp=tmpArr[0];

//			//A
//			tmpStr=arr[13];
//			tmpStr=tmpStr.substr(1);
//			tmpArr=tmpStr.split(",");
//			info.equipLv=tmpArr[0];
//			info.equipColor=tmpArr[1];
			
			//B
			tmpStr=arr[16];
			tmpStr=tmpStr.substr(1);
			tmpArr=tmpStr.split(",");
			info.partnerName=tmpArr[0];
			return fInfo;




		}
	}
}
