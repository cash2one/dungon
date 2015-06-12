package com.leyou.ui.abidePay
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TAbidePayInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.abidePay.AbidePayData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_CCZ;
	import com.leyou.ui.abidePay.children.AbidePayRewardBox;
	import com.leyou.ui.mail.child.MaillGrid;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class AbidePayBoxWnd extends AutoWindow
	{
		private var tLbl:Label;
		
		private var contentLbl:Label;
		
		private var introLbl:Label;
		
		private var dayLbl:Label;
		
		private var receiveBtn:NormalButton;
		
		private var _day:int;
		
		private var _type:int;
		
//		private var iconImg:Image;
		
//		private var grid:MarketGrid;
		
		private var grids:Vector.<MaillGrid>;
		
		public function AbidePayBoxWnd(){
			super(LibManager.getInstance().getXML("config/ui/abidePay/lxczMegWnd.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			tLbl = getUIbyID("titleLbl") as Label;
			contentLbl = getUIbyID("contentLbl") as Label;
			introLbl = getUIbyID("introLbl") as Label;
			dayLbl = getUIbyID("dayLbl") as Label;
			receiveBtn = getUIbyID("receiveBtn") as NormalButton;
			receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
//			iconImg = new Image();
//			addChild(iconImg);
//			iconImg.x = 112;
//			iconImg.y = 93;
			grids = new Vector.<MaillGrid>();
			for(var n:int = 0; n < 4; n++){
				var grid:MaillGrid = new MaillGrid();
				addChild(grid);
				grid.x = 42 + n*62;
				grid.y = 107;
				grids.push(grid);
			}
//			grid = new MarketGrid();
//			addChild(grid);
//			grid.x = 120;
//			grid.y = 100;
			clsBtn.x -= 6;
			clsBtn.y -= 14;
		}
		
		public function updateInfo(box:AbidePayRewardBox):void{
			var data:AbidePayData = DataManager.getInstance().abidePayData;
			_day = box.day;
			_type = box.type;
			tLbl.text = StringUtil.substitute(PropUtils.getStringById(1573), _day);
			var content:String = TableManager.getInstance().getSystemNotice(10010).content;
			contentLbl.text = StringUtil.substitute(content, _day, _type);
			content = TableManager.getInstance().getSystemNotice(10011).content;
			introLbl.text = content;
			dayLbl.text = data.getAbideDay(_type)+"/"+_day;
			
			var rewardArr:Array = getRewardArr(_type, _day);
			var l:int = rewardArr.length;
			for(var n:int = 0; n < 4; n++){
				if(n < l){
					var d:Array = rewardArr[n].split(",");
					grids[n].updateInfo(d[0], d[1]);
				}else{
					grids[n].clear();
				}
			}
			
//			var tdata:TAbidePayInfo = TableManager.getInstance().getAbidePayInfo(box.id);
//			grid.updataById(tdata.getRewardByDay(_day));
			
			if(data.isReceive(_day, _type)){
				receiveBtn.text = PropUtils.getStringById(1574);
				receiveBtn.setActive(false, 1, true);
				return;
			}
			var rd:int = data.getAbideDay(_type);
			if(rd >= _day){
				receiveBtn.text = PropUtils.getStringById(1575);
				receiveBtn.setActive(true, 1, true);
			}else{
				receiveBtn.text = PropUtils.getStringById(1576);
				receiveBtn.setActive(false, 1, true);
			}
		}
		
		public function flyItem():void{
			if(!visible){
				return;
			}
			var flyIds:Array=[];
			var starts:Array=[];
			for each(var grid:MaillGrid in grids){
				if(0 != grid.dataId){
					flyIds.push(grid.dataId);
					starts.push(grid.localToGlobal(new Point(0, 0)));
				}
			}
			if((null != flyIds) && (flyIds.length > 0)){
				FlyManager.getInstance().flyBags(flyIds, starts);
				flyIds.length = 0;
				starts.length = 0;
			}
			hide();
		}
		
		private function getRewardArr(_type:int, _day:int):Array{
			var tdata1:TAbidePayInfo = TableManager.getInstance().getAbidePayInfo(1);
			var tdata2:TAbidePayInfo = TableManager.getInstance().getAbidePayInfo(2);
			var tdata3:TAbidePayInfo = TableManager.getInstance().getAbidePayInfo(3);
			var dayArr:Array = ConfigEnum.lxcz2.split(",");
			var index:int = dayArr.indexOf(_day+"")*3;
			if(tdata1.ib == _type){
				index += 0;
			}else if(tdata2.ib == _type){
				index += 1;
			}else if(tdata3.ib == _type){
				index += 2;
			}
			index += 3;
			return ConfigEnum["lxcz"+index].split("|");
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			Cmd_CCZ.cm_CCZ_C(_type, _day);
		}
	}
}