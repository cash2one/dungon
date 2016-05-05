package com.ace.manager {


	import com.ace.config.Core;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSeGuild;
	import com.leyou.ui.message.GuildMessage;
	import com.leyou.utils.BadgeUtil;
	import com.leyou.utils.ShopUtil;

	public class GuideDirectManager {


		private static var _instance:GuideDirectManager;

		private var gmsgArr:Array=[];

		private var currentBagNumArr:Array=[];

		public function GuideDirectManager() {
		}

		public static function getInstance():GuideDirectManager {
			if (_instance == null)
				_instance=new GuideDirectManager();

			return _instance;
		}


		public function getGuideByType(type:int):void {

			this.currentBagNumArr=[];
			var obj:Object=TableManager.getInstance().getseGuideAll();

			var tinfo:TSeGuild;
			for each (tinfo in obj) {

				if (int(tinfo.type) == type && (int(tinfo.actType) == 0 && Core.me.info.level >= int(tinfo.actLv) || int(tinfo.actType) == 1 && Core.me.info.level == int(tinfo.actLv))) {

					switch (type) {
						case 1:
							this.updateBag(tinfo);
							break;
						case 2:
							this.updateBadge(tinfo);
							break;
						case 3:
							this.updateCurrency(tinfo);
							break;
						case 4:
//							this.updateWelfare(tinfo);
							break;

					}

				}

			}

		}

		private function updateBag(tinfo:TSeGuild):void {

			if (this.gmsgArr[tinfo.id] != null)
				return;

			var iArr:Array=tinfo.typeId.split(",");
			var ids:String;
			var gmsg:GuildMessage;

			var itd:Object=TableManager.getInstance().getItemInfo(int(iArr[0]));
			if (itd == null)
				itd=TableManager.getInstance().getEquipInfo(int(iArr[0]));

			var num:int=MyInfoManager.getInstance().getBagItemNumByName(itd.name);

//			this.currentBagNumArr[itd.name]+=num;

			if (num >= int(tinfo.typeNum)) {
				gmsg=new GuildMessage();
				this.gmsgArr[tinfo.id]=(gmsg);
				LayerManager.getInstance().windowLayer.addChild(gmsg);
				gmsg.show();
				gmsg.updateInfo(tinfo);

			}


		}

		private function updateBadge(tinfo:TSeGuild):void {
			var gmsg:GuildMessage;

			if (this.gmsgArr[tinfo.id] != null)
				return;

//			if (BadgeUtil.BadgeCurrentPoint + 1 == int(tinfo.typeId)) {

				gmsg=new GuildMessage();
				this.gmsgArr[tinfo.id]=(gmsg);
				LayerManager.getInstance().windowLayer.addChild(gmsg);
				gmsg.show();
				gmsg.updateInfo(tinfo);

//			}

		}

		private function updateSkill(tinfo:TSeGuild):void {
			var gmsg:GuildMessage;

			if (this.gmsgArr[tinfo.id] != null)
				return;

			gmsg=new GuildMessage();
			this.gmsgArr[tinfo.id]=(gmsg);
			LayerManager.getInstance().windowLayer.addChild(gmsg);
			gmsg.show();
			gmsg.updateInfo(tinfo);

		}

		private function updateCurrency(tinfo:TSeGuild):void {
			var gmsg:GuildMessage;

			if (this.gmsgArr[tinfo.id] != null)
				return;

			if (ShopUtil.getIndexTotMoney(int(tinfo.typeId)) >= int(tinfo.typeNum)) {

				gmsg=new GuildMessage();
				this.gmsgArr[tinfo.id]=(gmsg);
				LayerManager.getInstance().windowLayer.addChild(gmsg);
				gmsg.show();
				gmsg.updateInfo(tinfo);
			}

		}


		private function updateWelfare(tinfo:TSeGuild):void {
			var gmsg:GuildMessage;

			if (this.gmsgArr[tinfo.id] != null)
				return;

			if (tinfo.type == "") {

				gmsg=new GuildMessage();
				this.gmsgArr[tinfo.id]=(gmsg);
				LayerManager.getInstance().windowLayer.addChild(gmsg);
				gmsg.show();
				gmsg.updateInfo(tinfo);
			}

		}

		/**
		 * 福利外用
		 *
		 */
		public function updateWelfareOther():void {

			var tinfo:TSeGuild=TableManager.getInstance().getseGuideById(57);

			if (this.gmsgArr[tinfo.id] != null)
				return;

			var gmsg:GuildMessage;

			if (Core.me.info.level >= int(tinfo.actLv)) {
				gmsg=new GuildMessage();
				this.gmsgArr[tinfo.id]=(gmsg);
				LayerManager.getInstance().windowLayer.addChild(gmsg);
				gmsg.show();
				gmsg.updateInfo(tinfo);
			}
		}

		public function checkLevelValid(level:int):void {

			this.currentBagNumArr=[];
			var obj:Object=TableManager.getInstance().getseGuideAll();
			var lv:int=level;

			var tinfo:TSeGuild;
			for each (tinfo in obj) {

				if (int(tinfo.actType) == 0 && lv >= int(tinfo.actLv)) {

					switch (int(tinfo.type)) {
						case 1:
							this.updateBag(tinfo);
							break;
						case 2:
							this.updateBadge(tinfo);
							break;
						case 3:
							this.updateCurrency(tinfo);
							break;
						case 4:
							break;

					}

				}

			}

		}


		public function checkLevelValidII(level:int):void {
			this.currentBagNumArr=[];
			var obj:Object=TableManager.getInstance().getseGuideAll();
			var lv:int=level;

			var tinfo:TSeGuild;
			for each (tinfo in obj) {

				if (int(tinfo.actType) == 1 && lv == int(tinfo.actLv)) {

					switch (int(tinfo.type)) {
						case 1:
							this.updateBag(tinfo);
							break;
						case 2:
							this.updateBadge(tinfo);
							break;
						case 3:
							break;
						case 4:
//							this.updateWelfare(tinfo);
							break;
						default:  {
							//技能
							this.updateSkill(tinfo);
							this.updateWelfare(tinfo);
						}

					}

				}

			}

		}

		public function delPanel(tid:String):void {

			if (this.gmsgArr[tid] == null)
				return;

			this.gmsgArr[tid]=null;
			delete this.gmsgArr[tid];
		}

		public function reSize():void {

			var gm:GuildMessage;
			for each (gm in this.gmsgArr) {
				gm.reSize();
			}

		}

	}
}
