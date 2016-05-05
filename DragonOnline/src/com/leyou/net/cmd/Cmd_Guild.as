package com.leyou.net.cmd {
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TUnion_attribute;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	/**
	 *协议列表

un


服务器 <----> 客户端


---------------------------------------------------------------------------
帮会列表
上行:un|Lbegin,end
		begin  --帮会列表开始索引从1开始
		end    --帮会列表结束索引
下行:un|{"mk":"L","list":{index:[unionid,uname,level,people,zpeople,zforce,uset],...}}
		list  -- 帮会列表信息
			  index  --第几个位置
			  unionid--帮会id
			  uname  --帮会名字
			  level  --帮会等级
			  people --帮会人数
			  zpeople --总帮会人数
			  zforce --总战斗力
			  uset     --是否设置了自动同意入帮(1自动同意,0不自动)



---------------------------------------------------------------------------
帮会信息
上行:un|I
下行:un|{"mk":I,"unionid":str, "unmae":str, "lname":str, "level":num, "people":num, "zpeople":num, "zforce":num, "uset":num, "rank":num, "duname":str, "online":num,"mnum":num, "lnum":num, "vnum":num,"xnum":num}
		lname  --帮主名字
		rank    --排名
		duname  --敌对帮会
		online  --在线人数
		mnum    --维护费用
		lnum    --升级费用
		vnum    --帮会活跃度
		xnum    --活跃度上限

---------------------------------------------------------------------------
成员列表
上行:un|Mbegin,end
下行:un|{"mk":"M","mlist":{index:[name,level,vocation,zbg,bg,job,nname,isonline,av],...}}
	  index  --第几个位置
				name       -- 名字
				vocation   -- 职业
				level      -- 等级
				zbg        -- 总捐献
				bg         -- 帮贡
				job        -- 职务(1帮主 2副帮主 3长老 4帮众)
				nname      -- 备注昵称
				isonline   -- 是否在线(1在线 0不在线)
				av         -- 是否设置自动同意邀请入帮(1自动同意入帮,0不自动)


---------------------------------------------------------------------------
帮会个人信息
   查询信息 上行:un|U|Wname
																											   设置职务 上行:un|U|Jname,job
   设置备注 上行:un|U|Nname,nname

																											下行:un|{"mk":"U","info":[name,level,vocation,zbg,bg,job,nname,isonline,av]}



   ---------------------------------------------------------------------------
																											帮会权限
	 查询权限  上行:un|P|Wjob
  设置权限  上行:un|P|Sjob,lt,sr,tr,sj,xz,gl


																		下行:un|{"mk":P,job:[lt,sr,tr,sj,xz,gl]}
			sr -- 收人 (0,1)
		  tr -- 踢人 (0,1)
		  sj -- 升级 (0,1)
		  xz -- 宣战 (0,1)
		  gl -- 管理 (0,1)

---------------------------------------------------------------------------



---------------------------------------------------------------------------
帮会公告
  查看公告 上行:un|N|Wunionid,ntype
																		  编辑公告 上行:un|N|Eunionid,ntype,notice

  下行:un|{"mk":N,"unionid":str,"ntype":num,"notice":str}
																				ntype  --公告类型(1帮会公告, 2帮会宣言)
		notice --文字内容



创建帮会
上行:un|Cuname
下行:un|{"mk":I,....}


---------------------------------------------------------------------------
申请入帮
上行:un|Aunionid
下行:un|{"mk":"A","member":[name,vocation,level,force]}


---------------------------------------------------------------------------
申请设置
上行:un|Buset
下行:un|{"mk":I,....}
		 uset (1自动同意,0不自动)


---------------------------------------------------------------------------
申请选择
上行:un|Yyn,name
下行:un|{"mk":I,....}
		 yn (1同意,0拒绝)


---------------------------------------------------------------------------
邀请入帮
上行:un|Wuname
下行:un|{"mk":"W","leader":[name,uname,level]}

---------------------------------------------------------------------------
邀请设置
上行:un|Nuset
	 uset (1自动同意,0不自动)

---------------------------------------------------------------------------
邀请选择
上行:un|Zyn,name
		yn (1同意,0拒绝)
---------------------------------------------------------------------------
踢出帮会
上行:un|Kname
下行:un|{"mk":"K","expel":name}


---------------------------------------------------------------------------
帮会捐献
上行:un|Dnum
下行:un|{"mk":I,...}
		(num --需要的帮贡值)
---------------------------------------------------------------------------
帮会宣战
上行:un|Xunionid
下行:un|{"mk":I,...}

---------------------------------------------------------------------------
帮会升级
上行:un|V
下行:un|{"mk":I,...}

---------------------------------------------------------------------------
购买帮会商店物品
上行:un|S	item_id,yuanbao(1使用元宝，0使用帮贡)
下行:un|{"mk":S}

	 * @author Administrator
	 *
	 */
	public class Cmd_Guild {


		public function Cmd_Guild() {


		}

		public static function sm_Guild_L(o:Object):void {
//			trace(o);
			if (!o.hasOwnProperty("list"))
				return;

			UIManager.getInstance().guildWnd.updateGuildList(o.list);
		}

		/**
		 *---------------------------------------------------------------------------
帮会列表
上行:un|Lbegin,end
begin  --帮会列表开始索引从1开始
end    --帮会列表结束索引
下行:un|{"mk":"L","list":{index:[unionid,uname,level,people,zpeople,zforce,uset],...}}
list  -- 帮会列表信息
index  --第几个位置
unionid--帮会id
uname  --帮会名字
level  --帮会等级
people --帮会人数
zpeople --总帮会人数
zforce --总战斗力
uset     --是否设置了自动同意入帮(1自动同意,0不自动)

*
*/
		public static function cm_GuildList(begin:int, end:int):void {
			NetGate.getInstance().send("un|L" + begin + "," + end);
		}

		public static function sm_Guild_U(o:Object):void {
			if (!o.hasOwnProperty("info"))
				return;

			if (!UIManager.getInstance().isCreate(WindowEnum.GUILD))
				return;

			UIManager.getInstance().guildWnd.updateMemInfo(o);
		}

		/**
		 *---------------------------------------------------------------------------
帮会个人信息
查询信息 上行:un|U|Wname

下行:un|{"mk":"U","info":[name,level,vocation,zbg,bg,job,nname,isonline,av]}

*
*/
		public static function cm_GuildMemInfo(name:String):void {
			NetGate.getInstance().send("un|U|W" + name);
		}

		/**
		 *---------------------------------------------------------------------
禅让会长
上行:un|Tname
* @param name
*
*/
		public static function cm_GuildAbdicate(name:String):void {
			NetGate.getInstance().send("un|T" + name);
		}

		/**
		 * 设置职务 上行:un|U|Jname,job
		 * @param name
		 *
		 */
		public static function cm_GuildOffice(name:String, job:int):void {
			NetGate.getInstance().send("un|U|J" + name + "," + job);
		}

		/**
		 *  设置备注 上行:un|U|Nname,nname
		 * @param name
		 *
		 */
		public static function cm_GuildDesc(name:String, desc:String):void {
			NetGate.getInstance().send("un|U|N" + name + "," + desc);
		}

		public static function sm_Guild_I(o:Object):void {

			if (!UIManager.getInstance().isCreate(WindowEnum.GUILD))
				UIManager.getInstance().creatWindow(WindowEnum.GUILD);
			
			UIManager.getInstance().guildWnd.setGuildListInviteState(o.yset);
			
			if (!o.hasOwnProperty("unionid")) {
				return;
			}

//			if (!UIManager.getInstance().guildWnd.visible)
//				UIManager.getInstance().guildWnd.show();

			UIManager.getInstance().guildWnd.updateMain(o);
		}

		/**
		 *---------------------------------------------------------------------------
帮会信息
上行:un|I
下行:un|{"mk":I,"unionid":str, "unmae":str, "lname":str, "level":num, "people":num, "zpeople":num, "zforce":num, "uset":num, "rank":num, "duname":str, "online":num,"mnum":num, "lnum":num, "vnum":num,"xnum":num}
lname  --帮主名字
rank    --排名
duname  --敌对帮会
online  --在线人数
mnum    --维护费用
lnum    --升级费用
vnum    --帮会活跃度
xnum    --活跃度上限

*
*/
		public static function cm_GuildInfo():void {
			NetGate.getInstance().send("un|I");
		}


		public static function sm_Guild_P(o:Object):void {

			if (!o.hasOwnProperty("job") || !o.hasOwnProperty("pow"))
				return;

			if (UIManager.getInstance().guildWnd.memberJob == o.job) {
				UIManager.getInstance().guildWnd.updateSelfPrice(o.pow);
			}

			if (UIManager.getInstance().guildWnd.guildId != "")
				UIManager.getInstance().guildWnd.guildPowManager.updateInfo(o.pow);

		}

		/**
		 *---------------------------------------------------------------------------
帮会权限
查询权限  上行:un|P|Wjob
设置权限  上行:un|P|Sjob,lt,sr,tr,sj,xz,gl


下行:un|{"mk":P,job:[lt,sr,tr,sj,xz,gl]}
sr -- 收人 (0,1)
tr -- 踢人 (0,1)
sj -- 升级 (0,1)
xz -- 宣战 (0,1)
gl -- 管理 (0,1)

*
*/
		public static function cm_GuildAuth(job:int):void {
			NetGate.getInstance().send("un|P|W" + job);
		}

		/**
		 *sr -- 收人 (0,1)
tr -- 踢人 (0,1)
sj -- 升级 (0,1)
xz -- 宣战 (0,1)
gl -- 管理 (0,1)
*
*/
		public static function cm_GuildAuthSet(job:int, sr:int, tr:int, sj:int, xz:int, gl:int):void {
			NetGate.getInstance().send("un|P|S" + job + "," + sr + "," + tr + "," + sj + "," + xz + "," + gl);
		}

		public static function sm_Guild_M(o:Object):void {
			if (!o.hasOwnProperty("mlist") || o == null)
				return;

			if (UIManager.getInstance().isCreate(WindowEnum.GUILD))
				UIManager.getInstance().guildWnd.updateMemberList(o);
		}

		/**
		 *---------------------------------------------------------------------------
成员列表
上行:un|Mbegin,end
下行:un|{"mk":"M","mlist":{index:[name,level,vocation,zbg,bg,job,nname,isonline,av],...}}
index  --第几个位置
name       -- 名字
vocation   -- 职业
level      -- 等级
zbg        -- 总捐献
bg         -- 帮贡
job        -- 职务(1帮主 2副帮主 3长老 4帮众)
nname      -- 备注昵称
isonline   -- 是否在线(1在线 0不在线)
av         -- 是否设置自动同意邀请入帮(1自动同意入帮,0不自动)

*
*/
		public static function cm_GuildMemList(begin:int, end:int):void {
			NetGate.getInstance().send("un|M" + begin + "," + end);
		}


		public static function sm_Guild_N(o:Object):void {

			if (!o.hasOwnProperty("notice") || !o.hasOwnProperty("unionid"))
				return;

			if (UIManager.getInstance().guildWnd.getTabName()=="mainBtn")
				UIManager.getInstance().guildWnd.updateMain(o);
			else if (UIManager.getInstance().guildWnd.getTabName() == "listBtn") {
				if (o.ntype == 2)
					UIManager.getInstance().guildWnd.updateGuildListNotice(o.notice);
			}
		}

		/**
		 *---------------------------------------------------------------------------
帮会公告
查看公告 上行:un|N|Wunionid,ntype

下行:un|{"mk":N,"unionid":str,"ntype":num,"notice":str}
ntype  --公告类型(1帮会公告, 2帮会宣言)
notice --文字内容

*
*/
		public static function cm_GuildNotice(unionid:String, ntype:int):void {
			NetGate.getInstance().send("un|N|W" + unionid + "," + ntype);
		}

		/**
		 *编辑公告 上行:un|N|Eunionid,ntype,notice
		 */
		public static function cm_GuildEditNotice(unionid:String, ntype:int, text:String):void {
			NetGate.getInstance().send("un|N|E" + unionid + "," + ntype + "," + text);
		}

		/**
		 *创建帮会
上行:un|Cuname
下行:un|{"mk":I,....}

*
*/
		public static function cm_GuildCreate(name:String, bind:int):void {
			NetGate.getInstance().send("un|C" + name + "," + bind);
		}

		public static function sm_Guild_A(o:Object):void {

			if (!o.hasOwnProperty("member"))
				return;

			if (!UIManager.getInstance().isCreate(WindowEnum.GUILD))
				UIManager.getInstance().creatWindow(WindowEnum.GUILD);

			UIManager.getInstance().guildWnd.guildInviteWnd.showPanel(o.member);
		}

		/**
		 *---------------------------------------------------------------------------
申请入帮
上行:un|Aunionid
下行:un|{"mk":"A","member":[name,vocation,level,force]}

*
*/
		public static function cm_GuildApply(id:String):void {
			NetGate.getInstance().send("un|A" + id);
		}


		/**
		 *---------------------------------------------------------------------------
申请设置
上行:un|Buset
下行:un|{"mk":I,....}
uset (1自动同意,0不自动)

*
*/
		public static function cm_GuildApplySet(set:int):void {
			NetGate.getInstance().send("un|B" + set);
		}
		
		/**
		 * -- 会长弹劾
-- 上行:un|G
		 * @param set
		 * 
		 */		
		public static function cm_GuildImpeachBoss():void {
			NetGate.getInstance().send("un|G");
		}


		/**
		 *---------------------------------------------------------------------------
申请选择
上行:un|Yyn,name
下行:un|{"mk":I,....}
yn (1同意,0拒绝)

*
*/
		public static function cm_GuildApplySelect(yn:int, name:String):void {
			NetGate.getInstance().send("un|Y" + yn + "," + name);
		}


		public static function sm_Guild_W(o:Object):void {
			if (!o.hasOwnProperty("leader"))
				return;

			if (!UIManager.getInstance().isCreate(WindowEnum.GUILD))
				UIManager.getInstance().creatWindow(WindowEnum.GUILD);

			UIManager.getInstance().guildWnd.guildInviteWnd.showPanel(o.leader, 1);
		}


		public static function sm_Guild_H(o:Object):void {
			if (!o.hasOwnProperty("pl"))
				return;

			UIManager.getInstance().guildWnd.guildAddWnd.showPanel(o.pl);
		}



		/**
		 * @param name
		 * --------------------------------------------------------------------------
		查询信息
		上行:un|H,name
		下行:un|{"mk":"H", "pl":[[name,pro,lv,att]...]}
		name --玩家名
			uname -- 行会名称
			pro --职业
			lv --等级
			att --战斗力
		 *
		 */
		public static function cm_GuildSearch(name:String=""):void {
			NetGate.getInstance().send("un|H," + name);
		}

		/**
		 *---------------------------------------------------------------------------
邀请入帮
上行:un|Wuname
下行:un|{"mk":"W","leader":[name,uname,level]}

*
*/
		public static function cm_GuildInvite(name:String):void {
			NetGate.getInstance().send("un|W" + name);
		}

		/**
		 *邀请设置
上行:un|Nuseto
uset (1自动同意,0不自动)

*
*/
		public static function cm_GuildInviteSet(uset:int):void {
			NetGate.getInstance().send("un|E" + uset);
		}

		/**
		 * 邀请选择
上行:un|Zyn,name
yn (1同意,0拒绝)
---------------------------------------------------------------------------

*/
		public static function cm_GuildInviteSelect(yn:int, name:String):void {
			NetGate.getInstance().send("un|Z" + yn + "," + name);
		}


		public static function sm_Guild_K(o:Object):void {
			if (!o.hasOwnProperty("expel"))
				return;

			UIManager.getInstance().guildWnd.requestMemList(o);
		}

		/**
		 *踢出帮会
上行:un|Kname
下行:un|{"mk":"K","expel":name}

*
*/
		public static function cm_GuildKill(name:String):void {
			NetGate.getInstance().send("un|K" + name);
		}

		/**
		 *---------------------------------------------------------------------------
帮会捐献
上行:un|Dnum
下行:un|{"mk":I,...}
(num --需要的帮贡值)

* -- 帮会捐献
-- 上行：un|Dnum,btype (1钻石 2金币)
*
*/
		public static function cm_GuildContribute(num:int, type:int):void {
			NetGate.getInstance().send("un|D" + num + "," + type);
		}

		/**
		 *---------------------------------------------------------------------------
帮会宣战
上行:un|Xunionid
下行:un|{"mk":I,...}

*
*/
		public static function cm_GuildPk(id:int):void {
			NetGate.getInstance().send("un|X" + id);
		}

		/**
		 *---------------------------------------------------------------------------
帮会升级
上行:un|V
下行:un|{"mk":I,...}

*
*/
		public static function cm_GuildUpgrade():void {
			NetGate.getInstance().send("un|V");
		}


		public static function sm_Guild_S(o:Object):void {
//			trace(o);
		}


		/**
		 *---------------------------------------------------------------------------
购买帮会商店物品
上行:un|S	item_id,yuanbao(1使用元宝，0使用帮贡)
下行:un|{"mk":S}

*
*/
		public static function cm_GuildBuy(item_id:int, yuanbao:int=0):void {
			NetGate.getInstance().send("un|S" + item_id + "," + yuanbao);
		}

		public static function sm_Guild_Q(o:Object):void {
			
			if(!UIManager.getInstance().isCreate(WindowEnum.GUILD))
				return ;
			
			UIManager.getInstance().guildWnd.guildName="";
			UIManager.getInstance().guildWnd.guildId="";
			UIManager.getInstance().guildWnd.guildLv=0;
			UIManager.getInstance().guildWnd.guildContribute=0;
			UIManager.getInstance().guildWnd.clearData();
			MyInfoManager.getInstance().isGuild=false;

			if (UIManager.getInstance().guildWnd.visible)
				UIManager.getInstance().guildWnd.resetWnd();
		}

		/**
		---------------------------------------------------------------------------
		退出帮会
		上行:un|Q
		下行:un|{"mk":"Q"}

		 *
		 */
		public static function cm_GuildQuit():void {
			NetGate.getInstance().send("un|Q");
		}

		public static function sm_Guild_F(o:Object):void {
			if (!o.hasOwnProperty("log"))
				return;

			UIManager.getInstance().guildWnd.updateMainActive(o);
		}

		/**
		 *---------------------------------------------------------------------------
帮会动态
上行:un|Freindex
下行:un|{"mk":F,"log":[[ltype,time,msgid,mval],...]}
reindex  --请求最后几条

ltype   --log类型(1人员 2资金变动 3其他)
time    --时间字符串
msgid   --消息提示id
mval    --消息提示变量
* @param num
*
*/
		public static function cm_GuildActive(num:int):void {
			NetGate.getInstance().send("un|F" + num);
		}


		public static function sm_Guild_J(o:Object):void {
			if (!o.hasOwnProperty("jlist"))
				return;

//			if (UIManager.getInstance().isCreate(WindowEnum.GUILD))
//				UIManager.getInstance().guildWnd.updateSkill(o);


			UIManager.getInstance().skillWnd.updateSkill(o);

			var info:TUnion_attribute;
			for (var i:int=0; i < o.jlist.length; i++) {

				info=TableManager.getInstance().getguildAttributeInfo(int(o.jlist[i]));

				if (info.lv > 0) {
					UIManager.getInstance().roleHeadWnd.activeIcon("guildImg", true, o.jlist);
					break;
				}

			}

		}

		/**
		 ---------------------------------------------------------------------
行会技能
上行:un|Jatt
下行:un|{mk:"J",jlist:{[att]:lv,...}}
-- jlist 技能列表
--att 属性id  (0表示查看其它id为升级 1.生命上限 4.物攻 5.物防 6.法攻 7.法防)
--lv  等级

* @param num
   *
		   */
		public static function cm_GuildSkill(att:int=0):void {
			NetGate.getInstance().send("un|J" + att);
		}


		/******************************行会众筹 ****************************************************************************************************/

		public static function cm_GuildZCInit():void {
			NetGate.getInstance().send(CmdEnum.CM_GUILD_R);
		}

		/**
		 *----------------------------------------------------------------
行会众筹
上行: un|R
下行：un|{"mk":"R","uzc":num, "bl":num, "mzc":num, "dtime":str, "zclist":[[name,zc],...]}
-- uzc 行会当前众筹值
-- bl   当前倍率
	   -- mzc  我的众筹值
			-- dtime  结算时间
		 -- zclist 众筹列表
			-- name 玩家名字
			-- zc   众筹值
		 *
		 */
		public static function sm_Guild_R(o:Object):void {
			if (!o.hasOwnProperty("dtime"))
				return;

			if (!UIManager.getInstance().isCreate(WindowEnum.GUILD))
				UIManager.getInstance().creatWindow(WindowEnum.GUILD);

//			if (!UIManager.getInstance().isCreate(WindowEnum.GUILD) || !UIManager.getInstance().guildWnd.visible)
//				return;

			UIManager.getInstance().guildWnd.updateGuildZc(o);
		}
		
		/**
		 *--------------------------------------------------------------------------------
-- 行会招集
-- 上行:un|Oetype (0钻石 1道具) 
		 * @param type
		 * 
		 */		
		public static function cm_GuildCall(type:int):void{
			NetGate.getInstance().send("un|O"+type);
		}

	}
}
