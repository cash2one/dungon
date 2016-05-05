package com.leyou.ui.ttsc {


	import com.ace.enum.FontEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPayPromotion;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Rnkj;
	import com.leyou.ui.ttsc.childs.KfcbRender;
	import com.leyou.ui.ttsc.childs.KfcbRender2;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.TimeUtil;
	
	import flash.events.MouseEvent;

	public class KfcbWnd extends AutoWindow {

		private var payBtn:ImgButton;
		private var listBtnArr:Array=[];

		private var titleIcon:Image;
		private var timeLbl:Label;
		private var ruleLbl:Label;

		private var dayLbl:Label;
		private var hourLbl:Label;
		private var monLbl:Label;
		private var secLbl:Label;

		private var kfcbrender:KfcbRender;

		private var minfo:Object;

		public function KfcbWnd() {
			super(LibManager.getInstance().getXML("config/ui/ttsc/kfcbWnd.xml"));
			this.init();
			this.hideBg();
			this.mouseChildren=true;
//			this.mouseEnabled=true;
			this.clsBtn.y=30;
		}

		private function init():void {

			this.payBtn=this.getUIbyID("payBtn") as ImgButton;

			this.titleIcon=this.getUIbyID("titleIcon") as Image;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;

			this.dayLbl=this.getUIbyID("dayLbl") as Label;
			this.hourLbl=this.getUIbyID("hourLbl") as Label;
			this.monLbl=this.getUIbyID("monLbl") as Label;
			this.secLbl=this.getUIbyID("secLbl") as Label;

			this.payBtn.addEventListener(MouseEvent.CLICK, onPay);

			this.updateInit();

			this.kfcbrender=new KfcbRender();
			this.addChild(this.kfcbrender);
			this.kfcbrender.x=173;
			this.kfcbrender.y=221;


		}

		private function updateInit():void {

			var arr:Array=TableManager.getInstance().getPayPromotionByType2(4);
			var listBtn:ImgLabelButton;
			var pay:TPayPromotion;
			var i:int=0;
			for each (pay in arr) {

				if (this.getChildByName("s_" + pay.type) != null)
					continue;

				listBtn=new ImgLabelButton("ui/common/" + pay.btnUrl, pay.btn_des,0,0,FontEnum.getTextFormat("message2"));
				this.addChild(listBtn);

				listBtn.visible=false;
				listBtn.name="s_" + pay.type;

				this.listBtnArr.push(listBtn);
				listBtn.addEventListener(MouseEvent.CLICK, onClick);

			}

		}

		private function onPay(e:MouseEvent):void {
			PayUtil.openPayUrl();
		}

		private function onClick(e:MouseEvent):void {

			this.setState(false);
			e.target.turnOn();

			var str:String=e.target.name;
			var type:int=int(str.split("_")[1]);

			this.kfcbrender.updateInfo(this.getCurrentArr(this.minfo.raklist, type));

			var payarr:Array=TableManager.getInstance().getPayPromotionByType(type);
			payarr.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

			var pay:TPayPromotion=payarr[0];

			this.ruleLbl.htmlText="" + pay.des3;

			var d:Date=new Date();
			d.time=this.minfo.opentime * 1000;

			var startime:String=TimeUtil.getDateToString2(d);

			d.date+=pay.day_end;
			var endtime:String=TimeUtil.getDateToString2(d);

			this.timeLbl.htmlText="" + StringUtil.substitute(pay.des2, [startime, endtime]);

			var stime:int=this.minfo.stime;
//			var time:int=(TimerManager.CurrentServerTime + TimerManager.currentTime) * 1000;
//			var dtime:int=time - stime;

			d.time=d.time - this.minfo.stime * 1000;

			if (d.time > 0) {
				this.dayLbl.text="" + int(d.time / 1000 / 60 / 60 / 24);
				this.hourLbl.text="" + int(d.time / 1000 / 60 / 60 % 24);
				this.monLbl.text="" + int(d.time / 1000 / 60 % 60);
				this.secLbl.text="" + int(d.time / 1000 % 60);
			} else {
				this.dayLbl.text="0";
				this.hourLbl.text="0";
				this.monLbl.text="0";
				this.secLbl.text="0";
			}

		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			Cmd_Rnkj.cmRnkjInit();
		}

		private function setState(v:Boolean):void {

			for (var i:int=0; i < this.listBtnArr.length; i++) {
				if (v)
					this.listBtnArr[i].turnOn();
				else
					this.listBtnArr[i].turnOff();
			}

		}
		
		public function updateKFhdInfo(o:Object):void{
			
			
			
		}

		public function updateInfo(o:Object):void {

			this.minfo=o;

			var list:Array=o.raklist;

			var payarr:Array
			var listBtn:ImgLabelButton;
			var pay:TPayPromotion;
			var str:String;
			var pid:int;
			var i:int=0;
			var d:Date=new Date();
			var vi1:Boolean=false;

			var isExitsBtn:Boolean=false;

			for each (listBtn in listBtnArr) {

				str=listBtn.name;
				pid=int(str.split("_")[1]);

				if (!this.getActiveData(list, pid)) {
					listBtn.visible=false;
					continue;
				}

				payarr=TableManager.getInstance().getPayPromotionByType(pid);
				pay=payarr[0];

				d.time=this.minfo.opentime * 1000;
				d.date+=pay.day_view;
				d.time=d.time - this.minfo.stime * 1000;

				if (d.time <= 0) {
					listBtn.visible=false;
					continue;
				}

				if (!vi1) {
					listBtn.turnOn();
					listBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					vi1=true;
				}

				isExitsBtn=true;

				listBtn.visible=true;
				listBtn.x=32;
				listBtn.y=72 + i * 50;

				i++;
			}


			if (this.minfo.st == 1) {
				this.titleIcon.updateBmp("ui/wybq/font_kfjj.png");
			} else if (this.minfo.st == 2) {
				this.titleIcon.updateBmp("ui/wybq/font_hfjj.png");
			}

			if (isExitsBtn) {
				UIManager.getInstance().rightTopWnd.active("kfjjBtn");
			} else {
				UIManager.getInstance().rightTopWnd.deactive("kfjjBtn");
			}

		}

		private function getActiveData(arr:Array, id:int):Boolean {

			var tmp1:Array=[];
			for each (tmp1 in arr) {
				if (tmp1[0] == id)
					return true;
			}

			return false;
		}

		private function getCurrentArr(arr:Array, id:int):Array {

			var tmp1:Array=[];
			for each (tmp1 in arr) {
				if (tmp1[0] == id)
					return tmp1;
			}

			return null;
		}
 

	}
}
