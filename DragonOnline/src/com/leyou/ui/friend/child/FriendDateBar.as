package com.leyou.ui.friend.child {
	import com.ace.config.Core;
	import com.ace.enum.PlatformEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TNoticeInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.friend.FriendInfo;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class FriendDateBar extends AutoSprite{

		private var friendImgBg:Image;
		private var userHeadImg:Image;
		private var bothwayImg:Image;
		private var vipImg:Image;
		private var pfImg:Image;
		private var pfImgContainer:Sprite;

		private var lvLbl:Label;
		private var nameLbl:Label;

		public  var info:FriendInfo;
		
		/**
		 * 构造
		 * 
		 */	
		public function FriendDateBar() {
			super(LibManager.getInstance().getXML("config/ui/friends/FriendDateBar.xml"));
			this.mouseChildren=true;
			this.mouseEnabled=true;
			this.init();
		}

		/**
		 * 初始化
		 * 
		 */	
		private function init():void {
			info = new FriendInfo();
			this.friendImgBg=this.getUIbyID("friendItemBg") as Image;
			this.friendImgBg.updateBmp("ui/friend/friend_btn.jpg");
			this.bothwayImg=this.getUIbyID("bothwayImg") as Image;
			this.pfImg=this.getUIbyID("pfImg") as Image;
			var container:Sprite = new Sprite();
			container.name = this.bothwayImg.name;
			container.addChild(this.bothwayImg);
			container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addChild(container);
			this.vipImg=this.getUIbyID("vipImg") as Image;
			this.userHeadImg=this.getUIbyID("userHeadImg") as Image;
			container = new Sprite();
			container.name = this.userHeadImg.name;
			container.addChild(this.userHeadImg);
			container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addChild(container);
			container = new Sprite();
			container.name = this.vipImg.name;
			container.addChild(this.vipImg);
			container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addChild(container);
			pfImg.visible = false;
			pfImgContainer = new Sprite();
			pfImgContainer.addChild(pfImg);
			addChild(pfImgContainer);
			pfImgContainer.addEventListener(MouseEvent.CLICK, onVipClick);

			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;

			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut, false, 0, true);
		}
		
		protected function onVipClick(event:MouseEvent):void{
			UILayoutManager.getInstance().open(WindowEnum.QQ_VIP);
		}
		
		/**
		 * 鼠标移入 
		 * 
		 */		
		protected function onMouseOver(event:MouseEvent):void{
			if("bothwayImg" == event.target.name){
				var contentID:int = this.info.efriend ? 2818 : 2817;
				var notice:TNoticeInfo = TableManager.getInstance().getSystemNotice(contentID);
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, notice.content, new Point(stage.mouseX, stage.mouseY));
			}else if("userHeadImg" == event.target.name){
				var content:String;
				switch(info.vocation){
					case PlayerEnum.PRO_MASTER:
						content = PropUtils.getStringById(1526);
						break;
					case PlayerEnum.PRO_RANGER:
						content = PropUtils.getStringById(1527);
						break;
					case PlayerEnum.PRO_SOLDIER:
						content = PropUtils.getStringById(1528);
						break;
					case PlayerEnum.PRO_WARLOCK:
						content = PropUtils.getStringById(1529);
						break;
				}
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
			}else if("vipImg" == event.target.name){
				var contentv:String = TableManager.getInstance().getSystemNotice(6008).content;
				contentv = StringUtil.substitute(contentv, info.vip);
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, contentv, new Point(stage.mouseX, stage.mouseY));
			}
		}
		
		/**
		 * 鼠标移入监听函数
		 * 
		 */	
		private function mouseOver(evt:MouseEvent):void{
			updateBmpMouseOver();
		}
		
		/**
		 * 鼠标移出监听函数
		 * 
		 */	
		private function mouseOut(evt:MouseEvent):void{ 
			updateBmdComm();
		}
		
		/**
		 * 外部调用  底图高亮
		 * 
		 */		
		public function updateBmpMouseOver():void{
			if(this.info.online){
				this.friendImgBg.updateBmp("ui/friend/friend_btn_over.png");
			}
		}
		
		/**
		 * 外部调用 底图正常
		 * 
		 */		
		public function updateBmdComm():void{
			if(this.info.online){
				this.friendImgBg.updateBmp("ui/friend/friend_btn.jpg");
			}
		}
		
		/**
		 * <T>更新好友信息</T>
		 * 
		 */	
		public function updateInfo(o:Object, $relaction:int):void{
			this.info.name     = o[0];
			this.info.online   = o[1];
			this.info.level    = o[2];
			this.info.vocation = o[3];
			this.info.vip      = o[4];
			this.info.efriend  = o[5];
			this.info.relation = $relaction;
			this.lvLbl.text = this.info.level + "";
			this.nameLbl.text = this.info.name;
			this.vipImg.visible = (0 != this.info.vip);
			this.bothwayImg.filters = this.info.efriend ? null : [FilterUtil.enablefilter];
			this.filters = this.info.online ? null : [FilterUtil.enablefilter];
//			if(!this.info.online){
//				this.filters = [FilterUtil.enablefilter];
//			}else{
//				this.filters = null;
//			}
			this.vipImg.updateBmp("ui/name/vip" + info.vip + ".jpg");
			this.userHeadImg.updateBmp("ui/common/common_profession_" + info.vocation + ".png");
			
			var pfVipType:int = o[6];
			var pfVipLv:int = o[7];
			//平台VIP
			if(Core.isTencent){
				pfImg.visible = (0 != pfVipType);
				var url:String;
				// 腾讯
				if(1 == pfVipType){
					url = StringUtil.substitute("ui/name/qq_vip_0{1}.png", pfVipLv);
					pfImg.updateBmp(url);
				}else if(2 == pfVipType){
					url = StringUtil.substitute("ui/name/qq_vip_year_0{1}.png", pfVipLv);
					pfImg.updateBmp(url);
				}
			}
		}

		/**
		 * <T>生命周期结束</T>
		 *
		 */
		public override function die():void{
			vipImg.die();
			bothwayImg.die();
			userHeadImg.die();
			friendImgBg.die();
			
			vipImg = null;
			bothwayImg = null;
			userHeadImg = null;
			friendImgBg = null;
			
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			
			info = null;
			lvLbl = null;
			nameLbl = null;
		}

	}
}
