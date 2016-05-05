package com.leyou.ui.monsterInvade {

	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenLite;
	import com.leyou.manager.TimerManager;
	import com.leyou.ui.monsterInvade.child.MonsterInvadeRender1;
	import com.leyou.ui.monsterInvade.child.MonsterInvadeRender2;
	import com.leyou.ui.monsterInvade.child.MonsterInvadeRender3;
	import com.leyou.util.DateUtil;
	
	import flash.events.MouseEvent;

	public class MonsterInvadeWnd extends AutoSprite {

		private var timeLbl:Label;
		private var DownOrUpBtn:ImgButton;

		private var render1:MonsterInvadeRender1;
		private var render2:MonsterInvadeRender2;
		private var render3:MonsterInvadeRender3;

		private var isDown:Boolean=false;

		private var time:int=0;

		public function MonsterInvadeWnd() {
			super(LibManager.getInstance().getXML("config/ui/monsterInvade/monsterInvadeWnd.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {

			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.DownOrUpBtn=this.getUIbyID("DownOrUpBtn") as ImgButton;

			this.DownOrUpBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.render1=new MonsterInvadeRender1();
			this.addChild(this.render1);
			this.render1.y=45;

			this.render2=new MonsterInvadeRender2();
			this.addChild(this.render2);
			this.render2.y=this.render1.y + this.render1.height;

			this.render3=new MonsterInvadeRender3();
			LayerManager.getInstance().windowLayer.addChild(this.render3);
		}

		private function onClick(e:MouseEvent):void {

			this.isDown=!this.isDown;

			if (this.isDown) {

				this.DownOrUpBtn.updataBmd("ui/monsterInvade/btn_down.png");
				TweenLite.to(this.render2, 2, {y: this.render1.y});
				TweenLite.to(this.render1, 2, {alpha: 0});

			} else {

				this.DownOrUpBtn.updataBmd("ui/monsterInvade/btn_forward.png");
				TweenLite.to(this.render2, 2, {y: this.render1.y + this.render1.height});
				TweenLite.to(this.render1, 2, {alpha: 1});

			}

		}

		public function showPanel(o:Object):void {
			if (!this.visible)
				this.show();

			this.updateInfo(o);
			this.resize();

			UIManager.getInstance().taskTrack.hide();
			UIManager.getInstance().hideWindow(WindowEnum.PKCOPY);
			UIManager.getInstance().hideWindow(WindowEnum.PKCOPYPANEL);
		}

		/**
		 *下行:wbs|{"mk":I,"stime":num, "rankl":[[name,damage],...]], "myrank":num, "mydamage":num, "myexp":num, "aprop":num}
	  stime  -- 剩余时间
								rankl  -- 排行榜
				 name  -- 名字
				 damage -- 伤害
			  myrank     -- 我的排行
			  mydamage   -- 我的伤害
			  myexp      -- 我的经验
			  aprop      -- 增加的属性比
		 * @param o
		 *
		 */
		public function updateInfo(o:Object):void {
	
			if (this.time == 0)
				this.time=o.stime;
//			this.timeLbl.text="" + TimeUtil.getIntToTime(o.stime);
			this.timeLbl.text="" + DateUtil.formatTime(o.stime * 1000, 1);
			TimerManager.getInstance().add(exeTime);

			
			this.render1.updateInfo(o.rankl);
			this.render2.updateInfo(o);
			this.render3.updateInfo(o);

			if (!this.render3.visible) {
				this.render3.show(true, 1, false);

				this.render3.x=UIEnum.WIDTH - 238 >> 1;
				this.render3.y=UIEnum.HEIGHT - 250;
			}
		}

		private function exeTime(i:int):void {

			if (this.time - i > 0) {
				this.timeLbl.text="" + DateUtil.formatTime((this.time - i) * 1000, 1);
			} else {
				this.timeLbl.text="00:00";
				TimerManager.getInstance().remove(exeTime);
			}

		}

		public function resize():void {
			this.x=UIEnum.WIDTH - this.width;
			this.y=UIEnum.HEIGHT - this.height >> 1;

		}

		override public function hide():void {
			super.hide();
			this.render3.clsHid();
		}

		override public function get width():Number {
			return 248;
		}

		override public function get height():Number {
			return 500;
		}
	}
}
