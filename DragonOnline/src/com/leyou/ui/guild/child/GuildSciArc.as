package com.leyou.ui.guild.child {

	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TUnion_Bless;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.scrollPane.children.ScrollPane;
	
	import flash.events.MouseEvent;

	public class GuildSciArc extends AutoWindow {

		private var itemList:ScrollPane;
		private var items:Vector.<GuildSciBuyRender>;

		private var selectIndex:int;
		private var localIndex:int;

		public function GuildSciArc() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildSciArc.xml"));
			this.init();
			this.hideBg();
			this.mouseChildren=true;
			this.mouseEnabled=true;
			this.clsBtn.y-=10;
		}

		private function init():void {

			this.itemList=this.getUIbyID("itemList") as ScrollPane;
			this.items=new Vector.<GuildSciBuyRender>();
			 
		}

		public function showPanel(j:int):void {
			this.show();

			this.localIndex=j+1;

			var render:GuildSciBuyRender;
			for each (render in this.items) {
				this.itemList.delFromPane(render);
			}

			this.items.length=0;

			var arr:Array=UIManager.getInstance().guildWnd.guildSciData;
			var list:Object=TableManager.getInstance().getGuildblessByAll();
			var info:TUnion_Bless;
			var i:int=0;
			var d:int=0;
			var b:Boolean=false;
			var typeArr:Array=[];

			for each (info in list) {

				b=false;
				for (d=0; d < arr.length; d++) {
					if (arr[d] != null && arr[d][1] == info.build_Obj) {
						b=true;
						break;
					}
				}

				if (b)
					continue;

				if (info != null && typeArr.indexOf(info.build_Obj)==-1) {

					render=new GuildSciBuyRender();

					this.itemList.addToPane(render);
					this.items.push(render);

					render.updateInfo(info, this.localIndex);

					render.x=160 * (i % 3);
					render.y=182 * Math.floor(i / 3);

					typeArr.push(info.build_Obj);
					
					i++;
				}
				

			}


		}


	}
}
