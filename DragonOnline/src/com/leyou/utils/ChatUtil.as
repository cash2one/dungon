package com.leyou.utils {
	import com.ace.config.Core;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TNoticeInfo;
	import com.ace.gameData.table.TSceneInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.adobe.serialization.json.JSON;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.chat_II.ChatContentInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ChatEnum;
	import com.leyou.net.cmd.Cmd_Bag;

	import flash.display.DisplayObject;

	public class ChatUtil {
		/**
		 * <T>获得各频道cd时间间隔</T>
		 *
		 * @param type 频道枚举
		 *
		 */
		public static function getCDbyType(type:int):int {
			switch (type) {
				case ChatEnum.CHANNEL_COMMON:
					return ChatEnum.TIME_COMMON;
					break;
				case ChatEnum.CHANNEL_WORLD:
					return ChatEnum.TIME_WORLD;
					break;
				case ChatEnum.CHANNEL_PRIVATE:
					return ChatEnum.TIME_PRIVATE;
					break;
				case ChatEnum.CHANNEL_TEAM:
					return ChatEnum.TIME_TEAM;
					break;
				case ChatEnum.CHANNEL_GUILD:
					return ChatEnum.TIME_GUILD;
					break
			}
			return -1;
		}

		/**
		 * <T>聊天非法信息过滤</T>
		 *
		 * @param native 原始字符串
		 * @return       过滤后字符串
		 *
		 */
		public static function filtration(native:String):String {
			return native;
		}

		/**
		 * <T>拼接超链接字符串</T>
		 *
		 * @param native   源字符串
		 * @param linkData 超链接源数据
		 * @param channel  频道
		 * @return         处理后字符串
		 *
		 */
		public static function createLinkString(source:String, linkData:Vector.<Object>, channel:int, pName:String=null):String {
			//say|T2李四,你好我们去<<link+3+桃花源=go|{"id"=1,"x":100,"y":200}>>玩吧
			var mLinkTpl:String="<<link+{1}+{2}=go|{\"id\":{3},\"x\":{4},\"y\":{5}}>>";
			var eLinkTpl:String="<<link+{1}+{2}=tips|{3}>>";
			var linkC:int=linkData.length;
			for (var n:int=0; n < linkC; n++) {
				var data:Object=linkData[n];
				var flag:int=data.flag;
//				var linkType:int = StringUtil.getSerLinkType(flag);
				var url:String;
				switch (flag) {
					case ChatEnum.LINK_TYPE_ACTIVE:
						// todo:活动的超链接
						break;
					case ChatEnum.LINK_TYPE_MAP:
						//地图超链接
						if (source.indexOf(data.content) != -1) {
							url=StringUtil_II.translate(mLinkTpl, flag, data.content, data.id, data.xx, data.yy);
						}
						break;
					case ChatEnum.LINK_TYPE_VIP:
						// todo: vip超连接
						break;
					case ChatEnum.LINK_TYPE_ITEM:
						//道具展示超链接
						if (source.indexOf(data.content) != -1) {
							url=StringUtil_II.translate(eLinkTpl, flag, data.content, data.tips.serialize());
						}
						break;
				}
				source=source.replace(data.content, url);
			}
			// 添加协议标志
			var pre:String="T{1}{2},{3}";
			var serChannel:int=StringUtil_II.getSerChannel(channel);
			if (ChatEnum.CHANNEL_PRIVATE == channel) {
				source=StringUtil_II.translate(pre, serChannel, pName, source);
			} else {
				source=StringUtil_II.translate(pre, serChannel, "", source);
			}
			return source;
		}

		/**
		 * <T>生成地图超链接数据</T>
		 *
		 * @param mapId 地图id
		 * @param xx    x坐标
		 * @param yy    y坐标
		 *
		 */
		public static function generateMapLink(mapId:String, mapName:String, xx:Number, yy:Number):Object {
			var o:Object=new Object();
			o.xx=xx;
			o.yy=yy;
			o.id=mapId;
			o.flag=ChatEnum.LINK_TYPE_MAP;
			o.content=StringUtil_II.translate("[{1}[{2},{3}]]", mapName, xx, yy);
			return o;
		}

		/**
		 * <T>生成道具超链接数据</T>
		 *
		 * @param name 道具的名字
		 * @param pos  道具所在包裹的位置
		 *
		 */
		public static function generateItemLink(name:String, tips:Object):Object {
			var o:Object=new Object();
			o.content="[" + name + "]";
			;
			o.tips=tips;
			o.flag=ChatEnum.LINK_TYPE_ITEM;
			return o;
		}

		/**
		 * <T>将数据解码为标准化聊天数据</T>
		 *
		 * @param obj 编码数据
		 * @return    解析数据
		 *
		 */
		public static function decode(obj:Object):ChatContentInfo {
			// 基础数据
			var data:ChatContentInfo=new ChatContentInfo();
			data.vipLv=obj.v;
			data.toUserName=obj.y;
			data.fromUserName=obj.i;
			data.type=StringUtil_II.getClientChannel(obj.t);
			data.channelName=StringUtil_II.getColorStr(StringUtil_II.getAreaF(data.type), ChatEnum.COLOR_USER);
			var fUserName:String="";
			var tUserName:String="";
			// 解析超链接数据
			var content:String=obj.c;
			content=decodeSuperLink(content);
			// 处理正常文本数据
			var focusName:String=MyInfoManager.getInstance().name;
			if (data.fromUserName != focusName) {
				// 说话者不是自己
				fUserName=StringUtil_II.addEventString(ChatEnum.LINK_TYPE_PLAYER + "+{" + data.fromUserName + "}", data.getVipName(), true);
				fUserName=StringUtil_II.getColorStr(fUserName, ChatEnum.COLOR_USER);
				if (ChatEnum.CHANNEL_PRIVATE == data.type) {
					fUserName=fUserName + getChannelColor(PropUtils.getStringById(2003), data.type);
				}
			} else {
				//说话者是自己
				if (ChatEnum.CHANNEL_PRIVATE == data.type) {
					tUserName=StringUtil_II.addEventString(ChatEnum.LINK_TYPE_PLAYER + "+{" + data.toUserName + "}", data.toUserName, true);
					tUserName=StringUtil_II.getColorStr(tUserName, ChatEnum.COLOR_USER);
					tUserName=getChannelColor(PropUtils.getStringById(1888), data.type) + tUserName + getChannelColor(PropUtils.getStringById(2004), data.type);
				} else {
					fUserName=StringUtil_II.getColorStr(data.getVipName(), ChatEnum.COLOR_USER);
				}
			}
			// 添加VIP等级
//			if("" != data.fromUserName){
//				var index:int = fUserName.indexOf(data.fromUserName);
//				fUserName = fUserName.substr(0, index) + getVipKey(data.vipLv) + "  "+fUserName.substr(index);
//			}
			content=getChannelColor("：" + content, data.type);
			if (ChatEnum.CHANNEL_PRIVATE == data.type) {
				// 私聊
				if (data.fromUserName != focusName) {
					data.content=data.channelName + fUserName + content;
				} else {
					data.content=data.channelName + tUserName + content;
				}
			} else {
				// 非私聊
				data.content=data.channelName + fUserName + content;
			}
			data.nativeStr=content.replace("：", "")
			return data;
		}

		/**
		 * <T>解析超链接数据</T>
		 *
		 * @param content 解析内容
		 * @return        解析后内容
		 *
		 */
		public static function decodeSuperLink(content:String):String {
			while (content.indexOf("<<") != -1) {
				var begin:int=content.indexOf("<<");
				var end:int=content.indexOf(">>") + 1;
				var link:String=content.substring(begin, end + 1);

				var flag:int=link.indexOf("+");
				var flagEnd:int=link.indexOf("+", flag + 1);
				var linkName:String=link.substring(flagEnd + 1, link.indexOf("="));
				var linkType:int=int(link.substring(flag + 1, flagEnd));
				// 转换为THML文本
				var tb:int=link.indexOf("{");
				var te:int=link.indexOf("}") + 1;
				var dataStr:String=link.substring(tb, te);
				// 此处将要显示的tips,坐标等信息放入html的linkevent中
				linkName=StringUtil_II.addEventString(linkType + "+" + dataStr, linkName, true);

				// 解析道具颜色
				var obj:Object=com.adobe.serialization.json.JSON.decode(dataStr);
				var itemId:uint=obj.itemid;
				var itemInfo:TItemInfo=TableManager.getInstance().getItemInfo(itemId);
				var equipInfo:TEquipInfo=TableManager.getInstance().getEquipInfo(itemId);
				var qulity:uint;
				if (null != itemInfo) {
					qulity=uint(itemInfo.quality);
				}
				if (null != equipInfo) {
					qulity=uint(equipInfo.quality);
				}
				var color:String="#" + ItemUtil.getColorByQuality(qulity).toString(16).replace("0x");

				// 生成超链接名称
				linkName=getLinkColor(linkName, linkType, color);
				content=content.replace(link, linkName);
			}
			return content;
		}

		/**
		 * <T>创建一个系统提示</T>
		 *
		 * @param notice 提示数据
		 * @return       创建的提示
		 *
		 */
		public static function creatNotice(notice:TNoticeInfo, values:Array):ChatContentInfo {
			var content:ChatContentInfo=new ChatContentInfo();
			content.nativeStr=notice.content;
			content.type=ChatEnum.CHANNEL_SYSTEM;
			content.content=StringUtil.substitute(notice.content, values);
			content.content=getChannelColor(content.content, content.type);
			content.channelName=StringUtil_II.getColorStr(StringUtil_II.getAreaF(content.type), ChatEnum.COLOR_USER);
			return content;
		}

		public static function creatNotice_II(obj:Object):ChatContentInfo {
			var type:String;
			var mapId:String;
			var xx:int;
			var yy:int;
			var msgId:int=obj.msgid;
			var content:String=TableManager.getInstance().getSystemNotice(obj.msgid).content;
			var valueDic:Array=obj.c;
			var values:Array=[];
			for each (var o:Object in valueDic) {
				for (var key:String in o) {
					switch (key) {
						case "user":
						case "kuser":
							var userName:String=o[key];
							if (userName != Core.me.info.name) {
								userName=StringUtil_II.addEventString(ChatEnum.LINK_TYPE_PLAYER + "+{" + userName + "}", userName, true);
							}
							userName=StringUtil_II.getColorStr(userName, ChatEnum.COLOR_USER);
							values.push(userName);
							break;
						case "room":
							var mapName:String=TableManager.getInstance().getSceneInfo(o[key]).name;
							mapName=StringUtil_II.getColorStr(mapName, ChatEnum.COLOR_MAP_POINT);
							values.push(mapName);
							break;
						case "npc":
							var npcName:String=o[key];
							npcName=StringUtil_II.getColorStr(npcName, ChatEnum.COLOR_NPC);
							values.push(npcName);
							break;
						case "itemid":
							var itemId:int=o[key];
							var itemInfo:TItemInfo=TableManager.getInstance().getItemInfo(itemId);
							var equipInfo:TEquipInfo=TableManager.getInstance().getEquipInfo(itemId);
							var qulity:uint;
							var itemName:String;
							if (null != itemInfo) {
								qulity=uint(itemInfo.quality);
								itemName="[" + itemInfo.name + "]";
							}
							if (null != equipInfo) {
								qulity=uint(equipInfo.quality);
								itemName="[" + equipInfo.name + "]";
							}
							var color:String="#" + ItemUtil.getColorByQuality(qulity).toString(16).replace("0x");
							var evtText:String=ChatEnum.LINK_TYPE_ITEM + "+\{\"itemid\":" + itemId + "\}";
							itemName=StringUtil_II.addEventString(evtText, itemName, true);
							itemName=StringUtil_II.getColorStr(itemName, color);
							values.push(itemName);
							break;
						case "sys":
							var sysName:String=getSysName(o[key]);
							var cv:String=getValue(o[key], valueDic);
							var evtSys:String=ChatEnum.LINK_TYPE_ACTIVE + "+\{" + o[key] + "|" + cv + "\}";
							sysName=StringUtil_II.addEventString(evtSys, sysName, true);
							sysName=StringUtil_II.getColorStr(sysName, ChatEnum.COLOR_USER);
							values.push(sysName);
							break;
						case "tips":
							var tipInfo:TipsInfo=new TipsInfo(o[key]);
							var ti:TItemInfo=TableManager.getInstance().getItemInfo(tipInfo.itemid);
							var ei:TEquipInfo=TableManager.getInstance().getEquipInfo(tipInfo.itemid);
							var qt:uint;
							var itemname:String;
							if (null != ti) {
								qt=uint(ti.quality);
								itemname="[" + ti.name + "]";
							}
							if (null != ei) {
								qt=uint(ei.quality);
								itemname="[" + ei.name + "]";
							}
							var cl:String="#" + ItemUtil.getColorByQuality(qt).toString(16).replace("0x");
							var evt:String=ChatEnum.LINK_TYPE_ITEM + "+" + tipInfo.serialize(); //"+\{\"itemid\":"+itemId+"\}";
							itemname=StringUtil_II.addEventString(evt, itemname, true);
							itemname=StringUtil_II.getColorStr(itemname, cl);
							values.push(itemname);
							break;
						case "vnum":
							var vnum:String=StringUtil_II.getColorStr(o[key], ChatEnum.COLOR_USER);
							values.push(vnum);
							break;
						case "mapxy":
							var mapInfo:Array=o[key];
							mapId=mapInfo[0];
							xx=mapInfo[1];
							yy=mapInfo[2];
							var tinfo:TSceneInfo=TableManager.getInstance().getSceneInfo(mapId);
							var mstr:String=StringUtil_II.translate("[{1}[{2},{3}]]", tinfo.name, xx, yy);
							mstr=StringUtil_II.addEventString(ChatEnum.LINK_TYPE_MAP + "+{" + "\"id\":" + mapId + ",\"x\":" + xx + ",\"y\":" + yy + "}", mstr, true);
							mstr=StringUtil_II.getColorStr(mstr, ChatEnum.COLOR_MAP_POINT);
							values.push(mstr);
							type=key;
							break;
					}
				}
			}
			content=StringUtil_II.translate(content, values);
			content=getChannelColor(content, ChatEnum.CHANNEL_SYSTEM);
			var contentInfo:ChatContentInfo=new ChatContentInfo();
			contentInfo.channelName=StringUtil_II.getColorStr(StringUtil_II.getAreaF(contentInfo.type), ChatEnum.COLOR_USER);
			contentInfo.content=contentInfo.channelName + content;
			if (4119 == msgId) {
				UIManager.getInstance().showWindow(WindowEnum.PLAYER_TRACK);
				UIManager.getInstance().playerTrack.updateInfo(content, mapId, xx, yy);
			}
			return contentInfo;
		}

		private static function getValue(type:String, obj:Array):String {
			switch (type) {
				case "cptm":
					return obj[0]["user"];
				default:
					return "";
			}
			return "";
		}

		private static function getSysName(type:String):String {
			switch (type) {
				case "usp":
					return PropUtils.getStringById(2005);
				case "shp":
					return PropUtils.getStringById(2006);
				case "scp":
					return PropUtils.getStringById(2007);
				case "ol":
					return PropUtils.getStringById(2008);
				case "expc":
					return PropUtils.getStringById(2009);
				case "lbox":
					return PropUtils.getStringById(2010);
				case "vip":
					return PropUtils.getStringById(2011);
				case "ddsc":
					return PropUtils.getStringById(2012);
				case "fcz":
					return PropUtils.getStringById(2013);
				case "cptm":
					return PropUtils.getStringById(2014);
				case "pm":
					return PropUtils.getStringById(2015);
				case "warc":
					return PropUtils.getStringById(2016);
			}
			return null;
		}

		/**
		 * <T>获得HTML超链接颜色字符串</T>
		 *
		 * @param str  字符串
		 * @param type 连接类型
		 * @return     HTML连接字符串
		 *
		 */
		public static function getLinkColor(str:String, type:int, color:String=""):String {
			switch (type) {
				case ChatEnum.LINK_TYPE_ITEM:
					return StringUtil_II.getColorStr(str, color);
				case ChatEnum.LINK_TYPE_MAP:
					return StringUtil_II.getColorStr(str, ChatEnum.COLOR_MAP_POINT);
				case ChatEnum.LINK_TYPE_PLAYER:
				case ChatEnum.LINK_TYPE_GUILD:
				case ChatEnum.LINK_TYPE_TEAM:
					return StringUtil_II.getColorStr(str, ChatEnum.COLOR_YELLOW);
				case ChatEnum.LINK_TYPE_VIP:
					return StringUtil_II.getColorStr(str, ChatEnum.COLOR_VIP_GREEN);
			}
			return str;
		}

		/**
		 * <T>获得HTML频道颜色字符串</T>
		 *
		 * @param str  字符串
		 * @param type 频道类型
		 * @return     HTML连接字符串
		 *
		 */
		public static function getChannelColor(str:String, type:int):String {
			switch (type) {
				case ChatEnum.CHANNEL_WORLD:
					return StringUtil_II.getColorStr(str, ChatEnum.COLOR_WORLD);
				case ChatEnum.CHANNEL_PRIVATE:
					return StringUtil_II.getColorStr(str, ChatEnum.COLOR_PRIVATE);
				case ChatEnum.CHANNEL_SYSTEM:
					return StringUtil_II.getColorStr(str, ChatEnum.COLOR_SYSTEM);
				case ChatEnum.CHANNEL_HORN:
					return StringUtil_II.getColorStr(str, ChatEnum.COLOR_HORN);
				case ChatEnum.CHANNEL_TEAM:
					return StringUtil_II.getColorStr(str, ChatEnum.COLOR_TEAM);
				case ChatEnum.CHANNEL_GUILD:
					return StringUtil_II.getColorStr(str, ChatEnum.COLOR_GUILD);
				default:
					return StringUtil_II.getColorStr(str, ChatEnum.COLOR_SYSTEM);
			}
			return str;
		}

		public static function getDisplayObject(key:int):DisplayObject {
			return LibManager.getInstance().getClsMC("face" + key);
		}

		public static function trackPlayer(playerName:String):void {
			var bagInfo:Baginfo=MyInfoManager.getInstance().getBagItemByID(31504);
			if (null != bagInfo) {
				Cmd_Bag.cm_bagUseOf(bagInfo.pos, playerName);
			} else {
				UILayoutManager.getInstance().open(WindowEnum.QUICK_BUY);
				UIManager.getInstance().quickBuyWnd.pushItem(31504, 31505);
				NoticeManager.getInstance().broadcastById(9997);
			}
		}
	}
}
