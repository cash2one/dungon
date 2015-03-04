package com.leyou.ui.guild.child {
	
	
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	
	import flash.events.MouseEvent;

	public class GuildWarUnready extends AutoSprite {

		private var lvBtn:ImgLabelButton;
		private var countBtn:ImgLabelButton;
		private var powerBtn:ImgLabelButton;
		
		private var arrowPro:Image;
		private var arrowDon:Image;
		private var arrowCon:Image;
		
		private var itemlist:ScrollPane;
		
		private var itemsArr:Vector.<GuildWarRender>;
		
		private var sortStateArr:Array=[false, false, false];
		private var info:Object;

		public function GuildWarUnready() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildWarUnready.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.lvBtn=this.getUIbyID("lvBtn") as ImgLabelButton;
			this.countBtn=this.getUIbyID("countBtn") as ImgLabelButton;
			this.powerBtn=this.getUIbyID("powerBtn") as ImgLabelButton;
			
			this.arrowPro=this.getUIbyID("arrowPro") as Image;
			this.arrowDon=this.getUIbyID("arrowDon") as Image;
			this.arrowCon=this.getUIbyID("arrowCon") as Image;
			
			this.itemlist=this.getUIbyID("itemlist") as ScrollPane;
			
			this.lvBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.countBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.powerBtn.addEventListener(MouseEvent.CLICK, onClick);
			
			this.itemlist.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.itemlist.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.itemlist.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//			this.itemlist.addEventListener(MouseEvent.MOUSE_UP, onMouseOut);
			
			this.itemsArr=new Vector.<GuildWarRender>();
			
			this.x=-15;
			this.y=2;
		}
		
		private function onMouseOver(e:MouseEvent):void {
			if (e.target is GuildWarRender)
				GuildWarRender(e.target).setSelectState(1);
		}
		
		private function onMouseOut(e:MouseEvent):void {
			if (e.target is GuildWarRender)
				GuildWarRender(e.target).setSelectState(2);
		}
		
		private function onMouseDown(e:MouseEvent):void {
			if (e.target is GuildWarRender)
				GuildWarRender(e.target).setSelectState(1);
		}

		private function onClick(e:MouseEvent):void {
			
			
			switch (e.target.name) {
				case "lvBtn":
					
					this.sortStateArr[0]=!this.sortStateArr[0];
					
					this.arrowPro.fillEmptyBmd();
					if (this.sortStateArr[0]) {
						this.info.list.sortOn("2", Array.DESCENDING | Array.NUMERIC);
						this.arrowPro.updateBmp("ui/guild/icon_arrows_d.png");
					} else {
						this.info.list.sortOn("2", Array.CASEINSENSITIVE | Array.NUMERIC);
						this.arrowPro.updateBmp("ui/guild/icon_arrows_u.png");
					}
					
					break;
				case "countBtn":
					this.sortStateArr[1]=!this.sortStateArr[1];
					this.arrowDon.fillEmptyBmd();
					if (this.sortStateArr[1]) {
						this.info.list.sortOn("3", Array.DESCENDING | Array.NUMERIC);
						this.arrowDon.updateBmp("ui/guild/icon_arrows_d.png");
					} else {
						this.info.list.sortOn("3", Array.CASEINSENSITIVE | Array.NUMERIC);
						this.arrowDon.updateBmp("ui/guild/icon_arrows_u.png");
					}
					
					break;
				case "powerBtn":
					this.sortStateArr[1]=!this.sortStateArr[1];
					this.arrowCon.fillEmptyBmd();
					if (this.sortStateArr[1]) {
						this.info.list.sortOn("4", Array.DESCENDING | Array.NUMERIC);
						this.arrowCon.updateBmp("ui/guild/icon_arrows_d.png");
					} else {
						this.info.list.sortOn("4", Array.CASEINSENSITIVE | Array.NUMERIC);
						this.arrowCon.updateBmp("ui/guild/icon_arrows_u.png");
					}
					
					break;
			}
			
			this.updateData();
		}
		
		private function updateData():void {
			
			var render:GuildWarRender;
			for each (render in this.itemsArr) {
				this.itemlist.delFromPane(render);
			}
			
			this.itemsArr.length=0;
			
			var list:Array=this.info.list;
			
			for (var i:int=0; i < list.length; i++) {
				
				render=new GuildWarRender();
				
				this.itemsArr.push(render);
				this.itemlist.addToPane(render);
				
				render.y=i * render.height;
				render.updateInfo(list[i]);
				
			}
		}

		public function updateInfo(o:Object):void {
			this.info=o;
			this.updateData();
		}

		
	}
}
