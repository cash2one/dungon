package com.leyou.net.cmd {
	import com.ace.config.Core;
	import com.ace.enum.EffectEnum;
	import com.ace.enum.NoticeEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.ui.SceneUIManager;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TNoticeInfo;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.DebugUtil;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.utils.EffectUtil;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.StringUtil_II;

	import flash.geom.Point;


	public class Cmd_SystemNotice {

		/**
		 * <T>系统提示</T>
		 *
		 * @param obj 提示数据
		 *
		 */
		static public function ser_Notice(obj:Object):void {

//			msg|{"msgid":1234,"var":[v1,v2,...]}
			var notice:TNoticeInfo=TableManager.getInstance().getSystemNotice(obj["msgid"]);
			if (null == notice) {
				DebugUtil.throwError("没有该消息提示：" + obj["msgid"]);
			}


			if (notice.viewPsIs(10)) {
				var arr:Array=com.ace.utils.StringUtil.substitute(notice.content, obj["var"]).split("|");
				var etype:int=0;
				if (20 == arr[0]) {
					etype=1;
				} else if (29 == arr[0]) {
					etype=2;
				}
				if (0 == etype) {
					SceneUIManager.getInstance().addEffect(Core.me, EffectEnum.BUBBLE_LINE, arr[1], EffectEnum.COLOR_GREEN, EffectUtil.getPropName(arr[0]), "", null, true);
				} else {
//					var pt:Point = Core.me.localToGlobal(new Point());
//					pt.y -= Core.me.bInfo.radius;
//					FlyManager.getInstance().flyExpOrHonour(2, arr[1], etype, pt);
				}
			}

			var values:Array=replaceItem(obj["var"]);
			if (notice.viewPsIs(3)) {
				if (UIManager.getInstance().chatWnd) {
					UIManager.getInstance().chatWnd.onSysNotice(notice, replaceItem(obj["var"], 12));
				}
			}

			//押镖
			if ([4505, 4509, 4510, 4511, 4513].indexOf(notice.id) > -1) {
				if (!UIManager.getInstance().isCreate(WindowEnum.DELIVERYPANEL))
					UIManager.getInstance().creatWindow(WindowEnum.DELIVERYPANEL);

				UIManager.getInstance().deliveryPanel.updateDesc(com.ace.utils.StringUtil.substitute(notice.content, replaceItem(obj["var"])));
			}

			if (MapInfoManager.getInstance().type == SceneEnum.SCENE_TYPE_ACROSS) {
				var content:String=notice.content;
				var flag:int=content.indexOf("|");
				var type:int=int(content.substring(0, flag));
				if (type == NoticeEnum.ICON_LINK_MAIL || type == NoticeEnum.ICON_LINK_GUILD || type == NoticeEnum.ICON_LINK_FARM) {
					return;
				}
			}

			NoticeManager.getInstance().broadcast(notice, values);
		}

		/**
		 * <T>将道具ID替换为带颜色的HTML名称</T>
		 *
		 * @param values 源数组
		 * @return       替换后数组
		 *
		 */
		public static function replaceItem(values:Array, size:int=14):Array {
			if (null == values) {
				return null;
			}
			var copy:Array=new Array();
			var count:int=values.length;
			for (var n:int=0; n < count; n++) {
				var value:Object=values[n];
				if (null == value) {
					copy[n]="null string given by server";
						//throw new Error("无效对象,要替换的属性数组为:"+values.join(","));
				}
				var index:int=value.toString().indexOf("#");
				if (-1 != index) {
					var itemId:uint=uint(value.substr(index + 1));
					var itemInfo:TItemInfo=TableManager.getInstance().getItemInfo(itemId);
					var equipInfo:TEquipInfo=TableManager.getInstance().getEquipInfo(itemId);
					var qulity:uint;
					var itemName:String;
					if (null != itemInfo) {
						qulity=uint(itemInfo.quality);
						itemName=itemInfo.name;
					}
					if (null != equipInfo) {
						qulity=uint(equipInfo.quality);
						itemName=equipInfo.name;
					}
					var color:String="#" + ItemUtil.getColorByQuality(qulity).toString(16).replace("0x");
					var reName:String=com.leyou.utils.StringUtil_II.getColorStrByFace(itemName, color, "微软雅黑", size);
					copy[n]=reName;
				} else {
					copy[n]=value;
				}
			}
			return copy;
		}
	}
}
