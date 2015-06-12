/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-10-23 下午6:00:11
 */
package com.leyou.utils {
	import com.ace.config.Core;
	import com.ace.enum.NoticeEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.adobe.serialization.json.JSON;
	import com.leyou.enum.ChatEnum;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Duel;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.ui.arena.childs.ArenaMsgWnd;
	import com.leyou.util.DateUtil;

	import flash.events.TextEvent;
	import flash.utils.getTimer;


	public class MessageUtil {

		private static var v:Array;

		/**
		 * <T>点击提示连接处理</T>
		 *
		 * @param linkType 连接类型
		 * @param values   相关数据
		 *
		 */
		static public function onMsgLinkClick(linkType:int, ... values):void {
			v=values[1];
			ToolTipManager.getInstance().hide();
			if (NoticeEnum.LINK_TEXT == linkType) {
				var event:TextEvent=values[0];
			} else if (NoticeEnum.LINK_ICON == linkType) {
				var type:int=values[0];
				var data:Array=values[1];
				var obj:Object;
				switch (type) {
					case NoticeEnum.ICON_LINK_TEAM: //邀请入队
						obj=com.adobe.serialization.json.JSON.decode(data[0]);
						if ("W" == obj["mk"]) {
							Cmd_Tm.sm_tm_W(obj);
						} else if ("A" == obj["mk"]) {
							Cmd_Tm.sm_tm_A(obj);
						}
						break;
					case NoticeEnum.ICON_LINK_GUILD: //邀请入帮
						obj=com.adobe.serialization.json.JSON.decode(data[0]);
						if ("W" == obj["mk"]) {
							Cmd_Guild.sm_Guild_W(obj);
						} else if ("A" == obj["mk"]) {
							Cmd_Guild.sm_Guild_A(obj);
						}
						break;
					case NoticeEnum.ICON_LINK_MAIL: //邮件信息
						UIOpenBufferManager.getInstance().open(WindowEnum.MAILL);
						break;
					case NoticeEnum.ICON_LINK_DIE: //死亡信息 数据顺序time,name
						var date:Date=new Date(data[0] * 1000);
						var s:String;
						if (0 == data[5]) {
							s=DateUtil.formatDate(date, "YYYY-MM-DD HH24:MI:SS") + "\n" + PropUtils.getStringById(1525);
							s=com.leyou.utils.StringUtil_II.translate(s, data[2], com.leyou.utils.StringUtil_II.getColorStr(com.leyou.utils.StringUtil_II.addEventString(data[1], "[" + data[1] + "]", true), ChatEnum.COLOR_USER));
							var pl:Array=data[3];
							if (pl.length > 0) {
								s+=PropUtils.getStringById(1516)
								var l:int=pl.length;
								for (var n:int=0; n < l; n++) {
									var itemId:int=pl[n][0];
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
									var reName:String=com.leyou.utils.StringUtil_II.getColorStrByFace(itemName, color, "微软雅黑", 14);
									if (pl[n][1] > 1) {
										s+=(reName + "×" + pl[n][1]) + ",";
									} else {
										s+=reName + ",";
									}
								}
								s+="."
							} else {
								s+="," + PropUtils.getStringById(1517)
							}
						} else if (1 == data[5]) {
							s=TableManager.getInstance().getSystemNotice(3904).content;
							var pn:String=StringUtil_II.getColorStr(StringUtil_II.addEventString(data[1], "[" + data[1] + "]", true), ChatEnum.COLOR_USER);
							s=StringUtil.substitute(s, data[2], data[1], data[4]);
						}
						if (Core.me.info.level >= ConfigEnum.tobeStr1) {
							UIManager.getInstance().showWindow(WindowEnum.DIE);
//							UIManager.getInstance().dieWnd.pushInfo(s);
						} else {
							PopupManager.showAlert(s, null, false, "die.alert");
						}
						break;
					case NoticeEnum.ICON_LINK_CHALLENGE: //竞技场挑战信息

						// 6.27号下午复制
						var str:String="";
//						if (data[1] == 1){
//							str="<font color='#00ff00'>[挑战成功]</font>";
//						}else{
//							str="<font color='#ff0000'>[挑战失败]</font>";
//						}

						str+=" " + data[0] + ",";

						if (data[1] == 1) {
							str+=" " + PropUtils.getStringById(1598);
						} else {
							str+=" " + PropUtils.getStringById(1597);
						}

						str+="<font color='#ffd700'><u><a href='event:play--" + data[3] + "'>" + data[3] + "</a></u></font>,";

						if (data[1] == 1) {
							str+=" " + StringUtil.substitute(PropUtils.getStringById(1600), ["<font color='#ff0000'>" + data[2] + "</font>"]) + ",";
						} else {
							str+=" " + StringUtil.substitute(PropUtils.getStringById(1599), ["<font color='#00ff00'>" + data[2] + "</font>"]) + ",";
						}

//						PopupManager.showAlert(str, null,false, "die.alert");

//						if (data[4] == 0)
//							str+=" <font color='#ffd700'><u><a href='event:time--" + data[0] + "'>前去复仇</a></u></font>";

//						this.ctxLbl.htmlText=str + "";
						ArenaMsgWnd.Time=data[0];
						UIManager.getInstance().showWindow(WindowEnum.ARENA_NOTICE);
						UIManager.getInstance().arenaMegWnd.updateInfo(str, (data[1] != 1));
						break;
					case NoticeEnum.ICON_LINK_FARM: //农场信息
						UIOpenBufferManager.getInstance().open(WindowEnum.FARM);
						break;
					case NoticeEnum.ICON_LINK_FRIEND:
						var content:String=PropUtils.getStringById(2021);
						content=com.leyou.utils.StringUtil_II.translate(content, data[0]);
						PopupManager.showConfirm(content, onAddFriend, null, false, "notice.addfriend");
						break;
					case NoticeEnum.ICON_LINK_INTEAM:
						var c:String=TableManager.getInstance().getSystemNotice(3119).content;
						c=com.ace.utils.StringUtil.substitute(c, data[0]);
						PopupManager.showAlert(c, null, false, "notice.inteam");
						break;
					case NoticeEnum.ICON_LINK_DEVIL:
						var dc:String=TableManager.getInstance().getSystemNotice(5610).content;
						dc=com.ace.utils.StringUtil.substitute(dc, data);
						PopupManager.showAlert(dc, null, false, "notice.devil");
						break;
					case NoticeEnum.ICON_LINK_THOUGHT:
						var tc:String=TableManager.getInstance().getSystemNotice(9965).content;
						data[0]=DateUtil.formatTime(data[0] * 1000, 2);
						tc=com.ace.utils.StringUtil.substitute(tc, data);
						PopupManager.showAlert(tc, null, false, "notice.thought", PropUtils.getStringById(2022));
						break;
					case NoticeEnum.ICON_LINK_DUEL:
						v.push(getTimer());
						var duc:String=TableManager.getInstance().getSystemNotice(3512).content;
						duc=com.leyou.utils.StringUtil_II.translate(duc, data[0]);
						PopupManager.showConfirm(duc, onDuelConfirm, onDuelCancel, false, "notice.duel");
						break;
					default:
						throw new Error("Message util has unknow case");
						break;
				}
			}
		}

		private static function onDuelConfirm():void {
			var interval:int=getTimer() - int(v[1]);
			if (interval < 30000) {
				Cmd_Duel.cm_DUEL_R(v[0], 1);
			} else {
				NoticeManager.getInstance().broadcastById(3532);
			}
		}

		private static function onDuelCancel():void {
			var interval:int=getTimer() - int(v[1]);
			if (interval < 3000) {
				Cmd_Duel.cm_DUEL_R(v[0], 0);
			}
		}

		private static function onAddFriend():void {
			Cmd_Friend.cm_FriendMsg_A(1, v[0]);
		}
	}
}
