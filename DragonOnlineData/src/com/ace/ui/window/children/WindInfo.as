package com.ace.ui.window.children {
	import com.leyou.utils.PropUtils;
	
	import flash.geom.Point;
	
	public class WindInfo {
		
		public var title:String;
		public var content:String;
		public var okBtnName:String=PropUtils.getStringById(2072);
		public var cancelBtnName:String=PropUtils.getStringById(1960);
		
		public var isModal:Boolean;
		public var showClose:Boolean;
		public var allowDrag:Boolean=true;
		
		public var ps:Point;
		public var okFun:Function;
		public var cancelFun:Function;
		
		public var radioTex1:String="";
		public var radioTex2:String="";
		
		public var itemId:int;
		
		public function WindInfo() {
		}
		 
		
		static public function getAlertInfo($content:String, okFun:Function=null):WindInfo {
			var info:WindInfo=new WindInfo();
			info.title=PropUtils.getStringById(1549);
			info.content=$content;
			info.okFun=okFun;
			return info;
		}
		
		static public function getConfirmInfo($content:String, okFun:Function=null, cancelFun:Function=null):WindInfo {
			var info:WindInfo=new WindInfo();
			info.title=PropUtils.getStringById(2073);
			info.content=$content;
			info.okFun=okFun;
			info.cancelFun=cancelFun;
			return info;
		}
		
		static public function getInputInfo($content:String, okFun:Function=null, cancelFun:Function=null):WindInfo {
			var info:WindInfo=new WindInfo();
			info.title=PropUtils.getStringById(2074);
			info.content=$content;
			info.okFun=okFun;
			info.cancelFun=cancelFun;
			return info;
		}
		
		static public function getRadioInfo($content:String, okFun:Function=null, cancelFun:Function=null):WindInfo{
			var info:WindInfo=new WindInfo();
			info.title=PropUtils.getStringById(2073);
			info.content=$content;
			info.okFun=okFun;
			info.cancelFun=cancelFun;
			return info;
		}
		
		static public function getRadioIIInfo($content:String, okFun:Function=null, cancelFun:Function=null):WindInfo{
			var info:WindInfo=new WindInfo();
			info.title=PropUtils.getStringById(2073);
			info.content=$content;
			info.okFun=okFun;
			info.cancelFun=cancelFun;
			return info;
		}
	}
}