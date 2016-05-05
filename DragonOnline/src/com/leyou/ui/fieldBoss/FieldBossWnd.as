package com.leyou.ui.fieldBoss {
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFieldBossInfo;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.fieldboss.FieldBossData;
	import com.leyou.data.fieldboss.FieldBossInfo;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.net.cmd.Cmd_YBS;
	import com.leyou.ui.fieldBoss.chlid.FieldBossRender;
	import com.leyou.utils.PropUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	public class FieldBossWnd extends AutoWindow {
		private var prevBtn:ImgButton;

		private var nextBtn:ImgButton;

		protected var items:Vector.<FieldBossRender>;

		protected var pannel:Sprite;

		protected var currentPage:int;

		private var threshold:int;

		private var desLbl:Label;

		private var reBossItem:FieldBossRender;

		public function FieldBossWnd() {
			super(LibManager.getInstance().getXML("config/ui/dungeonBossOutWnd.xml"));
			init();
		}

		private function init():void {
			items=new Vector.<FieldBossRender>();
			prevBtn=getUIbyID("prevBtn") as ImgButton;
			nextBtn=getUIbyID("nextBtn") as ImgButton;
			desLbl=getUIbyID("desLbl") as Label;
			prevBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			nextBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

			var tf:TextFormat=desLbl.defaultTextFormat;
			tf.leading=5;
			desLbl.defaultTextFormat=tf;
//			var tArr:Array = TableManager.getInstance().getFieldBossInfo(1).refreshTimes.concat();
//			var l:int = tArr.length;
//			for(var n:int = 0; n < l; n++){
//				var ttArr:Array = tArr[n].split(",");
//				tArr[n] = ttArr.join(":");
//			}
			var content:String=TableManager.getInstance().getSystemNotice(5004).content;
			desLbl.htmlText=content;
			pannel=new Sprite();
			pannel.x=60;
			pannel.y=73;
			pannel.scrollRect=new Rectangle(0, 0, 611, 351);
			addChild(pannel);

			hideBg();

			initTableInfo();
		}

		public override function get width():Number {
			return 736;
		}

		public override function get height():Number {
			return 498;
		}

		/**
		 * <T>按钮点击</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		protected function onMouseClick(event:MouseEvent):void {
			var n:String=event.target.name;
			switch (n) {
				case "prevBtn":
					previousPage();
					break;
				case "nextBtn":
					nextPage();
					break;
			}
		}

		/**
		 * <T>翻下一页</T>
		 *
		 */
		protected function nextPage():void {
			if (currentPage < (Math.ceil(items.length / 3) - 1) * 3) {
				scrollToX(++currentPage * 204);
			}
		}

		/**
		 * <T>翻上一页</T>
		 *
		 */
		protected function previousPage():void {
			if (currentPage > 0) {
				scrollToX(--currentPage * 204);
			}
		}

		/**
		 * <T>要滚动到的位置</T>
		 *
		 * @param $threshold 滚动位置
		 *
		 */
		protected function scrollToX($threshold:int):void {
			threshold=$threshold;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		/**
		 * <T>滚动刷新</T>
		 *
		 */
		protected function onEnterFrame(event:Event):void {
			var rect:Rectangle=pannel.scrollRect;
			if ((threshold - rect.x) > 12) {
				rect.x+=12;
			} else if ((threshold - rect.x) < 12) {
				rect.x-=12;
			} else {
				rect.x=threshold;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			pannel.scrollRect=rect;
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
//			Cmd_YBS.cm_YBS_I();
			//			UIManager.getInstance().showWindow(WindowEnum.FIELD_BOSS_REMIND);
//			UIManager.getInstance().creatWindow(WindowEnum.FIELD_BOSS_TRACK);
//			UIManager.getInstance().fieldBossTrack.show();
		}

		public function initTableInfo():void {
			var tfBossDic:Object=TableManager.getInstance().getFieldBossDic();
			for (var key:String in tfBossDic) {
				var tbInfo:TFieldBossInfo=tfBossDic[key];
				var item:FieldBossRender=new FieldBossRender();
				item.setRemindListener(onRemindClick);
				item.updateInfoByTable(tbInfo);
				item.x=items.length * 204;
				pannel.addChild(item);
				items.push(item);

				if (tbInfo.openLv > Core.me.info.level) {
					item.mouseEnabled=false;
					item.mouseChildren=false;
					item.filters=[FilterEnum.enable];
				} else {
					item.mouseEnabled=true;
					item.mouseChildren=true;
					item.filters=null;
				}
			}
			var data:FieldBossData=DataManager.getInstance().fieldBossData;
			var rbid:int=data.getRemindId();
			for each (var fitem:FieldBossRender in items) {
				if (null != fitem) {
					if (rbid == fitem.bossId) {
						reBossItem=fitem;
						fitem.setRemind(true);
					} else {
						fitem.setRemind(false);
					}
				}
			}
		}

		public function refreshBossItem():void {
			for each (var item:FieldBossRender in items) {
				if (null != item) {
					var tbInfo:TFieldBossInfo=TableManager.getInstance().getFieldBossInfo(item.bossId);
					if (tbInfo.openLv > Core.me.info.level) {
						item.mouseEnabled=false;
						item.mouseChildren=false;
						item.filters=[FilterEnum.enable];
					} else {
						item.mouseEnabled=true;
						item.mouseChildren=true;
						item.filters=null;
					}
				}
			}
		}

		private function onRemindClick(bossRender:FieldBossRender, v:Boolean):void {
			var data:FieldBossData=DataManager.getInstance().fieldBossData;
			if (v) {
				if (null != reBossItem) {
					reBossItem.setRemind(false);
				}
				bossRender.setRemind(true);
				reBossItem=bossRender;
				data.setRemind(bossRender.bossId);
				var bossInfo:TFieldBossInfo=TableManager.getInstance().getFieldBossInfo(bossRender.bossId);
				var monsterInfo:TLivingInfo=TableManager.getInstance().getLivingInfo(bossInfo.monsterId);
				var fbInfo:FieldBossInfo=DataManager.getInstance().fieldBossData.getBossInfo(bossRender.bossId);
				var content:String="        {1}<font color='#ff00'><u><a href='event:other_ycp--{2}'>" + PropUtils.getStringById(1570) + "</a></u></font>";
				content=StringUtil.substitute(PropUtils.getStringById(2452),DataManager.getInstance().fieldBossData.lastCount);
				if (0 == fbInfo.status) {
					content="        {1}<font color='#ff0000'><u><a href='event:other_ycp--{2}'>"+PropUtils.getStringById(1572)+"</a></u></font>";
					content=PropUtils.getStringById(2454);
				}

//				content=StringUtil.substitute(content, monsterInfo.name, bossRender.bossId);
				var arr:Array=[PropUtils.getStringById(2423),"<a href='event:other_ycp--"+monsterInfo.name+"'>" + PropUtils.getStringById(2439) + "</a>", content, "", Cmd_YBS.callBack, "", onBtnClick];
				UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_fieldbossCopyLine, arr);
			} else {
				reBossItem=null;
				data.setRemind(0);
				UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_fieldbossCopyLine);
			}
		}

		private function onBtnClick(type:String):void {
			var bossId:int=DataManager.getInstance().fieldBossData.getRemindId();
			var bossInfo:TFieldBossInfo=TableManager.getInstance().getFieldBossInfo(bossId);
			var pt:TPointInfo=TableManager.getInstance().getPointInfo(bossInfo.pointId);
			Cmd_Go.cmGoPoint(int(bossInfo.sceneId), pt.tx, pt.ty);
		}

		public function updateView():void {
			var data:FieldBossData=DataManager.getInstance().fieldBossData;
			for each (var item:FieldBossRender in items) {
				if (null != item) {
					var itemInfo:FieldBossInfo=data.getBossInfo(item.bossId);
					item.updateInfo(itemInfo);
				}
			}
		}
	}
}
