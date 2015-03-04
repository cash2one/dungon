package com.leyou.ui.boss.children
{
	import com.ace.config.Core;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFieldBossInfo;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.gameData.table.TSceneInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.fieldboss.FieldBossInfo;
	import com.leyou.net.cmd.Cmd_Go;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	
	public class BossNormalLableRender extends AutoSprite
	{
		private var nameLbl:Label;
		
		private var lvLbl:Label;
		
		private var refreshTLbl:Label;
		
		private var statusLbl:Label;
		
		private var mapLbl:Label;
		
		private var findLbl:Label;
		
		private var flyBtn:ImgButton;
		
		private var _bossId:int;
		
		private var bgImg:Image;
		
		private var _select:Boolean;
		
		public function BossNormalLableRender(){
			super(LibManager.getInstance().getXML("config/ui/boss/bossNormalLabel.xml"));
			init();
		}
		
		public function set select(value:Boolean):void{
			_select = value;
			if(value){
				bgImg.updateBmp("ui/boss/list_bg3.png");
			}else{
				bgImg.updateBmp("ui/boss/list_bg2.png");
			}
		}

		public function get bossId():int{
			return _bossId;
		}

		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			bgImg = getUIbyID("bgImg") as Image;
			nameLbl = getUIbyID("nameLbl") as Label;
			lvLbl = getUIbyID("lvLbl") as Label;
			refreshTLbl = getUIbyID("refreshTLbl") as Label;
			statusLbl = getUIbyID("statusLbl") as Label;
			mapLbl = getUIbyID("mapLbl") as Label;
			findLbl = getUIbyID("findLbl") as Label;
			flyBtn = getUIbyID("flyBtn") as ImgButton;
			findLbl.mouseEnabled = true;
			
			var style:StyleSheet = new StyleSheet();
			style.setStyle("a:hover", {color:"#ff0000"});
			findLbl.styleSheet = style;
			var text:String = findLbl.text;
			var color:uint = findLbl.textColor;
			
			var htx:String = StringUtil.substitute("<font color='{1}'><u><a href='event:tt'>{2}</a></u></font>",color.toString(16), text); 
			findLbl.htmlText = htx;
			
			flyBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			findLbl.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			if(!_select){
				bgImg.updateBmp("ui/boss/list_bg2.png");
			}
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			if(!_select){
				bgImg.updateBmp("ui/boss/list_bg3.png");
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			var bossInfo:TFieldBossInfo = TableManager.getInstance().getFieldBossInfo(_bossId);
			var point:TPointInfo;
			switch(event.target.name){
				case "flyBtn":
					point = TableManager.getInstance().getPointInfo(bossInfo.pointId);
					Cmd_Go.cmGoPoint(int(bossInfo.sceneId), point.tx, point.ty);
					break;
				case "findLbl":
					point = TableManager.getInstance().getPointInfo(bossInfo.pointId);
					Core.me.gotoMap(new Point(point.tx, point.ty), bossInfo.sceneId, true);
					break;
			}
		}
		
		public function updateInfo(data:FieldBossInfo):void{
			_bossId = data.bossId;
			var bossInfo:TFieldBossInfo = TableManager.getInstance().getFieldBossInfo(_bossId);
			var monsterInfo:TLivingInfo = TableManager.getInstance().getLivingInfo(bossInfo.monsterId);
			var sceneInfo:TSceneInfo = TableManager.getInstance().getSceneInfo(bossInfo.sceneId+"");
			nameLbl.text = monsterInfo.name.replace("[BOSS]", "") +"[lv"+monsterInfo.level+"]";
			lvLbl.text = bossInfo.openLv+"";
			refreshTLbl.text = bossInfo.refreshTimes[0]/60+"分钟";
			statusLbl.text = (1 == data.status) ? "已刷新" : "已击杀";
			statusLbl.textColor = (1 == data.status) ? 0xff00 : 0xff0000;
			mapLbl.text = sceneInfo.name;
			
		}
	}
}