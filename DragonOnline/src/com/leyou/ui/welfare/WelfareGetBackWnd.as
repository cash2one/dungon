package com.leyou.ui.welfare
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFindBackInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Welfare;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	
	public class WelfareGetBackWnd extends AutoWindow
	{
		private var title1Lbl:Label;
		
		private var desLbl:Label;
		
		private var rewardLbl:Label;
		
		private var confirmBtn:NormalButton;
		
		private var cancelBtn:NormalButton;
		
		private var _fid:int;
		private var _unum:int;
		private var _st:int;
		private var _exp:int;
		private var _count:int;
		private var _money:int;
		private var _energy:int;
		private var _currencyType:int;
		
		private var _findType:int; // 0 - 普通找回 1 - 一键找回 2 - 至尊找回
		private var _obj:Object;
		
		public function WelfareGetBackWnd(){
			super(LibManager.getInstance().getXML("config/ui/welfare/welMessage1.xml"));
			init();
		}
		
		private function init():void{
			title1Lbl = getUIbyID("titleLbl") as Label;
			desLbl = getUIbyID("desLbl") as Label;
			rewardLbl = getUIbyID("rewardLbl") as Label;
			confirmBtn = getUIbyID("confirmBtn") as NormalButton;
			cancelBtn = getUIbyID("cancelBtn") as NormalButton;
			confirmBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			cancelBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function pushData(obj:Object):void{
			_obj = obj;
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			hide();
			switch(event.target.name){
				case "confirmBtn":
					if(0 == _findType){
						Cmd_Welfare.cm_FBK_F(_fid,_currencyType);
					}else if(1 == _findType){
						Cmd_Welfare.cm_FBK_A(1);
					}else if(2 == _findType){
						Cmd_Welfare.cm_FBK_A(2);
					}
					break;
//				case "cancelBtn":
//					hide();
//					break;
			}
		}
		
		public function updateInfoOneKey(findType:int):void{
			var desId:int;
			var titleId:int;
			_findType = findType;
			var rate:Number;
			if(1 == _findType){
				desId = 10129;
				titleId = 2317;
				rate = ConfigEnum.GiftLot9/100;
			}else if(2 == findType){
				desId = 10130;
				titleId = 2318;
				rate = 1;
			}
			rewardLbl.text = "";
			title1Lbl.text = PropUtils.getStringById(titleId);
			_exp = 0;
			_money = 0;
			_energy = 0;
			var totalYB:int = 0;
			var totalMoney:int = 0;
			var flist:Array = _obj.flist;
			var l:int = flist.length;
			for(var n:int = 0; n < l; n++){
				var arr:Array = flist[n];
				var info:TFindBackInfo = TableManager.getInstance().getFinkBackInfo(arr[0]);
				if(0 != int(arr[2])){
					continue;
				}
				var num:int = arr[1];
				if(1 == info.type){
					var rt:String;
					switch(int(arr[0])){
						case 1:
							rt = PropUtils.getStringById(2319);
							break;
						case 2:
							rt = PropUtils.getStringById(2321);
							break;
						case 3:
							rt = PropUtils.getStringById(2320);
							break;
					}
					rewardLbl.appendText(StringUtil.substitute(rt, arr[1])+"\n");
					totalMoney += info.money*num;
				}else if(2 == info.type){
					var obj:Object = arr[3];
					_exp += int(obj["exp"]);
					_money += int(obj["money"]);
					_energy += int(obj["energy"]);
					if(2 != findType){
						totalMoney += info.money*num;
					}
				}
				totalYB += info.ib*num;
			}
			
			if(_exp > 0){
				rewardLbl.appendText(StringUtil.substitute(PropUtils.getStringById(2322), _exp*rate)+"\n");
			}
			if(_money > 0){
				rewardLbl.appendText(StringUtil.substitute(PropUtils.getStringById(2323), _money*rate)+"\n");
			}
			if(_energy > 0){
				rewardLbl.appendText(StringUtil.substitute(PropUtils.getStringById(2324), _energy*rate)+"\n");
			}
			
			desLbl.htmlText = StringUtil.substitute(TableManager.getInstance().getSystemNotice(desId).content, totalMoney, totalYB);
		}
		
		public function updateInfo(arr:Array, currencyType:int):void{
			_findType = 0;
			_currencyType = currencyType;
			_fid = arr[0];
			_unum = arr[1];
			_st = arr[2];
			var obj:Object = arr[3];
			_count = obj["count"];
			_exp = obj["exp"];
			_money = obj["money"];
			_energy = obj["energy"];
			
			
			var info:TFindBackInfo = TableManager.getInstance().getFinkBackInfo(_fid);
			if(1 == info.type){
				title1Lbl.text = PropUtils.getStringById(2313);
				desLbl.htmlText = StringUtil.substitute(TableManager.getInstance().getSystemNotice(10126).content, info.money*_unum);
				var rt:String;
				switch(_fid){
					case 1:
						rt = PropUtils.getStringById(2319);
						break;
					case 2:
						rt = PropUtils.getStringById(2321);
						break;
					case 3:
						rt = PropUtils.getStringById(2320);
						break;
				}
				rewardLbl.text = StringUtil.substitute(rt, _unum);
			}else if(2 == info.type){
				var desId:int;
				var value:int;
				var titleId:int;
				if(1 == currencyType){
					desId = 10127;
					titleId = 2315;
					value = info.money*_unum;
					var rate:Number = ConfigEnum.GiftLot9/100;
					_exp *= rate;
					_money *= rate;
					_energy *= rate;
				}else if(2 == currencyType){
					desId = 10128;
					titleId = 2316;
					value = info.ib*_unum;
				}
				title1Lbl.text = PropUtils.getStringById(titleId);
				desLbl.htmlText = StringUtil.substitute(TableManager.getInstance().getSystemNotice(desId).content, value);
				rewardLbl.text = "";
				if(_exp > 0){
					rewardLbl.appendText(StringUtil.substitute(PropUtils.getStringById(2322), _exp)+"\n");
				}
				if(_money > 0){
					rewardLbl.appendText(StringUtil.substitute(PropUtils.getStringById(2323), _money)+"\n");
				}
				if(_energy > 0){
					rewardLbl.appendText(StringUtil.substitute(PropUtils.getStringById(2324), _energy)+"\n");
				}
			}
		}
	}
}