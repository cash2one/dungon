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
	
	import flash.events.MouseEvent;
	
	public class WelfareGetBackTimesRender extends AutoSprite
	{
		private var titleImg:Image;
		
		private var iconImg:Image;
		
		private var findBtn:NormalButton;
		
		private var completeLbl:Label;
		
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
		
		public function WelfareGetBackTimesRender(){
			super(LibManager.getInstance().getXML("config/ui/welfare/welfareBackRender1.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			titleImg = getUIbyID("titleImg") as Image;
			iconImg = getUIbyID("iconImg") as Image;
			findBtn = getUIbyID("findBtn") as NormalButton;
			completeLbl = getUIbyID("completeLbl") as Label;
			uncompleteLbl = getUIbyID("uncompleteLbl") as Label;
			findOutImg = getUIbyID("findOutImg") as Image;
			unopenImg = getUIbyID("unopenImg") as Image;
			findBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			switch(event.target.name){
				case "findBtn":
					UIManager.getInstance().showWindow(WindowEnum.WELFARE_FINDBACK);
					UIManager.getInstance().welfareGetBack.updateInfo(_arr, 1);
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
			completeLbl.text = _count+"";
			unopenImg.visible = (-1 == _st);
			findOutImg.visible = (1 == _st);
			findBtn.setActive((0 == _st) && (0 != _unum), 1, true);
		}
	}
}