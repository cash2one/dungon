package com.leyou.ui.fieldBoss
{
	import com.ace.config.Core;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFieldBossInfo;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.fieldboss.FieldBossInfo;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.net.cmd.Cmd_YBS;
	import com.leyou.utils.PropUtils;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class FieldBossRemindWnd extends AutoWindow
	{
		private var desLbl:Label;
		
		private var remindCbx:CheckBox;
		
		private var joinBtn:ImgButton;
		
		private var flyBtn:ImgButton;
		
		private var movie:SwfLoader;
		
		private var bossId:int;
		
		private var movieMask:Shape;
		
		public function FieldBossRemindWnd(){
			super(LibManager.getInstance().getXML("config/ui/fieldBoss/dungeonBossOutPanel.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			movie = new SwfLoader();
			movie.x = 110;
			movie.y = 256;
			addChild(movie);
			movieMask = new Shape(); 
			movie.mask = movieMask;
			addChild(movieMask);
			var g:Graphics = movieMask.graphics;
			g.clear();
			g.beginFill(0xff, 0.5);
			g.drawRoundRect(15, 29, 190, 280, 112, 112);
			g.endFill();
			
			desLbl = getUIbyID("desLbl") as Label;
			remindCbx = getUIbyID("remindCbx") as CheckBox;
			joinBtn = getUIbyID("joinBtn") as ImgButton;
			flyBtn = getUIbyID("flyBtn") as ImgButton;
			remindCbx.addEventListener(MouseEvent.CLICK, onMouseClick);
			joinBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			flyBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			desLbl.multiline = true;
			desLbl.wordWrap = true;
			clsBtn.x -= 6;
			clsBtn.y -= 14;
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			var point:TPointInfo;
			var bossInfo:TFieldBossInfo = TableManager.getInstance().getFieldBossInfo(bossId);
			switch(event.target.name){
				case "remindCbx":
					if(remindCbx.isOn){
						DataManager.getInstance().fieldBossData.setRemind(bossId);
						var monsterInfo:TLivingInfo = TableManager.getInstance().getLivingInfo(bossInfo.monsterId);
						var content:String="        {1}<font color='#ff00'><u><a href='event:other_ycp--{2}'>"+PropUtils.getStringById(1570)+"</a></u></font>";
						content=StringUtil.substitute(content, monsterInfo.name, bossId);
						var arr:Array = [PropUtils.getStringById(1571), content, "", "", Cmd_YBS.callBack];
						UIManager.getInstance().taskTrack.updateOhterTrack(TaskEnum.taskLevel_fieldbossCopyLine, arr);
					}else{
						DataManager.getInstance().fieldBossData.setRemind(0);
						UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_fieldbossCopyLine);
					}
					break;
				case "joinBtn":
					point = TableManager.getInstance().getPointInfo(bossInfo.pointId);
					Core.me.gotoMap(new Point(point.tx, point.ty), bossInfo.sceneId, true);
					break;
				case "flyBtn":
					point = TableManager.getInstance().getPointInfo(bossInfo.pointId);
					Cmd_Go.cmGoPoint(int(bossInfo.sceneId), point.tx, point.ty);
					break;
			}
		}
		
		public function loadInfo(id:int):void{
			bossId = id;
			remindCbx.turnOn(true);
			var bossInfo:TFieldBossInfo = TableManager.getInstance().getFieldBossInfo(id);
			var monsterInfo:TLivingInfo = TableManager.getInstance().getLivingInfo(bossInfo.monsterId);
			movie.update(monsterInfo.pnfId);
			movie.playAct("stand", 4);
			var content:String = TableManager.getInstance().getSystemNotice(5002).content;
			desLbl.htmlText = StringUtil.substitute(content, monsterInfo.name, monsterInfo.level);
		}
	}
}