package com.leyou.utils
{
	import com.ace.config.Core;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.VersionManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_QQVip;
	
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class PayUtil
	{
		public static function openPayUrl():void{
			if(!Core.PAY_OPEN){
				PopupManager.showAlert(PropUtils.getStringById(2023), null, false, "pay");
				return;
			}
			if(Core.isTencent){
				UILayoutManager.getInstance().show(WindowEnum.QQ_MARKET);
//				ExternalInterface.call("fusion2.dialog.buy");
			}else{
				navigateToURL(new URLRequest(Core.URL_PAY), "_blank");
			}
		}
		
		public static function buyIB(type:int):void{
			Cmd_QQVip.cm_TX_B(type);
		}
		
		// 1-普通  2-年费
		public static function openQQYellowVipUrl(type:int):void{
			var url:String;
			if(1 == type){
				url = StringUtil.substitute("http://pay.qq.com/qzone/index.shtml?aid=game{appid}.op", Core.TX_APPID);
				navigateToURL(new URLRequest(url));
			}else if(2 == type){
				url = StringUtil.substitute("http://pay.qq.com/qzone/index.shtml?aid=game{appid}.yop&paytime=year", Core.TX_APPID);
				navigateToURL(new URLRequest(url));
			}
		}
		
		public static function payQQYellowVip(time:int):void{
			Cmd_QQVip.cm_TX_H(time);
		}
		
		public static function onPayQQYellowVip($token:String, $actid:String, $zoneid:String, $paytime:int):void{
			var payType:String = ($paytime >= 12) ? "year" : "month";
			var pm:Object = {token:$token , actid:$actid, zoneid:$zoneid, openid:Core.TX_OPENID, version:"v3", paytime:payType};
			ExternalInterface.call("fusion2.dialog.openVipGift", pm);
		}
		
		public static function getCountByType(type:int):int{
			var tarr:Array = ConfigEnum.qqvip3.split("|");
			switch(type){
				case 1:
					return tarr[0];
				case 2:
					return tarr[1];
				case 3:
					return tarr[2];
				case 4:
					return tarr[3];
				case 5:
					return tarr[4];
			}
			return 0;
		}
		
		public static function getIconUrl(type:int):String{
			var tpl:String = "ui/qq/tencent_0{type}.jpg";
			tpl = StringUtil.substitute(tpl, type);
			return UIEnum.DATAROOT+VersionManager.getInstance().urlAddVersion(tpl)
		}
		
		public static function onBuyIB(url:String):void{
			var pm:Object = {param : url, context : "buyIB"};
			if(Core.TX_SANDBOX){
				pm["sandbox"] = true;
			}
			ExternalInterface.call("fusion2.dialog.buy", pm);
		}
		
		//------------------------------------------------------------------
		// 打开用户协议页面
		public static function openUserProtocol():void{
			var url:String = StringUtil.substitute("http://app.opensns.qq.com/app_useragreement?appid={appid}", Core.TX_APPID);
			navigateToURL(new URLRequest(url), "_blank");
		}
		
		// 实名认证
		public static function openVerifyUser():void{
			navigateToURL(new URLRequest("http://jkyx.qq.com/"), "_blank");
		}
		//------------------------------------------------------------------
	}
}