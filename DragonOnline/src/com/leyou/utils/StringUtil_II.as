package com.leyou.utils {
	import com.ace.config.Core;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.leyou.enum.ChatEnum;

	import flash.text.TextField;
	import flash.utils.ByteArray;

	public class StringUtil_II {

		public function StringUtil_II() {
		}

		/**
		 *添加超链接
		 * @param f
		 * @param str
		 * @param u
		 * @return
		 *
		 */
		public static function addEventString(evt:String, value:String, u:Boolean=false):String {
			if (u && ("" != value)) {
				value="<u><a href='event:" + evt + "'>" + value + "</a></u>";
			} else if ("" != value) {
				value="<a href='event:" + evt + "'>" + value + "</a>";
			}
			return value;
		}

		/**
		 * <T>返回有颜色字符串</T>
		 *
		 * @param str   字符串
		 * @param color 颜色
		 * @param size  字体尺寸
		 * @return      带颜色的字符串
		 *
		 */
		public static function getColorStr(value:String, color:String, size:int=12):String {
			var tpl:String="<font face='SimSun' color='{1}' size='{2}'>{3}</font>";
			return translate(tpl, color, size, value);
		}

		/**
		 * <T>返回有颜色字符串</T>
		 *
		 * @param str   字符串
		 * @param color 颜色
		 * @param face  字体
		 * @param size  字体尺寸
		 * @return      带颜色的字符串
		 *
		 */
		public static function getColorStrByFace(str:String, color:String, face:String="SimSun", size:int=12):String {
			var tpl:String="<font color='{1}' size='{2}'face='{3}'>{4}</font>";
			return translate(tpl, color, size, face, str);
		}

		public static function getChatColorStr(str:String, type:String, link:Object):String {
			switch (type) {
				case ChatEnum.EVENT_ITEM_FLAG:
					return getColorStr(str, ChatEnum.COLOR_TEAM);
				case ChatEnum.EVENT_MAP_FLAG:
					return getColorStr(str, ChatEnum.COLOR_MAP_POINT);
					break;
				case ChatEnum.EVENT_NAME_FLAG:
					return getColorStr(str, ChatEnum.COLOR_YELLOW);
					break;
				case ChatEnum.EVENT_VIP_FLAG:
					return getColorStr(str, ChatEnum.COLOR_VIP_GREEN);
					break;
			}
			return str;
		}

		public static function sertSign(num:Number, sign:String=","):String {
			var value:String=num + "";
			var fraction:String;
			var index:int=value.indexOf(".");
			if (index > -1) {
				fraction=value.substr(index);
				value=value.substr(0, index);
			}
			var length:int=value.length;
			while ((length - 4) > 0) {
				value=value.substr(0, length - 4) + sign + value.substr(length - 4);
				length-=4;
			}
			if (index > -1) {
				value+=("." + fraction);
			}
			return value;
		}

		/////////////////////////////////////////////////////聊天用
		/**
		 *聊天专用   有服务器的超链接类型转换成客户端的超链接标志
		 * @param type
		 * @return
		 *
		 */
		public static function getEventType(type:int):String {
			switch (type) {
				case ChatEnum.LINK_TYPE_ITEM:
					return ChatEnum.EVENT_ITEM_FLAG;
					break;
				case ChatEnum.LINK_TYPE_MAP:
					return ChatEnum.EVENT_MAP_FLAG;
					break;
				case ChatEnum.LINK_TYPE_PLAYER:
					return ChatEnum.EVENT_NAME_FLAG;
					break;
				case ChatEnum.LINK_TYPE_VIP:
					return ChatEnum.EVENT_VIP_FLAG;
					break;
				case ChatEnum.LINK_TYPE_ACTIVE:
					return ChatEnum.EVENT_ACTIVE_FLAG;
			}
			return null;
		}

		/**
		 * 返回服务器中的超链接标志
		 * @param type
		 * @return
		 *
		 */
		public static function getSerLinkType(type:String):int {
			var u:int;
			switch (type) {
				case ChatEnum.EVENT_ITEM_FLAG:
					u=ChatEnum.LINK_TYPE_ITEM;
					break;
				case ChatEnum.EVENT_MAP_FLAG:
					u=ChatEnum.LINK_TYPE_MAP;
					break;
				case ChatEnum.EVENT_NAME_FLAG:
					u=ChatEnum.LINK_TYPE_PLAYER;
					break;
				case ChatEnum.EVENT_VIP_FLAG:
					u=ChatEnum.LINK_TYPE_VIP;
					break;
			}
			return u;
		}

		/**
		 * 由服务器的的频道标志 返回 客户端的频道标志
		 *1 : 喇叭
		 2 ：世界
		 3 ：帮派
		 4 ：队伍
		 5 ：私聊
		 6 ：普通
		 * @param c
		 * @return
		 *
		 */
		public static function getClientChannel(c:int):int {
			var i:int;
			switch (c) {
				case 1:
					i=ChatEnum.CHANNEL_HORN;
					break;
				case 2:
					i=ChatEnum.CHANNEL_WORLD;
					break;
				case 3:
					i=ChatEnum.CHANNEL_GUILD;
					break;
				case 4:
					i=ChatEnum.CHANNEL_TEAM;
					break;
				case 5:
					i=ChatEnum.CHANNEL_PRIVATE;
					break;
				case 6:
					i=ChatEnum.CHANNEL_COMMON;
					break;
			}
			return i;
		}

		/**
		 *由客户端的频道标志 返回服务器的频道标志
		 * @param c
		 * @return
		 *
		 */
		public static function getSerChannel(c:int):int {
			var i:int;
			switch (c) {
				case ChatEnum.CHANNEL_HORN:
					i=1;
					break;
				case ChatEnum.CHANNEL_WORLD:
					i=2;
					break;
				case ChatEnum.CHANNEL_GUILD:
					i=3;
					break;
				case ChatEnum.CHANNEL_TEAM:
					i=4;
					break;
				case ChatEnum.CHANNEL_PRIVATE:
					i=5;
					break;
				case ChatEnum.CHANNEL_COMMON:
					i=6;
					break;
			}
			return i;
		}

		/**
		 *返回频道区域的文字显示
		 * @param c
		 * @return
		 *
		 */
		public static function getAreaF(c:int):String {
			var str:String;
			switch (c) {
				case ChatEnum.CHANNEL_COMMON:
					str=PropUtils.getStringById(2045);
					str=getColorStr(str, ChatEnum.COLOR_COMMON);
					break;
				case ChatEnum.CHANNEL_GUILD:
//					str=PropUtils.getStringById(2046);
//					str=getColorStr(str, ChatEnum.COLOR_GUILD);
					str="\\64 ";
					break;
				case ChatEnum.CHANNEL_HORN:
//					str=PropUtils.getStringById(2047);
//					str=getColorStr(str, ChatEnum.COLOR_HORN);
					str="\\65 ";
					break;
				case ChatEnum.CHANNEL_MAP:
					str=PropUtils.getStringById(2048);
					str=getColorStr(str, ChatEnum.COLOR_MAP);
					break;
				case ChatEnum.CHANNEL_PRIVATE:
//					str=PropUtils.getStringById(2049);
//					str=getColorStr(str, ChatEnum.COLOR_PRIVATE);
					str="\\62 ";
					break;
				case ChatEnum.CHANNEL_SYSTEM:
//					str=PropUtils.getStringById(2050);
//					str=getColorStr(str, ChatEnum.COLOR_SYSTEM);
					str="\\60 ";
					break;
				case ChatEnum.CHANNEL_TEAM:
//					str=PropUtils.getStringById(2051);
//					str=getColorStr(str, ChatEnum.COLOR_TEAM);
					str="\\63 ";
					break;
				case ChatEnum.CHANNEL_WORLD:
//					str=PropUtils.getStringById(2052);
//					str=getColorStr(str, ChatEnum.COLOR_WORLD);
					str="\\61 ";
					break;
				default:
//					str=PropUtils.getStringById(2050);
//					str=getColorStr(str, ChatEnum.COLOR_SYSTEM);
					str="\\60 ";
					break;
			}
			return str;
		}

		/**
		 * 返回原始信息
		 * @param str
		 * @return
		 *
		 */
		public static function getPreInfo(str:String):String {
			var t:TextField=new TextField();
			t.text=str;
			return t.text;
		}

		/**
		 *返回超链接的信息
		 * @param str
		 * @return
		 *
		 */
		public static function setLinkObj(str:String):Object {
			var arr:Array=str.split(";");
			var obj:Object=new Object();
			obj.link=arr[0];
			obj.type=arr[1];
			obj.name=arr[2];
			return obj;
		}

		/**
		 * <T>替换埋入参数</T>
		 *
		 * @param ps   源字符串
		 * @param args 参数值
		 * @return     替换后的字符串
		 *
		 */
		public static function translate(ps:String, ... args):String {
			var count:int=1;
			var c:int=args.length;
			for (var n:int=0; n < c; n++) {
				if (args[n] is Array) {
					var l:int=args[n].length;
					for (var m:int=0; m < l; m++) {
						ps=ps.replace("{" + count + "}", args[n][m]);
						count++;
					}
				} else {
					ps=ps.replace("{" + (n + 1) + "}", args[n]);
				}
			}
			return ps;
		}

		/**
		 * <T>获得字符串字节个数</T>
		 *
		 * @param value 字符串
		 * @return      字节个数
		 *
		 */
		public static function lengthOf(value:String):int {
			var len:int=0;
			var count:int=value.length;
			for (var i:int=0; i < count; i++) {
				if (value.charCodeAt(i) < 256) {
					len+=1;
				} else {
					len+=2;
				}
			}
			return len
		}

		/**
		 * <T>截取制定字节数长度的字符串</T>
		 *
		 * @param value 字符串
		 * @param len   截取长度
		 * @return      处理后的字符串
		 *
		 */
		public static function substr(value:String, len:int):String {
			var str:String=value.substring(0, value.length - 1);
			while (lengthOf(str) > len) {
				str=value.substring(0, str.length - 1);
			}
			return str;
		}

		/**
		 * <T>删除非可见字符。</T>
		 *
		 * @param s 字符串
		 * @return  处理结果
		 *
		 */
		public static function replaceBlank(s:String):String {
			return s.replace(/\s|/g, "");
		}

		/**
		 * <T>删除左侧非可见字符。</T>
		 *
		 * @param p 字符串
		 * @param s 要删除内容
		 * @return  处理结果
		 *
		 */
		public static function ltrim(p:String, s:String=null):String {
			if (null != p) {
				var c:int=p.length;
				var n:int=0;
				if (null == s) {
					while ((n < c) && (p.charCodeAt(n) <= 32)) {
						n++;
					}
				} else {
					while ((n < c) && ((p.charCodeAt(n) <= 32) || (-1 != s.indexOf(p.charAt(n))))) {
						n++;
					}
				}
				if (n != 0) {
					p=p.substr(n, c - n);
				}
			} else {
				p="";
			}
			return p;
		}

		/**
		 * <T>删除右侧非可见字符。</T>
		 *
		 * @param p 字符串
		 * @param s 要删除内容
		 * @return  处理结果
		 *
		 */
		public static function rtrim(p:String, s:String=null):String {
			if (null != p) {
				var c:int=p.length - 1;
				var n:int=c;
				if (null == s) {
					while ((n >= 0) && (p.charCodeAt(n) <= 32)) {
						n--;
					}
				} else {
					while ((n >= 0) && ((p.charCodeAt(n) <= 32) || (-1 != s.indexOf(p.charAt(n))))) {
						n--;
					}
				}
				if (n != c) {
					p=p.substr(0, n + 1);
				}
			} else {
				p="";
			}
			return p;
		}

		/**
		 * <T>删除两侧非可见字符。</T>
		 *
		 * @param value 字符串
		 * @param s     要删除内容
		 * @return      处理结果
		 *
		 */
		public static function trim(value:String, s:String=null):String {
			return ltrim(rtrim(value, s), s);
		}

		/**
		 * <T>返回特殊字符限制</T>
		 *
		 * @return 字符的ascII范围
		 *
		 */
		public static function unusualCharRestrict():String {
			return "^\u0021-\u002f \u003a-\u0040 \u005b-\u0060 \u007b-\u007e";
		}

		public static function hasIllegalWord(word:String):Boolean {
			if (null == word || "" == word) {
				return true;
			}
			var byteArr:ByteArray=LibManager.getInstance().getBinary("config/table/keyword.txt");
			byteArr.position=0;
			var content:String=byteArr.readMultiByte(byteArr.length, "utf-8");
			content=content.replace(/\r+/g, "");
			var ctx:Array=content.split("-----");
			var words:Array=ctx[0].split("\n");
			for (var i:int=0; i < word.length; i++) {
				var illegalWord:String=words[i];
				if ((null != illegalWord) && ("" != illegalWord) && (word.indexOf(illegalWord) > -1)) {
					return true;
				}
			}
			return false;
		}

		/**
		 * 行会违法禁字
		 * @param s
		 * @return
		 *
		 */
		public static function getGuildFilterWord(s:String):String {

			if (s == null || s == "")
				return "";

			var by:ByteArray=LibManager.getInstance().getBinary("config/table/keyword.txt");
			by.position=0;
			var content:String=by.readMultiByte(by.length, "utf-8");

			content=content.replace(/\r+/g, "");

			var ctx:Array=content.split("-----");
			var word:Array=ctx[0].split("\n");

			for (var i:int=0; i < word.length; i++) {
				if (word[i] != "" && word[i] != null && s.indexOf(word[i]) > -1)
					s=s.replace(word[i], "***");
			}

			word=ctx[1].split("\n");

			var cword:Array=[];
			var bword:Array=[];
			var _i:int=0;
			var sp:int=9999;
			var ep:int=-1;
			var ps:int=-1;
			for (i=0; i < word.length; i++) {

				cword=word[i].split("");
				_i=0;
				sp=9999;
				ep=-1;
				ps=-1;
				for (var j:int=0; j < cword.length; j++) {
					if (cword[j] != "" && cword[j] != null && s.indexOf(cword[j]) > -1) {

						ps=s.indexOf(cword[j]);

						if (ps < sp)
							sp=ps;

						if (ps > ep)
							ep=ps;

						_i++;
					}
				}

				//				if (cword.length == _i)
				//					return "";

				//				trace(ep, sp, ps, _i, j,cword)

				if (_i == j) {
					//					trace(cword[j], "|", cword)
					bword=s.split("");
					for (j=sp; j <= ep; j++) {
						bword[j]="*";
					}

					s=bword.join("");
				}
					//else if (ep - sp >= 10) {
					//					s="语言中包含敏感词语";
					//					NoticeManager.getInstance().broadcast();
					//	UIManager.getInstance().chatWnd.chatNotice(TableManager.getInstance().getSystemNotice(3411).content);
					//	return "";
					//}

			}

			return s;

		}

		public static function getFilterWord(s:String):String {

			if (!Core.KEYWORD_OPEN)
				return s;

			if (s == null || s == "")
				return "";

			var by:ByteArray=LibManager.getInstance().getBinary("config/table/keyword.txt");
			by.position=0;
			var content:String=by.readMultiByte(by.length, "utf-8");

			content=content.replace(/\r+/g, "");

			var ctx:Array=content.split("-----");
			var word:Array=ctx[0].split("\n");

			for (var i:int=0; i < word.length; i++) {
				if (word[i] != "" && word[i] != null && s.indexOf(word[i]) > -1)
					s=s.replace(word[i], "***");
			}

			word=ctx[1].split("\n");

			var cword:Array=[];
			var bword:Array=[];
			var _i:int=0;
			var sp:int=9999;
			var ep:int=-1;
			var ps:int=-1;
			for (i=0; i < word.length; i++) {

				cword=word[i].split("");
				_i=0;
				sp=9999;
				ep=-1;
				ps=-1;
				for (var j:int=0; j < cword.length; j++) {
					if (cword[j] != "" && cword[j] != null && s.indexOf(cword[j]) > -1) {

						ps=s.indexOf(cword[j]);

						if (ps < sp)
							sp=ps;

						if (ps > ep)
							ep=ps;

						_i++;
					}
				}

				//				if (cword.length == _i)
				//					return "";

//				trace(ep, sp, ps, _i, j,cword)

				if (_i == j) {
//					trace(cword[j], "|", cword)
					bword=s.split("");
					for (j=sp; j <= ep; j++) {
						bword[j]="*";
					}

					s=bword.join("");
				} else if (ep - sp >= 10) {
					//					s="语言中包含敏感词语";
					//					NoticeManager.getInstance().broadcast();
					UIManager.getInstance().chatWnd.chatNotice(TableManager.getInstance().getSystemNotice(3411).content);
					return "";
				}

			}

			return s;

		}

		/**
		 * 根据长度折行
		 * @param str
		 * @param i
		 * @return
		 *
		 */
		public static function getBreakLineStringByCharIndex(s:String, i:int=19):String {
			var str:String="";
			var _i:int=0;
			if (s.length > i) {
				while (_i < s.length) {
					if (_i != 0 && _i % i == 0)
						str+="\n";

					str+=s.charAt(_i);
					_i++;
				}
			} else {
				str=s;
			}


			return str;
		}


		//============================================================
		// <T>左补齐字符到指定长度。</T>
		//
		// @param pv:value 字符串
		// @param pl:length 长度
		// @param pp:pad 补齐字符
		// @return 字符串
		//============================================================
		public static function lpad(pv:String, pl:int, pp:String=" "):String {
			var r:String="";
			if (null != pv) {
				r=pv.toString();
			}
			var c:int=pl - r.length;
			if (c > 0) {
				for (var n:int=0; n < c; n++) {
					r=pp + r;
				}
			}
			return r;
		}
	}
}
