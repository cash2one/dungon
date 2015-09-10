package com.leyou.ui.boss.children
{
	import com.ace.config.Core;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFieldBossInfo;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.gameData.table.TSceneInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.data.fieldboss.FieldBossInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	
	public class BossWorldLableRender extends AutoSprite
	{
		private var bgImg:Image;
		
		private var refreshTLbl:Label;
		
		private var positionLbl:Label;
		
		private var refreshCheck:CheckBox;
		
		private var flyBtn:ImgButton;
		
		private var selectImg:Image;
		
		private var _bossId:int;
		
		private var _select:Boolean;
		
		private var _listener:Function;
		
		public function BossWorldLableRender(){
			super(LibManager.getInstance().getXML("config/ui/boss/bossWorldLable.xml"));
			init();
		}
		
		public function get bossId():int{
			return _bossId;
		}

		public function set select(value:Boolean):void{
			if(value){
				selectImg.alpha = 1;
			}else{
				selectImg.alpha = 0;
			}
			_select = value;
		}

		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			bgImg = getUIbyID("bgImg") as Image;
			selectImg = getUIbyID("selectImg") as Image;
			refreshTLbl = getUIbyID("refreshTLbl") as Label;
			positionLbl = getUIbyID("positionLbl") as Label;
			refreshCheck = getUIbyID("refreshCheck") as CheckBox;
			positionLbl.mouseEnabled = true;
			flyBtn = getUIbyID("flyBtn") as ImgButton;
			flyBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			positionLbl.addEventListener(MouseEvent.CLICK, onMouseClick);
			refreshCheck.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			var style:StyleSheet = new StyleSheet();
			style.setStyle("a:hover", {color:"#ff0000"});
			positionLbl.styleSheet = style;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			selectImg.alpha = 0;
		}
		
		
		
		protected function onMouseOut(event:MouseEvent):void{
			if(!_select){
				TweenLite.to(selectImg, 0.3, {alpha:0});
			}
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			if(!_select){
				TweenLite.to(selectImg, 0.5, {alpha:1});
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			var bossInfo:TFieldBossInfo = TableManager.getInstance().getFieldBossInfo(_bossId);
			var point:TPointInfo;
			switch(event.target.name){
				case "flyBtn":
					if(ConfigEnum.FieldBossForbiddenLeve <= (Core.me.info.level - bossInfo.openLv)){
						NoticeManager.getInstance().broadcastById(4905, [ConfigEnum.FieldBossForbiddenLeve]);
						return;
					}
					point = TableManager.getInstance().getPointInfo(bossInfo.pointId);
					Cmd_Go.cmGoPoint(int(bossInfo.sceneId), point.tx, point.ty);
					break;
				case "positionLbl":
					point = TableManager.getInstance().getPointInfo(bossInfo.pointId);
					Core.me.gotoMap(new Point(point.tx, point.ty), bossInfo.sceneId, true);
					break;
				case "refreshCheck":
					if(null != _listener){
						_listener.call(this, this, refreshCheck.isOn);
					}
					break;
			}
		}
		
		public function updateInfo(bData:FieldBossInfo):void{
			_bossId = bData.bossId;
			var bossInfo:TFieldBossInfo = TableManager.getInstance().getFieldBossInfo(_bossId);
			var sceneInfo:TSceneInfo = TableManager.getInstance().getSceneInfo(bossInfo.sceneId+"");
			var pt:TPointInfo = TableManager.getInstance().getPointInfo(bossInfo.pointId);
			var color:uint = positionLbl.textColor;
			positionLbl.htmlText = StringUtil.substitute("<font color='{1}'><u><a href='event:tt'>{2}</a></u></font>",color.toString(16), sceneInfo.name);
			var content:String = TableManager.getInstance().getSystemNotice(5009).content;
			if(0 == bData.status){
				// 未刷新
				refreshTLbl.textColor = 0xff0000;
				refreshTLbl.text = StringUtil.substitute(content, bData.killName, getCurrentRT());
			}else if(1 == bData.status){
				// 已刷新
				refreshTLbl.textColor = 0xff00;
				refreshTLbl.text = PropUtils.getStringById(1650);
			}
			bgImg.updateBmp("ui/boss/"+bossInfo.bgPic);
		}
		
		private function getCurrentRT():String{
			var bossInfo:TFieldBossInfo = TableManager.getInstance().getFieldBossInfo(_bossId);
			var timeArr:Array = bossInfo.refreshTimes;
			var tl:int = timeArr.length;
			var date:Date = new Date();
			var ct:int = date.hours*60*60 + date.minutes*60 + date.seconds;
			for(var n:int = 0; n < tl; n++){
				var tArr:Array = timeArr[n].split(",");
				var rt:int = int(tArr[0])*60*60 + int(tArr[1])*60 + int(tArr[2]);
				if(ct < rt){
					tArr.pop();
					return tArr.join(":");
				}
			}
			var pa:RegExp = /,/g;
			return timeArr[0].replace(pa, ":");
		}
		
		public function setRemind(v:Boolean):void{
			v ? refreshCheck.turnOn(false) : refreshCheck.turnOff(false);
		}
		
		public function setRemindListener(fun:Function):void{
			_listener = fun;
		}
	}
}