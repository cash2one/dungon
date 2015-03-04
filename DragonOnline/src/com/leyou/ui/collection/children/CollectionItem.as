package com.leyou.ui.collection.children
{
	import com.ace.config.Core;
	import com.ace.enum.GameFileEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCollectionPreciousInfo;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenMax;
	import com.leyou.data.collectioin.CollectionGroupTaskData;
	import com.leyou.data.collectioin.CollectionTaskData;
	import com.leyou.net.cmd.Cmd_Collection;
	import com.leyou.net.cmd.Cmd_Go;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class CollectionItem extends AutoSprite
	{
		private var _id:int;
		
		private var _groupId:int;
		
		private var flagImg:Image;
		
		private var nameLbl:Label;
		
		private var completionImg:Image;
		
		private var getBtn:NormalButton;
		
		private var icon:Image;
		
		private var flyBtn:ImgButton;
		
		private var flyImg:Image;
		
		// 0.未完成 1.已完成 2.已兑换
		private var _status:int;
		
		private var effectSwf:SwfLoader;
		
		public function CollectionItem(){
			super(LibManager.getInstance().getXML("config/ui/collection/mine2Btn.xml"));
			init();
		}
		
		public function get status():int{
			return _status;
		}

		public function get groupId():int{
			return _groupId;
		}

		public function get id():int{
			return _id;
		}

		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			flagImg = getUIbyID("flagImg") as Image;
			nameLbl = getUIbyID("nameLbl") as Label;
			completionImg = getUIbyID("completionImg") as Image;
			getBtn = getUIbyID("getBtn") as NormalButton;
			flyBtn = getUIbyID("flyBtn") as ImgButton;
			flyImg = getUIbyID("flyImg") as Image;
			icon = new Image();
			icon.x = 51;
			icon.y = 42;
			addChild(icon);
			swapChildren(completionImg, icon);
			completionImg.visible = false;
			flyBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			getBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
			effectSwf = new SwfLoader();
			addChild(effectSwf);
			effectSwf.update(99962);
			effectSwf.x -= 10;
			effectSwf.y -= 30;
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			ToolTipManager.getInstance().show(TipEnum.TYPE_COLLECTION, _id, new Point(stage.mouseX, stage.mouseY));
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			var itemInfo:TCollectionPreciousInfo = TableManager.getInstance().getPreciousById(_id);
			var point:TPointInfo = TableManager.getInstance().getPointInfo(itemInfo.targetPoint);
			switch(event.target.name){
				case "getBtn":
					if(0 == status){
						Core.me.gotoMap(new Point(point.tx, point.ty), point.sceneId, true);
						Core.me.pInfo.currentTaskType=PlayerEnum.TASK_MONSTER;
					}else if(1 == status){
						Cmd_Collection.cm_COL_T(_id);
					}
					break;
				case "flyBtn":
					Core.me.pInfo.currentTaskType=PlayerEnum.TASK_MONSTER;
					Cmd_Go.cmGoPoint(int(point.sceneId), point.tx, point.ty);
					break;
			}
		}
		
		public function updateTable(itemInfo:TCollectionPreciousInfo):void{
			_id = itemInfo.id;
			_groupId = itemInfo.groupId;
			var url:String = GameFileEnum.URL_ITEM_ICO+itemInfo.toProIcon;
			icon.updateBmp(url, null, false, 40, 40);
		}
		
		public function updateInfo(data:CollectionGroupTaskData):void{
			var itemInfo:TCollectionPreciousInfo = TableManager.getInstance().getPreciousById(_id);
			var taskData:CollectionTaskData = data.getTask(_id);
			nameLbl.text = StringUtil.substitute("{1}({2}/{3})", itemInfo.proName, taskData.cNum, itemInfo.proMax);
			completionImg.visible = (1 == taskData.status);
			var url:String = (1 == taskData.status) ? "ui/mine/yhde.png" : "ui/mine/whde.png";
			flagImg.updateBmp(url);
			_status = 0;
			if(taskData.cNum >= itemInfo.proMax){
				_status = 1;
			}
			if(1 == taskData.status){
				_status = 2;
			}
			getBtn.text = (0 == status) ? "前往获得": "兑换";
			getBtn.visible = (2 != status);
			flyImg.visible = (2 != status);
			flyBtn.visible = (2 != status);
			if(1 == _status){
				if(!TweenMax.isTweening(getBtn)){
					TweenMax.to(getBtn, 2, {glowFilter: {color: 0xFFD700, alpha: 1, blurX: 10, blurY: 10, strength: 2}, yoyo: true, repeat: -1});
				}
			}else{
				if(TweenMax.isTweening(getBtn)){
					TweenMax.killTweensOf(getBtn);
					getBtn.filters = [];
				}
			}
		}
		
		public override function die():void{
			flagImg = null;
			nameLbl = null;
			completionImg = null;
			getBtn = null;
			icon = null;
			flyBtn = null;
			flyImg = null;
		}
	}
}