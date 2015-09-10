/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2014-4-9 下午6:03:06
 */
package com.leyou.data.net.scene {
	import com.ace.enum.PlayerEnum;
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.item.LivingItemInfo;
	import com.ace.gameData.manager.TableManager;

	import flash.geom.Point;
	import flash.utils.ByteArray;

	public class SMItemInfo {
		static public function parse(br:ByteArray, fun:Function):void {
			br.position=3;
			var info:LivingItemInfo=new LivingItemInfo();
			br.position++;
			info.id=br.readUnsignedShort();

			var toPs:Point=new Point();
			br.position++;
			toPs.x=br.readUnsignedShort();
			br.position++;
			toPs.y=br.readUnsignedShort();

			br.position++;
			info.ps.x=SceneUtil.screenXToTileX(br.readUnsignedShort());
			br.position++;
			info.ps.y=SceneUtil.screenYToTileY(br.readUnsignedShort());


			br.position++;
//			info.tId=br.readShort();
			info.tId=br.readInt();
			br.position++;
			info.num=br.readShort();
			br.position++;
			var isFirst:Boolean=br.readBoolean();
			br.position++;
			info.throwOwnerId=br.readUnsignedShort();

			if (!isFirst) {
				info.ps.x=SceneUtil.screenXToTileX(toPs.x);
				info.ps.y=SceneUtil.screenYToTileY(toPs.y);
			}

			if (info.tId == -1)
				info.tId=65535;
			var tinfo:*=TableManager.getInstance().getItemInfo(info.tId);
			//<1000是装备
			!tinfo && (tinfo=TableManager.getInstance().getEquipInfo(info.tId));

			info.name=tinfo.name;
			if (tinfo.hasOwnProperty("dropIcon") && tinfo.dropIcon != "") {
				info.icoName=tinfo.dropIcon;
				info.isSpecial=true;
			} else {
				info.icoName=tinfo.icon;
			}

			info.type=tinfo.classid;
			info.quality=int(tinfo.quality);
			info.race=PlayerEnum.RACE_ITEM;

			fun(info, toPs, isFirst);
		}
	}
}
