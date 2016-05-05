package com.leyou.ui.arena.childs {


	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.net.cmd.Cmd_Arena;
	import com.leyou.ui.ttt.MessageCnSeWnd;
	import com.leyou.utils.ArenaUtil;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ArenaChallange extends AutoSprite {

		private var rewardBtn:ImgButton;
		private var topBtn:ImgButton;
		private var addPkCountBtn:ImgButton;
		private var logBtn:ImgButton;
		private var leftBtn:ImgButton;

		private var ruleLbl:Label;
		private var proLbl:Label;
		private var integralLbl:Label;
		private var topLbl:Label;
		private var lastPkCountLbl:Label;
		private var logTxt:TextArea;

		private var msgBox:MessageCnSeWnd;

		private var avatarArr:Array=[];
		private var avatarSprArr:Array=[];

		public function ArenaChallange() {
			super(LibManager.getInstance().getXML("config/ui/arena/arenaChallange.xml"));
			this.init();
			this.mouseEnabled=this.mouseChildren=true;
		}

		private function init():void {

			this.rewardBtn=this.getUIbyID("rewardBtn") as ImgButton;
			this.topBtn=this.getUIbyID("topBtn") as ImgButton;
			this.addPkCountBtn=this.getUIbyID("addPkCountBtn") as ImgButton;
			this.logBtn=this.getUIbyID("logBtn") as ImgButton;
			this.leftBtn=this.getUIbyID("leftBtn") as ImgButton;

			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;
			this.proLbl=this.getUIbyID("proLbl") as Label;
			this.integralLbl=this.getUIbyID("integralLbl") as Label;
			this.topLbl=this.getUIbyID("topLbl") as Label;
			this.lastPkCountLbl=this.getUIbyID("lastPkCountLbl") as Label;
			this.logTxt=this.getUIbyID("logTxt") as TextArea;

			this.rewardBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.topBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.addPkCountBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.logBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.leftBtn.addEventListener(MouseEvent.CLICK, onLeftClick);

			this.ruleLbl.mouseEnabled=true;
			this.ruleLbl.setToolTip(TableManager.getInstance().getSystemNotice(10169).content);

			this.msgBox=new MessageCnSeWnd();
			LayerManager.getInstance().windowLayer.addChild(this.msgBox);

			this.msgBox.x=(UIEnum.WIDTH - this.msgBox.width) >> 1;
			this.msgBox.y=(UIEnum.HEIGHT - this.msgBox.height) >> 1;


			var render:ArenaRender=new ArenaRender();
			this.avatarArr.push(render);
			render.isTop3=true;
			this.addChild(render);

			render.x=100;
			render.y=420;

			render=new ArenaRender();
			render.isTop3=true;
			this.avatarArr.push(render);
			this.addChild(render);

			render.x=347;
			render.y=373;

			render=new ArenaRender();
			render.isTop3=true;
			this.avatarArr.push(render);
			this.addChild(render);

			render.x=577;
			render.y=420;

			for (var i:int=0; i < this.avatarArr.length; i++) {
//				this.playVec[i].addEventListener(MouseEvent.CLICK, onPlayClick);
				this.avatarArr[i].addEventListener(MouseEvent.MOUSE_OVER, onPlayOver);
				this.avatarArr[i].addEventListener(MouseEvent.MOUSE_OUT, onPlayOut);
			}

//			var spr:Sprite=new Sprite();
//			spr.graphics.beginFill(0x000000);
//			spr.graphics.drawRect(0, 0, 50, 30);
//			spr.graphics.endFill();
//
//			this.addChild(spr);
//
//			spr.alpha=0;
//			spr.name="s_1";
//			spr.x=0;
////			spr.y=-420;
//			spr.y=193;
//
//			spr.addEventListener(MouseEvent.CLICK, onSprClick);
//
//			spr=new Sprite();
//			spr.graphics.beginFill(0x000000);
//			spr.graphics.drawRect(0, 0, 100, 200);
//			spr.graphics.endFill();
//
//			this.addChild(spr);
//
//			spr.alpha=0;
//			spr.name="s_2";
//
//			spr.x=347;
////			spr.y=-373;
//			spr.y=173;
//
//			spr.addEventListener(MouseEvent.CLICK, onSprClick);
//
//			spr=new Sprite();
//			spr.graphics.beginFill(0x000000);
//			spr.graphics.drawRect(0, 0, 100, 200);
//			spr.graphics.endFill();
//
//			this.addChild(spr);
//
//			spr.alpha=0;
//			spr.name="s_3"
//			spr.x=607;
////			spr.y=-420;
//			spr.y=220;
//
//			spr.addEventListener(MouseEvent.CLICK, onSprClick);

		}

		private function onPlayOver(e:MouseEvent):void {
			if (e.target is ArenaRender)
				ArenaRender(e.target).PkBtn=true;
			else if (e.target.parent is ArenaRender)
				ArenaRender(e.target.parent).PkBtn=true;
		}

		private function onPlayOut(e:MouseEvent):void {
			if (e.target is ArenaRender)
				ArenaRender(e.target).PkBtn=false;
			else if (e.target.parent is ArenaRender)
				ArenaRender(e.target.parent).PkBtn=false;
		}

		private function onSprClick(e:MouseEvent):void {

			var str:String=e.target.name;
			Cmd_Arena.cm_ArenaPkTop3(int(str.split("_")[1]));
		}

		private function onLeftClick(e:MouseEvent):void {
//			TweenLite.to(this, 1, {x: 840, y: 59});
			this.visible=false;
		}

		private function onClick(e:MouseEvent):void {
			var ctx:String;

			switch (e.target.name) {
				case "rewardBtn":
					UIManager.getInstance().openWindow(WindowEnum.ARENAAWARD);
					break;
				case "logBtn":
					UIManager.getInstance().openWindow(WindowEnum.ARENALIST);
					break;
				case "topBtn":
					UIManager.getInstance().openWindow(WindowEnum.RANK);
					UIManager.getInstance().rankWnd.selectPageByType(5);
					break;
				case "addPkCountBtn":

//					ctx=StringUtil.substitute(TableManager.getInstance().getSystemNotice(4711).content, [this.addPKCountCost, 1]);
					//					wnd=PopupManager.showConfirm(ctx, function():void {
					//						Cmd_Arena.cm_ArenaBuyPkCount()
					//					}, null, false, "arenaPkCount");

					//					wnd=PopupManager.showRadioConfirm(ctx, this.addPKCountCost + "", this.addPKCountCost1 + "", function(i:int):void {
					//						Cmd_Arena.cm_ArenaBuyPkCount((i == 0 ? 1 : 0))
					//					}, null, false, "arenaPkCount");

					this.msgBox.showPanel(3, 2);

					break;
			}

		}

		public function updateInfo(o:Object):void {

//			this.proLbl.text="" + ArenaUtil.ArenaPro[3 - 1];
			this.proLbl.text="" + ArenaUtil.ArenaPro[int(o.jxlevel) - 1];
			this.integralLbl.text="" + o.score;
			this.topLbl.text="" + o.jrank;
			this.lastPkCountLbl.text="" + o.sfight;

		}

		public function updateLog(str:String):void {
			this.logTxt.setHtmlText("");
			this.logTxt.setHtmlText(str);
		}

		/**
		 *--------------------------------------------------------------------------------
-- 前3列表
上行:jjc|A
下行:jjc|{"mk":"A", "tzlist13":[ [name,level,school,gender,zdl,jxlevel,gscore,jstate,avt]...]}
* @param o
*
*/
		public function updateAvatarUl(o:Object):void {

			var alist:Array=o.tzlist13;
			var tmp1:Array=alist[0];
			var tmp2:Array=alist[1];

			alist[0]=tmp2;
			alist[1]=tmp1;

			var arr:Array=[];
			for (var i:int=0; i < alist.length; i++) {
				this.avatarArr[i].setChalPos(i);
				this.avatarArr[i].updateInfo(alist[i]);
				this.avatarArr[i].reAddchild();
				
				if (i == 0)
					this.avatarArr[i].index=1;
				else if (i == 1)
					this.avatarArr[i].index=0;
				else
					this.avatarArr[i].index=2;
//				this.avatarArr[i].setPkState(true);
			}

//			this.addChild(this.getChildByName("s_1"));
//			this.addChild(this.getChildByName("s_2"));
//			this.addChild(this.getChildByName("s_3"));

			this.addChild(this.leftBtn);
		}


	}
}
