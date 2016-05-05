package com.leyou.ui.welfare.child.component
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFindBackInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	
	public class WelfareGetBackSourcesRender extends AutoSprite
	{
		private var titleImg:Image;
		
		private var iconImg:Image;
		
		private var jbBtn:NormalButton;
		
		private var zsBtn:NormalButton;
		
		private var title1Lbl:Label;
		
		private var title2Lbl:Label;
		
		private var title1ELbl:Label;
		
		private var title2ELbl:Label;
		
		private var uncompleteLbl:Label;
		
		private var findOutImg:Image;
		
		private var unopenImg:Image;
		
		private var _fid:int;
		private var _unum:int;
		private var _st:int;
		private var _count:int;
		private var _exp:int;
		private var _money:int;
		private var _energy:int;
		
		private var _arr:Array;
		
		public function WelfareGetBackSourcesRender(){
			super(LibManager.getInstance().getXML("config/ui/welfare/welfareBackRender2.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			titleImg = getUIbyID("titleImg") as Image;
			iconImg = getUIbyID("iconImg") as Image;
			jbBtn = getUIbyID("jbBtn") as NormalButton;
			zsBtn = getUIbyID("zsBtn") as NormalButton;
			title1Lbl = getUIbyID("title1Lbl") as Label;
			title2Lbl = getUIbyID("title2Lbl") as Label;
			title1ELbl = getUIbyID("title1ELbl") as Label;
			title2ELbl = getUIbyID("title2ELbl") as Label;
			uncompleteLbl = getUIbyID("uncompleteLbl") as Label;
			findOutImg = getUIbyID("findOutImg") as Image;
			unopenImg = getUIbyID("unopenImg") as Image;
			
			jbBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			zsBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			switch(event.target.name){
				case "jbBtn":
					UIManager.getInstance().showWindow(WindowEnum.WELFARE_FINDBACK);
					UIManager.getInstance().welfareGetBack.updateInfo(_arr, 1);
					break;
				case "zsBtn":
					UIManager.getInstance().showWindow(WindowEnum.WELFARE_FINDBACK);
					UIManager.getInstance().welfareGetBack.updateInfo(_arr, 2);
					break;
			}
			
		}
		
		public function updateInfo(arr:Array):void{
			_arr = arr;
			_fid = arr[0];
			_unum = arr[1];
			_st = arr[2];
			var obj:Object = arr[3];
			_count = obj["count"];
			_exp = obj["exp"];
			_money = obj["money"];
			_energy = obj["energy"];
			
			var info:TFindBackInfo = TableManager.getInstance().getFinkBackInfo(_fid);
			titleImg.updateBmp("ui/welfare/"+info.img_01);
			iconImg.updateBmp("ui/welfare/"+info.img_02);
			uncompleteLbl.text = _unum+"";
			unopenImg.visible = (-1 == _st);
			findOutImg.visible = (1 == _st);
			
			var currentLbl:Label = title1ELbl;
			var currentVLbl:Label = title1Lbl;
			title2ELbl.visible = false;
			title2Lbl.visible = false;
			if(_exp > 0){
				currentLbl.text = PropUtils.getStringEasyById(2322);
				currentVLbl.text = _exp+"";
				currentLbl = title2ELbl;
				currentVLbl = title2Lbl;
				title2ELbl.visible = true;
				title2Lbl.visible = true;
			}
			if(_money > 0){
				currentLbl.text = PropUtils.getStringEasyById(2323);
				currentVLbl.text = _money+"";
				currentLbl = title2ELbl;
				currentVLbl = title2Lbl;
				title2ELbl.visible = true;
				title2Lbl.visible = true;
			}
			if(_energy > 0){
				currentLbl.text = PropUtils.getStringEasyById(2324);
				currentVLbl.text = _energy+"";
			}
			jbBtn.setActive((0 == _st)&& (0 != _unum), 1, true);
			zsBtn.setActive((0 == _st)&& (0 != _unum), 1, true);
		}
	}
}