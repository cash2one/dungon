package com.ace.config {
	import com.ace.enum.PlatformEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.scene.player.MyPlayer;
	import com.ace.game.scene.player.part.LivingModel;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TServerListInfo;
	import com.ace.manager.LibManager;
	import com.ace.utils.ImageUtil;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;

	public class Core {

		public static var stg:DragonOnline;
		public static var serverIp:String="192.168.10.88";
//		public static var serverIp:String="101.198.161.235"; // 360
//		public static var serverIp:String="101.198.162.172";
//		public static var serverIp:String="202.55.225.235";
//		public static var serverIp:String="123.206.200.34";
 
//		public static var serverIp:String="101.198.161.235";
		public static var loginPort:int=9932; //简体
//		public static var loginPort:int=9922; //简体 360 
 
//		public static var loginPort:int=9932; //简体
 
//		public static var loginPort:int=9992;//繁体
		public static var isFirstLogin:Boolean=true;
		public static var isDvt:Boolean=false;
 
 
		public static var isChangeIp:Boolean=false;
 
//		public static var isAuto:Boolean=false;
 
 
//		public static var isChangeIp:Boolean=false;
//		public static var isAuto:Boolean=false;

 

		public static var isFromWeb:Boolean;
 
		//		public static var serverName:String="S3";
		public static var serverName:String="dev1";


		public static var gameName:String="sog";
		public static var userId:String;
		public static var webId:String; //登陆字符串
		public static var isWeiduan:Boolean=false;

		public static var me:MyPlayer;
		public static var pet:LivingModel;
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
		public static var URL_WEIDUAN:String="http://bbs.no2.cn/forumdisplay.php?fid=66"; //论坛
		public static var URL_LOG:String="gkey={gkey}&qid={qid}&skey={skey}&time={loginTime}&togame_time={loadedTime}&sign={sign}"; //日志
		public static var LOGIN_KEY:String;
		public static var IS_RE_LOGIN:Boolean=false; //重复登录
		public static var isOpenPay:Boolean;//是否开放支付

		//		上行：tx|Iopenid,openkey,appid,sig,pf,pfkey,zoneid
		public static var TX_OPENID:String;
		public static var TX_OPENKEY:String;
		public static var TX_APPID:String;
		public static var TX_SIG:String;
		public static var TX_PF:String;
		public static var TX_PFKey:String;
		public static var TX_ZONEID:String;
		public static var TX_SANDBOX:Boolean;
		public static var TX_VIPTIP:Boolean;

		public static var KEYWORD_OPEN:Boolean=false;


		private static var sf_arr:Array=["jl588", "987q", "10yi", "yiyimm", "cb007", "66lou"];

//		var flashvars = {};
//		flashvars.url = location.href;
//		flashvars.version="V1.5.45.51";
//		flashvars.platform = "eNext";
//		flashvars.ip = "202.55.225.226";
//		flashvars.port = "9932";
//		flashvars.strlgn = "lgn|Puserid=U381389023427,svrid=S6,fcm=1,timestamp=1441967736,sign=652a5344d379d2dd1b067ec7d770ae3e";
//		flashvars.autoCreatTime = "0";


//		flashvars.gkey = "lzgol";
//		flashvars.skey = "S1";
//		flashvars.qid = "21";
//		flashvars.time = "1463645569";

		public static var gkey:String;
//		public static var skey:String;//serverName
		public static var qid:String;
		public static var loginTime:String;

		static private function on360(obj:Object):void {
			Core.gkey=obj.gkey;
			Core.serverName=obj.skey;
			Core.qid=obj.qid;
			Core.loginTime=obj.time;
		}

		public static function setup(obj:Object):void {
			if (obj.hasOwnProperty("version")) {
				Core.isFromWeb=true;
				(!UIEnum.IS_USE_CDN) && (UIEnum.DATAROOT=obj.dataRoot);
				UIEnum.VERSIONCM=obj.version;
				UIEnum.MULTI_LAN=obj.language;
				UIEnum.PLAT_FORM_ID=obj.platform;
				if (!obj.hasOwnProperty("strlgn"))
					return;
				Core.serverIp=obj.ip
				Core.loginPort=obj.port;
				Core.AUTO_CREAT_TIME=obj.autoCreatTime;
				if (obj.hasOwnProperty("isOpenKW"))
					Core.KEYWORD_OPEN=(obj.isOpenKW == 1) ? true : false;
				Core.SPEECK_LEVEL=obj.speechlv;
				(Core.SPEECK_LEVEL == 0) && (Core.SPEECK_LEVEL=35);
				Core.webId=obj.strlgn;
				Core.userId=Core.webId.split(",")[0];
				Core.userId=Core.userId.split("Puserid=")[1];
				Core.serverName=Core.webId.split(",")[1];
				Core.serverName=Core.serverName.split("svrid=")[1];
				Core.loginTime=Core.webId.split(",")[3];
				Core.loginTime=Core.userId.split("timestamp=")[1];
				Core.isWeiduan=StringUtil.intToBoolean(obj.weiduan);

				on360(obj);

				Core.TX_OPENID=obj.openid;
				Core.TX_OPENKEY=obj.openkey;
				Core.TX_APPID=obj.appid;
				Core.TX_SIG=obj.sig;
				Core.TX_PF=obj.pf;
				Core.TX_PFKey=obj.pfkey;
				Core.TX_ZONEID=obj.zoneid;
				Core.TX_SANDBOX=(obj.sandbox == 1) ? true : false;
				Core.TX_VIPTIP=(obj.vipTip == 1) ? true : false;
				if (sf_arr.indexOf(UIEnum.PLAT_FORM_ID) != -1) {
					UIEnum.PLAT_FORM_ID=PlatformEnum.ID_SF;
				}
			} else {
				UIEnum.PLAT_FORM_ID=PlatformEnum.ID_360_OPEN;
				//调试要登陆的服务器和ip
				//				(!UIEnum.IS_USE_CDN) && UIEnum.DATAROOT="http://sogres.oss-cn-hangzhou.aliyuncs.com/webData/dragonResII/";
				//				(!UIEnum.IS_USE_CDN) && (UIEnum.DATAROOT="http://192.168.10.106/webData/dragonResEn/");
 
//				(!UIEnum.IS_USE_CDN) && (UIEnum.DATAROOT="http://192.168.10.16/webData/dragonResAuto/");
				(!UIEnum.IS_USE_CDN) && (UIEnum.DATAROOT="http://192.168.10.66/webData/dragonResCN/");
 
//				(!UIEnum.IS_USE_CDN) && (UIEnum.DATAROOT="http://192.168.10.66/webData/dragonResCN/");
//				(!UIEnum.IS_USE_CDN) && (UIEnum.DATAROOT="http://192.168.10.106/webData/dragonResAuto/");
 
//				(!UIEnum.IS_USE_CDN) && (UIEnum.DATAROOT="http://sogres3.leyou365.com/webData/dragonResCN/");
//				(!UIEnum.IS_USE_CDN) && (UIEnum.DATAROOT="http://192.168.10.16/webData/dragonResTW/");
					//				(!UIEnum.IS_USE_CDN) && (UIEnum.DATAROOT="http://sogres2.leyou365.com/webData/dragonResEn/");
					//				(!UIEnum.IS_USE_CDN) && (UIEnum.DATAROOT="http://1251243446.cdn.myqcloud.com/1251243446/sogres/webData/dragonResEn/");
					//				(!UIEnum.IS_USE_CDN) && (UIEnum.DATAROOT="http://192.168.10.106/webData/dragonResEn/");
					//				Core.serverIp="192.168.10.88";
					//				Core.serverIp="s2.1360.leyou365.com";
					//				Core.loginPort=9932;
			}

			//
			var key:String;
			for (key in obj) {
				trace(((("属性值：" + key) + "=") + obj[key]));
			}
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
				//								Core.serverIp="120.26.1.109";
				//								Core.loginPort=9932;

			}

			if (obj.hasOwnProperty("logUrl")) {
				Core.URL_LOG=obj.logUrl + Core.URL_LOG;
				Core.LOGIN_KEY=obj.login_key;
			}
			if (obj.hasOwnProperty("payUrl")) {
				Core.URL_HOME=obj.homeUrl;
				Core.URL_REGISTER=obj.resUrl;
				Core.URL_BBS=obj.bbsUrl;
				Core.URL_PAY=obj.payUrl;
				Core.URL_WEIDUAN=obj.weiDuanUrl;
				return;
			}

			Core.URL_HOME=serInfo.homeUrl;
			Core.URL_REGISTER=serInfo.resUrl;
			Core.URL_BBS=serInfo.bbsUrl;



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
			} else if (UIEnum.PLAT_FORM_ID == PlatformEnum.ID_517KD) {
				Core.URL_PAY=StringUtil.substitute(serInfo.payUrl, [serverName.substr(1), userId]);
			} else if (UIEnum.PLAT_FORM_ID == PlatformEnum.ID_76JU) {
				Core.URL_PAY=StringUtil.substitute(serInfo.payUrl, [userId]);
				Core.URL_HOME=StringUtil.substitute(serInfo.homeUrl, [userId]);
				Core.URL_REGISTER=StringUtil.substitute(serInfo.resUrl, [userId]);
				Core.URL_BBS=StringUtil.substitute(serInfo.bbsUrl, [userId]);
			} else {
				Core.URL_PAY=serInfo.payUrl;
			}
		}

		static public function get isTencent():Boolean {
			return (true);
//			return (UIEnum.PLAT_FORM_ID == PlatformEnum.ID_TENCENT) || (UIEnum.PLAT_FORM_ID == PlatformEnum.ID_AOYI);
		}

		static public function get isAOYI():Boolean {
			return (UIEnum.PLAT_FORM_ID == PlatformEnum.ID_AOYI);
		}

		static public function get isSF():Boolean {
			return (UIEnum.PLAT_FORM_ID == PlatformEnum.ID_SF) || (UIEnum.PLAT_FORM_ID == PlatformEnum.ID_SF2);
		}

		static public function get isSF1():Boolean {
			return (UIEnum.PLAT_FORM_ID == PlatformEnum.ID_SF);
		}

		static public function get isSF2():Boolean {
			return (UIEnum.PLAT_FORM_ID == PlatformEnum.ID_SF2);
		}

		static public function get isTaiwan():Boolean {
			return (UIEnum.MULTI_LAN == PlatformEnum.LAN_TW);
		}

		static public function resetLogin():void {
			Core.IS_RE_LOGIN=false;
		}

		static public function get isAuto():Boolean {
			return UIEnum.IS_AUTO;
		}
	}
}
