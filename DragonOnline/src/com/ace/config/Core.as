package com.ace.config {
	import com.ace.enum.PlatformEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.scene.player.MyPlayer;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TServerListInfo;
	import com.ace.manager.LibManager;
	import com.ace.utils.ImageUtil;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;

	public class Core {
		public static var stg:DragonOnline;
		public static var serverIp:String="192.168.10.88";
		public static var loginPort:int=9932;
 

//		public static var serverName:String="S3";
		public static var serverName:String="dev1";
 
		public static var gameName:String="sog";
		public static var userId:String;
		static public var webId:String; //登陆字符串

		public static var me:MyPlayer;
		public static const bugTest:Boolean=false;
		//		public static const bugTest:Boolean=true;
		public static const clientTest:Boolean=false;
		public static const PAY_OPEN:Boolean=true;
		public static var AUTO_CREAT_TIME:uint; //自动创建角色时间
		public static var SPEECK_LEVEL:int;

		public static var URL_REGISTER:String; //注册
		public static var URL_HOME:String; //主页
		public static var URL_DEVELOPERS:String; //开发
		public static var URL_PAY:String="www.baidu.com"; //充值
		public static var URL_HELP:String; //帮助
		public static var URL_BUG:String="http://bbs.360safe.com/forum.php?mod=post&action=newthread&fid=2457"; //问题提交
		public static var URL_BBS:String="http://bbs.no2.cn/forumdisplay.php?fid=66"; //论坛

//		上行：tx|Iopenid,openkey,appid,sig,pf,pfkey,zoneid
		public static var TX_OPENID:String;
		public static var TX_OPENKEY:String;
		public static var TX_APPID:String;
		public static var TX_SIG:String;
		public static var TX_PF:String;
		public static var TX_PFKey:String;
		public static var TX_ZONEID:String;

		public static function setup(obj:Object):void {
			if (obj.hasOwnProperty("version")) {
				(!UIEnum.IS_USE_CDN) && (UIEnum.DATAROOT=obj.dataRoot);
				UIEnum.VERSIONCM=obj.version;
				UIEnum.PLAT_FORM_ID=obj.platform;
				if (!obj.hasOwnProperty("strlgn"))
					return;
				Core.serverIp=obj.ip
				Core.loginPort=obj.port;
				Core.AUTO_CREAT_TIME=obj.autoCreatTime;
				Core.SPEECK_LEVEL=obj.speechlv;
				(Core.SPEECK_LEVEL == 0) && (Core.SPEECK_LEVEL=35);
				Core.webId=obj.strlgn;
				Core.userId=Core.webId.split(",")[0];
				Core.userId=Core.userId.split("Puserid=")[1];
				Core.serverName=Core.webId.split(",")[1];
				Core.serverName=Core.serverName.split("svrid=")[1];

				Core.TX_OPENID=obj.openid;
				Core.TX_OPENKEY=obj.openkey;
				Core.TX_APPID=obj.appid;
				Core.TX_SIG=obj.sig;
				Core.TX_PF=obj.pf;
				Core.TX_PFKey=obj.pfkey;
				Core.TX_ZONEID=obj.zoneid;
			} else {
				UIEnum.PLAT_FORM_ID=PlatformEnum.ID_E7E7PK;
				//调试要登陆的服务器和ip
//				(!UIEnum.IS_USE_CDN) && UIEnum.DATAROOT="http://sogres.oss-cn-hangzhou.aliyuncs.com/webData/dragonResII/";
				(!UIEnum.IS_USE_CDN) && (UIEnum.DATAROOT="http://192.168.10.16/webData/dragonRes/");
//				(!UIEnum.IS_USE_CDN) && (UIEnum.DATAROOT="http://sogres2.leyou365.com/webData/dragonResEn/");
//				(!UIEnum.IS_USE_CDN) && (UIEnum.DATAROOT="http://1251243446.cdn.myqcloud.com/1251243446/sogres/webData/dragonResEn/");
//				(!UIEnum.IS_USE_CDN) && (UIEnum.DATAROOT="http://192.168.10.106/webData/dragonResEn/");
//				Core.serverIp="192.168.10.88";
//				Core.serverIp="s2.1360.leyou365.com";
//				Core.loginPort=9932;
			}

			//
			//			var key:String;
			//			for (key in obj) {
			//				trace(((("属性值：" + key) + "=") + obj[key]));
			//			}
		}

		static public function initRes(obj:Object):void {
			ConfigEnum.init(LibManager.getInstance().getXML("config/table/syscfg.xml"));
			ImageUtil.cutBigImg("ui/num/effect.png", "ui/num/effect.xml");

			var serInfo:TServerListInfo=TableManager.getInstance().getServerInfo(UIEnum.PLAT_FORM_ID);
			(serInfo == null) && (serInfo=TableManager.getInstance().getServerInfo(PlatformEnum.ID_1360));
			if (obj.hasOwnProperty("ip")) {
				Core.serverIp=obj.ip;
				Core.loginPort=obj.port;
			} else {
 
//				Core.serverIp="120.26.0.110";
//				Core.loginPort=9932;
 
//				Core.serverIp="120.26.0.95";
//				Core.loginPort=9932;
 
			}
			if (UIEnum.PLAT_FORM_ID == PlatformEnum.ID_1360) {
				Core.URL_PAY=StringUtil.substitute(serInfo.payUrl, [gameName, serverName, userId, userId]);
			} else if (UIEnum.PLAT_FORM_ID == PlatformEnum.ID_KUGOU) {
				Core.URL_PAY=StringUtil.substitute(serInfo.payUrl, [serverName.substr(1)]);
			} else if (UIEnum.PLAT_FORM_ID == PlatformEnum.ID_E7E7PK) {
				Core.URL_PAY=StringUtil.substitute(serInfo.payUrl, [serverName, userId]);
			} else if (UIEnum.PLAT_FORM_ID == PlatformEnum.ID_14339) {
				Core.URL_PAY=StringUtil.substitute(serInfo.payUrl, [serverName.substr(1)]);
			} else if (UIEnum.PLAT_FORM_ID == PlatformEnum.ID_119WAN) {
				Core.URL_PAY=StringUtil.substitute(serInfo.payUrl, [serverName.substr(1)]);
			} else {
				Core.URL_PAY=serInfo.payUrl;
			}
			Core.URL_HOME=serInfo.homeUrl;
			Core.URL_REGISTER=serInfo.resUrl;
			Core.URL_BBS=serInfo.bbsUrl;
		}

		static public function get isTencent():Boolean {
			return UIEnum.PLAT_FORM_ID == PlatformEnum.ID_TENCENT;
		}



	}
}
