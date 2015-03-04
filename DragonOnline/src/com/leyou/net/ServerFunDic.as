package com.leyou.net {
	import com.ace.config.Core;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.cmd.Cmd_Achievement;
	import com.leyou.net.cmd.Cmd_Act;
	import com.leyou.net.cmd.Cmd_Active;
	import com.leyou.net.cmd.Cmd_Arena;
	import com.leyou.net.cmd.Cmd_Assist;
	import com.leyou.net.cmd.Cmd_Attack;
	import com.leyou.net.cmd.Cmd_Aution;
	import com.leyou.net.cmd.Cmd_BCP;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.net.cmd.Cmd_Bld;
	import com.leyou.net.cmd.Cmd_Blt;
	import com.leyou.net.cmd.Cmd_CCZ;
	import com.leyou.net.cmd.Cmd_CD;
	import com.leyou.net.cmd.Cmd_CLI;
	import com.leyou.net.cmd.Cmd_Chat;
	import com.leyou.net.cmd.Cmd_Collection;
	import com.leyou.net.cmd.Cmd_CpTm;
	import com.leyou.net.cmd.Cmd_Cpy;
	import com.leyou.net.cmd.Cmd_Duel;
	import com.leyou.net.cmd.Cmd_EXPC;
	import com.leyou.net.cmd.Cmd_Ecp;
	import com.leyou.net.cmd.Cmd_Element;
	import com.leyou.net.cmd.Cmd_Equip;
	import com.leyou.net.cmd.Cmd_FCZ;
	import com.leyou.net.cmd.Cmd_Fanl;
	import com.leyou.net.cmd.Cmd_Farm;
	import com.leyou.net.cmd.Cmd_Fcm;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_GBUY;
	import com.leyou.net.cmd.Cmd_GM;
	import com.leyou.net.cmd.Cmd_Gem;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.net.cmd.Cmd_Guide;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_GuildBattle;
	import com.leyou.net.cmd.Cmd_Invest;
	import com.leyou.net.cmd.Cmd_KF;
	import com.leyou.net.cmd.Cmd_LDW;
	import com.leyou.net.cmd.Cmd_LZ;
	import com.leyou.net.cmd.Cmd_Link;
	import com.leyou.net.cmd.Cmd_Login;
	import com.leyou.net.cmd.Cmd_Mail;
	import com.leyou.net.cmd.Cmd_Market;
	import com.leyou.net.cmd.Cmd_Mount;
	import com.leyou.net.cmd.Cmd_Nck;
	import com.leyou.net.cmd.Cmd_Npc;
	import com.leyou.net.cmd.Cmd_ONL;
	import com.leyou.net.cmd.Cmd_PM;
	import com.leyou.net.cmd.Cmd_PayRank;
	import com.leyou.net.cmd.Cmd_Pkm;
	import com.leyou.net.cmd.Cmd_Prop;
	import com.leyou.net.cmd.Cmd_QQVip;
	import com.leyou.net.cmd.Cmd_Qa;
	import com.leyou.net.cmd.Cmd_Rank;
	import com.leyou.net.cmd.Cmd_Role;
	import com.leyou.net.cmd.Cmd_SCP;
	import com.leyou.net.cmd.Cmd_Scene;
	import com.leyou.net.cmd.Cmd_Seven;
	import com.leyou.net.cmd.Cmd_Shp;
	import com.leyou.net.cmd.Cmd_Sinfo;
	import com.leyou.net.cmd.Cmd_Skill;
	import com.leyou.net.cmd.Cmd_Stime;
	import com.leyou.net.cmd.Cmd_SystemNotice;
	import com.leyou.net.cmd.Cmd_TCS;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.net.cmd.Cmd_TobeStrong;
	import com.leyou.net.cmd.Cmd_Tsk;
	import com.leyou.net.cmd.Cmd_Ucp;
	import com.leyou.net.cmd.Cmd_Unw;
	import com.leyou.net.cmd.Cmd_Vip;
	import com.leyou.net.cmd.Cmd_WARC;
	import com.leyou.net.cmd.Cmd_WExp;
	import com.leyou.net.cmd.Cmd_Wbox;
	import com.leyou.net.cmd.Cmd_Wbs;
	import com.leyou.net.cmd.Cmd_Welfare;
	import com.leyou.net.cmd.Cmd_Wig;
	import com.leyou.net.cmd.Cmd_Worship;
	import com.leyou.net.cmd.Cmd_YBS;
	import com.leyou.net.cmd.Cmd_Yct;
	import com.leyou.net.cmd.Cmd_ddsc;


	public class ServerFunDic {
		private static var dict:Object=null;

		public function ServerFunDic() {
		}

		public static function setup():void {

			if (!ServerFunDic.dict) {
				dict={};
				Cmd_GM.setup();

				//登陆
				dict[CmdEnum.SM_1017]=Cmd_Login.sm_1017;
				dict[CmdEnum.SM_SID]=Cmd_Login.sm_sid;
				dict[CmdEnum.SM_COV_N]=Cmd_Login.sm_covN;
				dict[CmdEnum.SM_COV_E]=Cmd_Login.sm_covE;
				dict[CmdEnum.SM_COV_P]=Cmd_Login.sm_covP;
				dict[CmdEnum.SM_COV_L]=Cmd_Login.sm_covL;
				
				// 服务器和服信息
				dict[CmdEnum.SM_SINFO_I]=Cmd_Sinfo.sm_Sinfo_I;

				//场景
				dict[CmdEnum.SM_CUE]=Cmd_Scene.sm_cue;
				dict[CmdEnum.SM_GAM]=Cmd_Scene.sm_game;
				dict[CmdEnum.SM_R]=Cmd_Scene.sm_r;
				dict[CmdEnum.SM_3000]=Cmd_Scene.sm_3000;
				dict[CmdEnum.SM_3001]=Cmd_Scene.sm_3001;
				dict[CmdEnum.SM_P]=Cmd_Scene.sm_p;
				dict[CmdEnum.SM_3020]=Cmd_Scene.sm_3020;

//				return;
				//======================================================
				dict[CmdEnum.SM_3002]=Cmd_Scene.sm_3002;
				dict[CmdEnum.SM_3003]=Cmd_Scene.sm_3003;
				dict[CmdEnum.SM_3005]=Cmd_Scene.sm_3005;
				dict[CmdEnum.SM_D]=Cmd_Scene.sm_d;
				dict[CmdEnum.SM_A]=Cmd_Scene.sm_a;
				dict[CmdEnum.SM_SIT_S]=Cmd_Scene.sm_sit_s;
				dict[CmdEnum.SM_3004]=Cmd_Scene.sm_3004;

				dict[CmdEnum.SM_UST_U]=Cmd_Scene.sm_ust_u;
				dict[CmdEnum.SM_NTK_I]=Cmd_Attack.sm_ntk_i;
				dict[CmdEnum.SM_3021]=Cmd_Attack.sm_3021;
				dict[CmdEnum.SM_3022]=Cmd_Attack.sm_3022;

				//道具
				dict[CmdEnum.SM_DROP_A]=Cmd_Scene.sm_drop_a;
				dict[CmdEnum.SM_DROP_D]=Cmd_Scene.sm_drop_d
				dict[CmdEnum.SM_DROP_S]=Cmd_Scene.smd_drop_s
				dict[CmdEnum.SM_DROP_F]=Cmd_Scene.smd_drop_f

				//战斗
				dict[CmdEnum.SM_3010]=Cmd_Attack.sm_3010;
				dict[CmdEnum.SM_3011]=Cmd_Attack.sm_3011;
				dict[CmdEnum.SM_3012]=Cmd_Attack.sm_3012;
				dict[CmdEnum.SM_BFT_I]=Cmd_Attack.sm_bft_I;
				dict[CmdEnum.SM_3013]=Cmd_Attack.sm_3013;
				dict[CmdEnum.SM_3014]=Cmd_Attack.sm_3014;
				dict[CmdEnum.SM_3015]=Cmd_Attack.sm_3015;
				dict[CmdEnum.SM_3016]=Cmd_Attack.sm_3016;
				dict[CmdEnum.SM_3017]=Cmd_Attack.sm_3017;
				dict[CmdEnum.SM_3023]=Cmd_Attack.sm_3023;

				// 死亡复活
				dict[CmdEnum.SM_REV]=Cmd_Attack.sm_rev;
				dict[CmdEnum.SM_REV_R]=Cmd_Attack.sm_rev_r;
				dict[CmdEnum.SM_REV_B]=Cmd_Attack.sm_REV_B;
				if (Core.clientTest)
					return;

				//系统提示
				dict[CmdEnum.SYSTEM_NOTICE_MSG]=Cmd_SystemNotice.ser_Notice;

				//属性变化
				dict[CmdEnum.SM_SYNP]=Cmd_Prop.sm_synp;

				//背包
				dict[CmdEnum.SM_BAG_D]=Cmd_Bag.sm_bag;
				dict[CmdEnum.SM_BAG_G]=Cmd_Bag.sm_bag;
				dict[CmdEnum.SM_BAG_J]=Cmd_Bag.sm_bag;
				dict[CmdEnum.SM_BAG_L]=Cmd_Bag.sm_bag;
				dict[CmdEnum.SM_BAG_U]=Cmd_Bag.sm_bag;
				dict[CmdEnum.SM_BAG_X]=Cmd_Bag.sm_bag;
				dict[CmdEnum.SM_BAG_Q]=Cmd_Bag.sm_bag;
				dict[CmdEnum.SM_BAG_N]=Cmd_Bag.sm_bag_N;
				dict[CmdEnum.SM_BAG_Z]=Cmd_Bag.sm_bag;

				//聊天
				dict[CmdEnum.CHAT_SAY]=Cmd_Chat.sm_Say;
				dict[CmdEnum.SM_CHAT_S]=Cmd_Chat.sm_CHAT_S;

				//人物面板
				dict[CmdEnum.ROLE_ATT_ME]=Cmd_Role.sm_att;
				dict[CmdEnum.ROLE_ATT_OTHER]=Cmd_Role.sm_att;
				dict[CmdEnum.EQUIP_EQP_ME]=Cmd_Role.sm_eqp;
				dict[CmdEnum.EQUIP_EQP_OTHER]=Cmd_Role.sm_eqp;
				dict[CmdEnum.EQUIP_EQP_DROP]=Cmd_Role.sm_offEquip;

				//元素
				dict[CmdEnum.SM_ELEMENT_ELE_C]=Cmd_Element.sm_ele_c;
				dict[CmdEnum.SM_ELEMENT_ELE_L]=Cmd_Element.sm_ele_s;
				dict[CmdEnum.SM_ELEMENT_ELE_S]=Cmd_Element.sm_ele_s;
				dict[CmdEnum.SM_ELEMENT_ELE_M]=Cmd_Element.sm_ele_M;
				dict[CmdEnum.SM_ELEMENT_ELE_Z]=Cmd_Element.sm_ele_Z;

				//技能
				dict[CmdEnum.SM_SKL_A]=Cmd_Skill.sm_skl_A;
				dict[CmdEnum.SM_SKL_I]=Cmd_Skill.sm_skl_I;
				dict[CmdEnum.SM_SKL_R]=Cmd_Skill.sm_skl_R;
				dict[CmdEnum.SM_SKL_C]=Cmd_Skill.sm_skl_C;
				dict[CmdEnum.SM_SKL_L]=Cmd_Skill.sm_skl_L;

				//快捷键
				dict[CmdEnum.SM_LINK_I]=Cmd_Link.sm_link_i;
				dict[CmdEnum.SM_LINK_C]=Cmd_Link.sm_link_c;
				dict[CmdEnum.SM_LINK_S]=Cmd_Link.sm_link_s;

				//血脉
				dict[CmdEnum.SM_BLD_O]=Cmd_Bld.sm_bld_O;
				dict[CmdEnum.SM_BLD_P]=Cmd_Bld.sm_bld_P;
				dict[CmdEnum.SM_BLD_W]=Cmd_Bld.sm_bld_W;
				dict[CmdEnum.SM_BLD_L]=Cmd_Bld.sm_bld_L;

				//商店
				dict[CmdEnum.SM_SHP_I]=Cmd_Shp.sm_shp_I;
				dict[CmdEnum.SM_SHP_O]=Cmd_Shp.sm_shp_O;
				dict[CmdEnum.SM_SHP_N]=Cmd_Shp.sm_shp_N;

				//任务
				dict[CmdEnum.SM_TSK_A]=Cmd_Tsk.sm_tsk_A;
				dict[CmdEnum.SM_TSK_D]=Cmd_Tsk.sm_tsk_D;
				dict[CmdEnum.SM_TSK_T]=Cmd_Tsk.sm_tsk_T;

				//寻路
				dict[CmdEnum.SM_GO_P]=Cmd_Go.sm_go_p;
				dict[CmdEnum.SM_GO_G]=Cmd_Go.sm_go_G;
				dict[CmdEnum.SM_GO_V]=Cmd_Go.sm_go_V;
				dict[CmdEnum.SM_GO_C]=Cmd_Go.sm_go_C;

				//npc
				dict[CmdEnum.SM_NPC_C]=Cmd_Npc.sm_npc_C;
				dict[CmdEnum.SM_NPC_D]=Cmd_Npc.sm_npc_D;
				dict[CmdEnum.SM_NPC_I]=Cmd_Npc.sm_npc_I;

				//坐骑
				dict[CmdEnum.SM_MOU_D]=Cmd_Mount.sm_mou_D;
				dict[CmdEnum.SM_MOU_E]=Cmd_Mount.sm_mou_E;
				dict[CmdEnum.SM_MOU_I]=Cmd_Mount.sm_mou_I;
				dict[CmdEnum.SM_MOU_R]=Cmd_Mount.sm_mou_R;
				dict[CmdEnum.SM_MOU_S]=Cmd_Mount.sm_mou_S;
				dict[CmdEnum.SM_MOU_Z]=Cmd_Mount.sm_mou_Z;
				dict[CmdEnum.SM_MOU_N]=Cmd_Mount.sm_mou_N;

				//翅膀
				dict[CmdEnum.SM_WIG_E]=Cmd_Wig.sm_Wig_E;
				dict[CmdEnum.SM_WIG_I]=Cmd_Wig.sm_Wig_I;
				dict[CmdEnum.SM_WIG_O]=Cmd_Wig.sm_Wig_O;
				dict[CmdEnum.SM_WIG_U]=Cmd_Wig.sm_Wig_U;
				dict[CmdEnum.SM_WIG_M]=Cmd_Wig.sm_Wig_M;
				dict[CmdEnum.SM_WIG_Z]=Cmd_Wig.sm_Wig_Z;
				dict[CmdEnum.SM_WIG_N]=Cmd_Wig.sm_Wig_N;
				dict[CmdEnum.SM_WIG_F]=Cmd_Wig.sm_Wig_F;

				//好友
				dict[CmdEnum.SM_FND_I]=Cmd_Friend.sm_FriendMsg_I;
				dict[CmdEnum.SM_FND_A]=Cmd_Friend.sm_FriendMsg_A;
				dict[CmdEnum.SM_FND_D]=Cmd_Friend.sm_FriendMsg_D;
				dict[CmdEnum.SM_FND_U]=Cmd_Friend.sm_FriendMsg_U;
				dict[CmdEnum.SM_FND_F]=Cmd_Friend.sm_FriendMsg_F;

				// 邮件
				dict[CmdEnum.SM_SMA_I]=Cmd_Mail.sm_MailMsg_I;
				dict[CmdEnum.SM_SMA_A]=Cmd_Mail.sm_MailMsg_A;
				dict[CmdEnum.SM_SMA_N]=Cmd_Mail.sm_MailMsg_N;
				dict[CmdEnum.SM_SMA_D]=Cmd_Mail.sm_MailMsg_D;
				dict[CmdEnum.SM_SMA_Z]=Cmd_Mail.sm_MailMsg_Z;

				//组队
				dict[CmdEnum.SM_TM_A]=Cmd_Tm.sm_tm_A;
				dict[CmdEnum.SM_TM_I]=Cmd_Tm.sm_tm_I;
				dict[CmdEnum.SM_TM_K]=Cmd_Tm.sm_tm_K;
				dict[CmdEnum.SM_TM_T]=Cmd_Tm.sm_tm_T;
				dict[CmdEnum.SM_TM_U]=Cmd_Tm.sm_tm_U;
				dict[CmdEnum.SM_TM_W]=Cmd_Tm.sm_tm_W;
				dict[CmdEnum.SM_TM_M]=Cmd_Tm.sm_tm_M;

				//装备
				dict[CmdEnum.SM_EQ_M]=Cmd_Equip.sm_Equip_M;
				dict[CmdEnum.SM_EQ_S]=Cmd_Equip.sm_Equip_S;
				dict[CmdEnum.SM_EQ_R]=Cmd_Equip.sm_Equip_R;
				dict[CmdEnum.SM_EQ_Z]=Cmd_Equip.sm_Equip_Z;
				dict[CmdEnum.SM_EQ_RL_S]=Cmd_Equip.sm_Equip_rl_S;
				dict[CmdEnum.SM_EQ_BR_I]=Cmd_Equip.sm_Equip_Break_I;
				dict[CmdEnum.SM_EQ_BR_L]=Cmd_Equip.sm_Equip_Break_L;
				dict[CmdEnum.SM_EQ_COD_L]=Cmd_Equip.sm_Equip_Compound_I;

				//帮会
				dict[CmdEnum.SM_GUILD_A]=Cmd_Guild.sm_Guild_A;
				dict[CmdEnum.SM_GUILD_I]=Cmd_Guild.sm_Guild_I;
				dict[CmdEnum.SM_GUILD_K]=Cmd_Guild.sm_Guild_K;
				dict[CmdEnum.SM_GUILD_L]=Cmd_Guild.sm_Guild_L;
				dict[CmdEnum.SM_GUILD_M]=Cmd_Guild.sm_Guild_M;
				dict[CmdEnum.SM_GUILD_N]=Cmd_Guild.sm_Guild_N;
				dict[CmdEnum.SM_GUILD_P]=Cmd_Guild.sm_Guild_P;
				dict[CmdEnum.SM_GUILD_S]=Cmd_Guild.sm_Guild_S;
				dict[CmdEnum.SM_GUILD_U]=Cmd_Guild.sm_Guild_U;
				dict[CmdEnum.SM_GUILD_W]=Cmd_Guild.sm_Guild_W;
				dict[CmdEnum.SM_GUILD_Q]=Cmd_Guild.sm_Guild_Q;
				dict[CmdEnum.SM_GUILD_F]=Cmd_Guild.sm_Guild_F;
				dict[CmdEnum.SM_GUILD_H]=Cmd_Guild.sm_Guild_H;
				dict[CmdEnum.SM_GUILD_J]=Cmd_Guild.sm_Guild_J;
				dict[CmdEnum.SM_GUILD_R]=Cmd_Guild.sm_Guild_R;

				//ucp
				dict[CmdEnum.SM_GUILD_COPY_I]=Cmd_Ucp.sm_GuildCp_I;
				dict[CmdEnum.SM_GUILD_COPY_T]=Cmd_Ucp.sm_GuildCp_T;
				dict[CmdEnum.SM_GUILD_COPY_R]=Cmd_Ucp.sm_GuildCp_R;
				dict[CmdEnum.SM_GUILD_COPY_O]=Cmd_Ucp.sm_GuildCp_O;

				//unw
				dict[CmdEnum.SM_GUILD_PK_L]=Cmd_Unw.sm_Guild_pk_L;
				dict[CmdEnum.SM_GUILD_PK_R]=Cmd_Unw.sm_Guild_pk_R;
				dict[CmdEnum.SM_GUILD_PK_S]=Cmd_Unw.sm_Guild_pk_S;
				dict[CmdEnum.SM_GUILD_PK_D]=Cmd_Unw.sm_Guild_pk_D;

				// 商城
				dict[CmdEnum.SM_MAK_I]=Cmd_Market.sm_Mak_I;
				dict[CmdEnum.SM_MAK_L]=Cmd_Market.sm_Mak_L;
				dict[CmdEnum.SM_MAK_A]=Cmd_Market.sm_Mak_A;
				dict[CmdEnum.SM_MAK_F]=Cmd_Market.sm_Mak_F;
				dict[CmdEnum.SM_MAK_W]=Cmd_Market.sm_Mak_W;
				
				// 积分
				dict[CmdEnum.SM_CLI_I]=Cmd_CLI.sm_CLI_I;
				dict[CmdEnum.SM_CLI_B]=Cmd_CLI.sm_CLI_B;
				
				// 连续充值
				dict[CmdEnum.SM_CCZ_I]=Cmd_CCZ.sm_CCZ_I;
				dict[CmdEnum.SM_CCZ_L]=Cmd_CCZ.sm_CCZ_L;
				dict[CmdEnum.SM_CCZ_C]=Cmd_CCZ.sm_CCZ_C;

				// 充值返利
				dict[CmdEnum.SM_FANL_I]=Cmd_Fanl.sm_Fanl_I;
				dict[CmdEnum.SM_FANL_J]=Cmd_Fanl.sm_Fanl_J;

				// 寄售
				dict[CmdEnum.SM_CGT_I]=Cmd_Aution.sm_Aution_I;
				dict[CmdEnum.SM_CGT_B]=Cmd_Aution.sm_Aution_B;
				dict[CmdEnum.SM_CGT_C]=Cmd_Aution.sm_Aution_C;
				dict[CmdEnum.SM_CGT_F]=Cmd_Aution.sm_Aution_F;
				dict[CmdEnum.SM_CGT_G]=Cmd_Aution.sm_Aution_G;
				dict[CmdEnum.SM_CGT_M]=Cmd_Aution.sm_Aution_M;
				dict[CmdEnum.SM_CGT_S]=Cmd_Aution.sm_Aution_S;
				dict[CmdEnum.SM_CGT_R]=Cmd_Aution.sm_Aution_R;
//				dict[CmdEnum.SM_CGT_D]=Cmd_Aution.sm_Aution_D;
				dict[CmdEnum.SM_CGT_L]=Cmd_Aution.sm_Aution_L;

				//cd
				dict[CmdEnum.SM_CD_I]=Cmd_CD.sm_cd_I;
				dict[CmdEnum.SM_CD_S]=Cmd_CD.sm_cd_S;

				//称号
				dict[CmdEnum.SM_NCK_I]=Cmd_Nck.sm_Nck_I;
				dict[CmdEnum.SM_NCK_S]=Cmd_Nck.sm_Nck_S;
				dict[CmdEnum.SM_NCK_U]=Cmd_Nck.sm_Nck_U;
				dict[CmdEnum.SM_NCK_G]=Cmd_Nck.sm_Nck_G;
				dict[CmdEnum.SM_NCK_T]=Cmd_Nck.sm_Nck_T;
				dict[CmdEnum.SM_NCK_N]=Cmd_Nck.sm_Nck_N;

				// 世界经验
				dict[CmdEnum.SM_WEXP_I]=Cmd_WExp.sm_WEXP_I;

				// 我要变强
				dict[CmdEnum.SM_RISE_I]=Cmd_TobeStrong.sm_RISE_I;

				// 挂机
				dict[CmdEnum.SM_ASS_I]=Cmd_Assist.sm_Ass_I;

				// PK模式
				dict[CmdEnum.SM_PKM_L]=Cmd_Pkm.sm_Pkm_L;
				dict[CmdEnum.SM_PKM_S]=Cmd_Pkm.sm_Pkm_S;

				// 功能开启
//				dict[CmdEnum.SM_MDO_I]=Cmd_MoldOpen.sm_MDO_I;
//				dict[CmdEnum.SM_MDO_O]=Cmd_MoldOpen.sm_MDO_O;

				// 农场
				dict[CmdEnum.SM_FAM_I]=Cmd_Farm.sm_FAM_I;
				dict[CmdEnum.SM_FAM_RS]=Cmd_Farm.sm_FAM_RS;
				dict[CmdEnum.SM_FAM_W]=Cmd_Farm.sm_FAM_W;
				dict[CmdEnum.SM_FAM_P]=Cmd_Farm.sm_FAM_P;
				dict[CmdEnum.SM_FAM_US]=Cmd_Farm.sm_FAM_US;
				dict[CmdEnum.SM_FAM_T]=Cmd_Farm.sm_FAM_T;
				dict[CmdEnum.SM_FAM_L]=Cmd_Farm.sm_FAM_L;
				dict[CmdEnum.SM_FAM_SN]=Cmd_Farm.sm_FAM_SN;
				dict[CmdEnum.SM_FAM_F]=Cmd_Farm.sm_FAM_F;
				dict[CmdEnum.SM_FAM_UT]=Cmd_Farm.sm_FAM_UT;

				//运镖
				dict[CmdEnum.SM_YCT_I]=Cmd_Yct.sm_Delivery_I;
				dict[CmdEnum.SM_YCT_K]=Cmd_Yct.sm_Delivery_K;
				dict[CmdEnum.SM_YCT_R]=Cmd_Yct.sm_Delivery_R;

				//防沉迷
				dict[CmdEnum.SM_FCM_I]=Cmd_Fcm.sm_Fcm_I;
				dict[CmdEnum.SM_FCM_S]=Cmd_Fcm.sm_Fcm_S;

				//竞技场
				dict[CmdEnum.SM_JJC_I]=Cmd_Arena.sm_Arena_I;
				dict[CmdEnum.SM_JJC_L]=Cmd_Arena.sm_Arena_L;
				dict[CmdEnum.SM_JJC_R]=Cmd_Arena.sm_Arena_R;
				dict[CmdEnum.SM_JJC_J]=Cmd_Arena.sm_Arena_J;
				dict[CmdEnum.SM_JJC_K]=Cmd_Arena.sm_Arena_K;
				dict[CmdEnum.SM_JJC_X]=Cmd_Arena.sm_Arena_X;

				// qqVIP奖励
				dict[CmdEnum.SM_TX_D]=Cmd_QQVip.sm_TX_D;
				dict[CmdEnum.SM_TX_N]=Cmd_QQVip.sm_TX_N;
				dict[CmdEnum.SM_TX_L]=Cmd_QQVip.sm_TX_L;
				dict[CmdEnum.SM_TX_B]=Cmd_QQVip.sm_TX_B;
				dict[CmdEnum.SM_TX_H]=Cmd_QQVip.sm_TX_H;
				dict[CmdEnum.SM_TX_R]=Cmd_QQVip.sm_TX_R;
				dict[CmdEnum.SM_TX_M]=Cmd_QQVip.sm_TX_M;

				// 收集
				dict[CmdEnum.SM_COL_I]=Cmd_Collection.sm_COL_I;
				dict[CmdEnum.SM_COL_G]=Cmd_Collection.sm_COL_G;

				// 副本
				dict[CmdEnum.SM_SCP_I]=Cmd_SCP.sm_SCP_I;
				dict[CmdEnum.SM_SCP_R]=Cmd_SCP.sm_SCP_R;
				dict[CmdEnum.SM_SCP_T]=Cmd_SCP.sm_SCP_T;
				dict[CmdEnum.SM_SCP_X]=Cmd_SCP.sm_SCP_X;
				dict[CmdEnum.SM_SCP_U]=Cmd_SCP.sm_SCP_U;
				
				// 主城争霸
				dict[CmdEnum.SM_WARC_I]=Cmd_WARC.sm_WARC_I;
				dict[CmdEnum.SM_WARC_T]=Cmd_WARC.sm_WARC_T;
				dict[CmdEnum.SM_WARC_J]=Cmd_WARC.sm_WARC_J;
				dict[CmdEnum.SM_WARC_M]=Cmd_WARC.sm_WARC_M;

				// 行会争霸
				dict[CmdEnum.SM_UNZ_I]=Cmd_GuildBattle.sm_UNZ_I;
				dict[CmdEnum.SM_UNZ_L]=Cmd_GuildBattle.sm_UNZ_L;
				dict[CmdEnum.SM_UNZ_N]=Cmd_GuildBattle.sm_UNZ_N;
				dict[CmdEnum.SM_UNZ_U]=Cmd_GuildBattle.sm_UNZ_U;
				
				// 团购
				dict[CmdEnum.SM_GBUY_I]=Cmd_GBUY.sm_GBUY_I;
				dict[CmdEnum.SM_GBUY_J]=Cmd_GBUY.sm_GBUY_J;
				dict[CmdEnum.SM_GBUY_B]=Cmd_GBUY.sm_GBUY_B;
				
				// 拍卖
				dict[CmdEnum.SM_PM_I]=Cmd_PM.sm_PM_I;
				dict[CmdEnum.SM_PM_F]=Cmd_PM.sm_PM_F;
				dict[CmdEnum.SM_PM_L]=Cmd_PM.sm_PM_L;

				// 巨龙宝藏
				dict[CmdEnum.SM_LBOX_I]=Cmd_LDW.sm_LDW_I;
				dict[CmdEnum.SM_LBOX_H]=Cmd_LDW.sm_LDW_H;
				dict[CmdEnum.SM_LBOX_D]=Cmd_LDW.sm_LDW_D;
				dict[CmdEnum.SM_LBOX_B]=Cmd_LDW.sm_LDW_B;
				dict[CmdEnum.SM_LBOX_U]=Cmd_LDW.sm_LDW_U;

				// 开服庆典
				dict[CmdEnum.SM_KF_I]=Cmd_KF.sm_KF_I;
				dict[CmdEnum.SM_KF_T]=Cmd_KF.sm_KF_T;
				dict[CmdEnum.SM_KF_R]=Cmd_KF.sm_KF_R;

				// BOSS副本
				dict[CmdEnum.SM_BCP_I]=Cmd_BCP.sm_BCP_I;
				dict[CmdEnum.SM_BCP_A]=Cmd_BCP.sm_BCP_A;
				dict[CmdEnum.SM_BCP_T]=Cmd_BCP.sm_BCP_T;
				dict[CmdEnum.SM_BCP_X]=Cmd_BCP.sm_BCP_X;
				dict[CmdEnum.SM_BCP_R]=Cmd_BCP.sm_BCP_R;

				// 七天任务
				dict[CmdEnum.SM_SEVD_D]=Cmd_Seven.sm_SEVD_D;
				dict[CmdEnum.SM_SEVD_I]=Cmd_Seven.sm_SEVD_I;
				dict[CmdEnum.SM_SEVD_R]=Cmd_Seven.sm_SEVD_R;
				dict[CmdEnum.SM_SEVD_T]=Cmd_Seven.sm_SEVD_T;

				// 野外BOSS
				dict[CmdEnum.SM_YBS_I]=Cmd_YBS.sm_YBS_I;
				dict[CmdEnum.SM_YBS_R]=Cmd_YBS.sm_YBS_R;
				dict[CmdEnum.SM_YBS_J]=Cmd_YBS.sm_YBS_J;
				dict[CmdEnum.SM_YBS_T]=Cmd_YBS.sm_YBS_T;
				dict[CmdEnum.SM_YBS_X]=Cmd_YBS.sm_YBS_X;
				dict[CmdEnum.SM_YBS_L]=Cmd_YBS.sm_YBS_L;

				//答题
				dict[CmdEnum.SM_QA_J]=Cmd_Qa.sm_Qa_J;
				dict[CmdEnum.SM_QA_Q]=Cmd_Qa.sm_Qa_Q;
				dict[CmdEnum.SM_QA_R]=Cmd_Qa.sm_Qa_R;
				dict[CmdEnum.SM_QA_E]=Cmd_Qa.sm_Qa_E;
				dict[CmdEnum.SM_QA_T]=Cmd_Qa.sm_Qa_T;
				dict[CmdEnum.SM_QA_X]=Cmd_Qa.sm_Qa_X;

				// 经验副本
				dict[CmdEnum.SM_EXPC_I]=Cmd_EXPC.sm_Exp_I;
				dict[CmdEnum.SM_EXPC_T]=Cmd_EXPC.sm_Exp_T;
				dict[CmdEnum.SM_EXPC_X]=Cmd_EXPC.sm_Exp_X;

				// 连斩
				dict[CmdEnum.SM_LZ_I]=Cmd_LZ.sm_LZ_I;

				//pkcoyp
				dict[CmdEnum.SM_ACT_I]=Cmd_Act.sm_Act_I;
				dict[CmdEnum.SM_ACT_A]=Cmd_Act.sm_Act_A;

				//ecp
				dict[CmdEnum.SM_ECP_T]=Cmd_Ecp.sm_Ecp_T;
				dict[CmdEnum.SM_ECP_X]=Cmd_Ecp.sm_Ecp_X;
				dict[CmdEnum.SM_ECP_R]=Cmd_Ecp.sm_Ecp_R;

				// 福利
				dict[CmdEnum.SM_SIGN_I]=Cmd_Welfare.sm_SIGN_I;
				dict[CmdEnum.SM_SIGN_Z]=Cmd_Welfare.sm_SIGN_Z;
				dict[CmdEnum.SM_OL_I]=Cmd_Welfare.sm_OL_I;
				dict[CmdEnum.SM_OL_J]=Cmd_Welfare.sm_OL_J;
				dict[CmdEnum.SM_ULV_I]=Cmd_Welfare.sm_ULV_I;
				dict[CmdEnum.SM_ULV_Z]=Cmd_Welfare.sm_ULV_Z;
				dict[CmdEnum.SM_OFL_I]=Cmd_Welfare.sm_OFL_I;

				// 在线累计奖励
				dict[CmdEnum.SM_ONL_I]=Cmd_ONL.sm_ONL_I;
				dict[CmdEnum.SM_ONL_X]=Cmd_ONL.sm_ONL_X;
				dict[CmdEnum.SM_ONL_Z]=Cmd_ONL.sm_ONL_Z;

				//恶魔入侵
				dict[CmdEnum.SM_WBS_I]=Cmd_Wbs.sm_Wbs_I;
				dict[CmdEnum.SM_WBS_J]=Cmd_Wbs.sm_Wbs_J;
				dict[CmdEnum.SM_WBS_X]=Cmd_Wbs.sm_Wbs_X;

				// 排行榜
				dict[CmdEnum.SM_RAK_I]=Cmd_Rank.sm_RAK_I;
				dict[CmdEnum.SM_RAK_A]=Cmd_Rank.sm_RAK_A;

				// 活跃度
				dict[CmdEnum.SM_HYD_I]=Cmd_Active.sm_HYD_I;
				dict[CmdEnum.SM_HYD_J]=Cmd_Active.sm_HYD_J;
				dict[CmdEnum.SM_HYD_Z]=Cmd_Active.sm_HYD_Z;

				//副本退出or进入
				dict[CmdEnum.SM_CPY_E]=Cmd_Cpy.sm_Cpy_E;
				dict[CmdEnum.SM_CPY_Q]=Cmd_Cpy.sm_Cpy_Q;

				// 指引
				dict[CmdEnum.SM_GUD_I]=Cmd_Guide.sm_GUD_I;
				dict[CmdEnum.SM_GUD_T]=Cmd_Guide.sm_GUD_T;
				dict[CmdEnum.SM_GUD_N]=Cmd_Guide.sm_GUD_N;

				// 决斗
				dict[CmdEnum.SM_DUEL_M]=Cmd_Duel.sm_DUEL_M;
				dict[CmdEnum.SM_DUEL_S]=Cmd_Duel.sm_DUEL_S;

				// 成就
				dict[CmdEnum.SM_HSY_I]=Cmd_Achievement.sm_HSY_I;
				dict[CmdEnum.SM_HSY_S]=Cmd_Achievement.sm_HSY_S;
				dict[CmdEnum.SM_HSY_R]=Cmd_Achievement.sm_HSY_R;
				dict[CmdEnum.SM_HSY_N]=Cmd_Achievement.sm_HSY_N;

				// 首冲返利
				dict[CmdEnum.SM_FCZ_I]=Cmd_FCZ.sm_FCZ_I;
				dict[CmdEnum.SM_FCZ_J]=Cmd_FCZ.sm_FCZ_J;
				dict[CmdEnum.SM_FCZ_A]=Cmd_FCZ.sm_FCZ_A;

				dict[CmdEnum.SM_CRANK_I]=Cmd_PayRank.sm_PayRank_I;
				dict[CmdEnum.SM_CRANK_A]=Cmd_PayRank.sm_PayRank_A

				// 投资理财
				dict[CmdEnum.SM_TZ_I]=Cmd_Invest.sm_TZ_I;
				dict[CmdEnum.SM_TZ_J]=Cmd_Invest.sm_TZ_J;
				dict[CmdEnum.SM_TZ_C]=Cmd_Invest.sm_TZ_C;
				dict[CmdEnum.SM_TZ_L]=Cmd_Invest.sm_TZ_L;
				dict[CmdEnum.SM_TZ_D]=Cmd_Invest.sm_TZ_D;

				// 城主膜拜
				dict[CmdEnum.SM_WSP_I]=Cmd_Worship.sm_WSP_I;

				// 引导计数
				dict[CmdEnum.SM_TCS_I]=Cmd_TCS.sm_TCS_I;

				// VIP
				dict[CmdEnum.SM_VIP_I]=Cmd_Vip.sm_VIP_I;
				dict[CmdEnum.SM_VIP_U]=Cmd_Vip.sm_VIP_U;
				dict[CmdEnum.SM_VIP_J]=Cmd_Vip.sm_VIP_J;
				dict[CmdEnum.SM_VIP_L]=Cmd_Vip.sm_VIP_L;

				//天天首充
				dict[CmdEnum.SM_DDSC_I]=Cmd_ddsc.sm_Ddsc_I;

				//龙穴探宝
				dict[CmdEnum.SM_WBOX_I]=Cmd_Wbox.sm_Wbox_I;

				//保卫部雷特
				dict[CmdEnum.SM_BLT_I]=Cmd_Blt.sm_Blt_I;

				//宝石
				dict[CmdEnum.SM_GEM_I]=Cmd_Gem.sm_Gem_I;
				dict[CmdEnum.SM_GEM_H]=Cmd_Gem.sm_Gem_H;

				//time
				dict[CmdEnum.SM_STIME_I]=Cmd_Stime.sm_stime_I

				//组队副本
				dict[CmdEnum.SM_TEAM_COPY_I]=Cmd_CpTm.sm_TeamCopy_I;
				dict[CmdEnum.SM_TEAM_COPY_M]=Cmd_CpTm.sm_TeamCopy_M;
				dict[CmdEnum.SM_TEAM_COPY_T]=Cmd_CpTm.sm_TeamCopy_T;
				dict[CmdEnum.SM_TEAM_COPY_E]=Cmd_CpTm.sm_TeamCopy_E;
				dict[CmdEnum.SM_TEAM_COPY_S]=Cmd_CpTm.sm_TeamCopy_S;
				dict[CmdEnum.SM_TEAM_COPY_G]=Cmd_CpTm.sm_TeamCopy_G;
			}
		}

		public static function executeCmd(cmd:String, data:Object):void {

			var fun:Function=dict[cmd];
			if (fun == null) {
				NetGate.DEBUG && trace("☆☆☆☆☆☆☆ 【警告！暂时还没有该类[" + cmd + "]" + data + "】 ☆☆☆☆☆☆☆");
				return;
			}

			trace("收到协议【[" + cmd + "]" + data + "】");

			fun(data);
		}


	}
}
