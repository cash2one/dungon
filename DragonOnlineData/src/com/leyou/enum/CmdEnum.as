package com.leyou.enum {

	public class CmdEnum {

		/**
		 * 命名规则
		 * 		变量：?m_模块_2级指令 大写
		 * 		    值：模块_2级指令	必须全部小写，否则报错
		 */

		//登陆、创建角色
		public static const SM_1017:String="1017";
		public static const SM_SID:String="sid";
		public static const SM_COV_N:String="cov_n";
		public static const SM_COV_E:String="cov_e";
		public static const SM_COV_P:String="cov_p";
		public static const SM_COV_L:String="cov_l";
		public static const CM_COV_U:String="cov|U";
		public static const CM_COV_C:String="cov|C";
		public static const CM_ULOGI_I:String="ulogi|I";
		
		public static const SM_ALOGIN_A:String="alogin_a";

		//
		public static const SYS_CLK:String="clk"; //心跳o

		//场景
		public static const SM_CUE:String="cue"; //服务器关闭
		public static const CM_QUIT:String="quit"; //退出游戏
		public static const SM_GAM:String="gam"; //进入游戏
		public static const SM_R:String="r"; //下发场景信息
		public static const SM_A:String="a"; //附加形象
		public static const SM_D:String="d"; //删除场景内人物
		public static const SM_P:String="p"; //换装
		public static const SM_3000:String="3000"; //其他玩家、怪物、npc
		public static const SM_3001:String="3001"; //自己
		public static const SM_3002:String="3002"; //行走：服务器
		public static const CM_3003:int=0x3003; //矫正人物位置
		public static const SM_3003:String="3003"; //矫正人物位置
		public static const SM_3005:String="3005"; //传送
		public static const CM_TAG:String="tag"; //地图加载完毕
		public static const CM_R:String="R"; //地图加载完毕
		public static const CM_3002:int=0x3002; //行走：客户端
		public static const CM_SIT_S:String="sit|S"; //打坐
		public static const CM_SIT_O:String="sit|O"; //取消打坐
		public static const SM_SIT_S:String="sit_s"; //打坐时信息
		public static const SM_3004:String="3004"; //镖车进入进出
		public static const SM_UST_U:String="ust_u"; //人物状态改变
		public static const SM_NTK_I:String="ntk_i"; //boss说话
		public static const SM_3021:String="3021"; //CD清零
		public static const SM_3022:String="3022"; //清理子弹
		public static const CM_TX:String="tx|I"; //腾讯
		
		public static const SM_SINFO_I:String="sinfo_i";//服务器和服信息
		
		//道具
		public static const SM_DROP_A:String="3018";
		public static const SM_DROP_D:String="3019";
		public static const CM_DROP:String="drp|P";
		public static const SM_DROP_S:String="drp_s";
		public static const SM_DROP_F:String="drp_f";

		//战斗
		public static const SM_3010:String="3010"; //技能：服务器
		public static const SM_3011:String="3011"; //伤害
		public static const SM_3012:String="3012"; //同步血、蓝值
		public static const SM_3013:String="3013"; //同步buff
		public static const CM_BFT_I:String="bft|I"; //请求更新buff数据
		public static const SM_BFT_I:String="bft_i"; //请求更新buff数据
		public static const SM_3014:String="3014"; //眩晕
		public static const SM_3015:String="3015"; //同步速度
		public static const SM_3016:String="3016"; //同步子弹（个别）
		public static const SM_3017:String="3017"; //删除子弹（）
		public static const SM_3020:String="3020"; //更改名字颜色
		public static const CM_3010:int=0x3010; //技能：客户端
		public static const SM_3023:String="3023"; //被动技能

		// 死亡复活
		public static const SM_REV:String="rev_i"; //死亡通知
		public static const CM_REV:String="rev|R"; //复活
		public static const SM_REV_R:String="rev_r"; //复活成功
		public static const CM_REV_B:String="rev|B";
		public static const SM_REV_B:String="rev_b";

		//背包
		public static const SM_BAG_L:String="bag_l";
		public static const SM_BAG_G:String="bag_g";
		public static const SM_BAG_J:String="bag_j";
		public static const SM_BAG_X:String="bag_x";
		public static const SM_BAG_U:String="bag_u";
		public static const SM_BAG_D:String="bag_d";
		public static const SM_BAG_Q:String="bag_q";
		public static const SM_BAG_N:String="bag_n";
		public static const SM_BAG_Z:String="bag_z";

		//属性变化
		public static const SM_SYNP:String="synp_s";

		public static const SYSTEM_NOTICE_MSG:String="msg";
		public static const CHAT_SAY:String="say";
		public static const ROLE_ATT_ME:String="att_m";
		public static const ROLE_ATT_OTHER:String="att_o"
		public static const EQUIP_EQP_ME:String="eqp_m";
		public static const EQUIP_EQP_OTHER:String="eqp_o";
		public static const EQUIP_EQP_DROP:String="eqp_d";

		public static const SM_ELEMENT_ELE_S:String="ele_s";
		public static const SM_ELEMENT_ELE_L:String="ele_l";
		public static const SM_ELEMENT_ELE_C:String="ele_c";
		public static const SM_ELEMENT_ELE_M:String="ele_m";
		public static const SM_ELEMENT_ELE_Z:String="ele_z";

		//技能
		public static const SM_SKL_I:String="skl_i";
		public static const SM_SKL_A:String="skl_a";
		public static const SM_SKL_R:String="skl_r";
		public static const SM_SKL_C:String="skl_c";
		public static const SM_SKL_L:String="skl_l";
		public static const CM_SKL_U:String="skl|U";

		//血脉
		public static const SM_BLD_O:String="bld_o";
		public static const SM_BLD_P:String="bld_p";
		public static const SM_BLD_W:String="bld_w";
		public static const SM_BLD_L:String="bld_l";
		/****************************====================================================================================**********************/

		//快捷键
		public static const SM_LINK_I:String="link_i";
		public static const SM_LINK_S:String="link_s";
		public static const SM_LINK_C:String="link_c";

		//商店
		public static const SM_SHP_I:String="shp_i";
		public static const SM_SHP_O:String="shp_o";
		public static const SM_SHP_N:String="shp_n";

		//任务
		public static const SM_TSK_A:String="tsk_a";
		public static const SM_TSK_D:String="tsk_d";
		public static const SM_TSK_T:String="tsk_t";

		//寻路
		public static const SM_GO_P:String="go_p";
		public static const SM_GO_G:String="go_g";
		public static const SM_GO_V:String="go_v";
		public static const SM_GO_C:String="go_c";

		//npc
		public static const SM_NPC_C:String="npc_c";
		public static const SM_NPC_D:String="npc_d";
		public static const SM_NPC_I:String="npc_i";

		//坐骑
		public static const SM_MOU_S:String="mou_s";
		public static const SM_MOU_D:String="mou_d";
		public static const SM_MOU_I:String="mou_i";
		public static const SM_MOU_R:String="mou_r";
		public static const SM_MOU_E:String="mou_e";
		public static const SM_MOU_Z:String="mou_z";
		public static const SM_MOU_N:String="mou_n";

		//翅膀
		public static const SM_WIG_I:String="wig_i";
		public static const SM_WIG_U:String="wig_u";
		public static const SM_WIG_O:String="wig_o";
		public static const SM_WIG_E:String="wig_e";
		public static const SM_WIG_M:String="wig_m";
		public static const SM_WIG_Z:String="wig_z";
		public static const SM_WIG_N:String="wig_n";
		public static const SM_WIG_F:String="wig_f";
		
		// 副本排行
		public static const SM_CPRAK_I:String="cprak_i";
		public static const CM_CPRAK_I:String="cprak|I";

		//好友
		public static const SM_FND_I:String="fnd_i";
		public static const CM_FND_I:String="fnd|I";
		public static const SM_FND_A:String="fnd_a";
		public static const CM_FND_A:String="fnd|A";
		public static const SM_FND_D:String="fnd_d";
		public static const CM_FND_D:String="fnd|D";
		public static const SM_FND_U:String="fnd_u";
		public static const CM_FND_U:String="fnd|U";
		public static const SM_FND_F:String="fnd_f";
		public static const CM_FND_F:String="fnd|F";

		// 邮件
		public static const SM_SMA_I:String="sma_i";
		public static const CM_SMA_I:String="sma|I";
		public static const SM_SMA_A:String="sma_a";
		public static const CM_SMA_A:String="sma|A";
		public static const SM_SMA_N:String="sma_n";
		public static const CM_SMA_R:String="sma|R";
		public static const SM_SMA_D:String="sma_d";
		public static const CM_SMA_D:String="sma|D";
		public static const SM_SMA_Z:String="sma_z";

		//组队
		public static const SM_TM_I:String="tm_i";
		public static const SM_TM_G:String="tm_g";
		public static const SM_TM_Q:String="tm_q";
		public static const SM_TM_T:String="tm_t";
		public static const SM_TM_U:String="tm_u";
		public static const SM_TM_K:String="tm_k";
		public static const SM_TM_C:String="tm_c";
		public static const SM_TM_A:String="tm_a";
		public static const SM_TM_W:String="tm_w";
		public static const SM_TM_P:String="tm_p";
		public static const SM_TM_M:String="tm_m";

		//装备强化
		public static const SM_EQ_R:String="rec_r";
		public static const SM_EQ_M:String="stg_m";
		public static const SM_EQ_S:String="stg_s";
		public static const SM_EQ_Z:String="stg_z";
		public static const SM_EQ_RL_S:String="smelt_s";
		public static const SM_EQ_BR_I:String="smelt_i";
		public static const SM_EQ_BR_L:String="smelt_l";
		public static const SM_EQ_COD_L:String="hc_i";

		//帮派
		public static const SM_GUILD_L:String="un_l";
		public static const SM_GUILD_U:String="un_u";
		public static const SM_GUILD_I:String="un_i";
		public static const SM_GUILD_P:String="un_p";
		public static const SM_GUILD_M:String="un_m";
		public static const SM_GUILD_N:String="un_n";
		public static const SM_GUILD_A:String="un_a";
		public static const SM_GUILD_W:String="un_w";
		public static const SM_GUILD_K:String="un_k";
		public static const SM_GUILD_S:String="un_s";
		public static const SM_GUILD_Q:String="un_q";
		public static const SM_GUILD_F:String="un_f";
		public static const SM_GUILD_H:String="un_h";
		public static const SM_GUILD_J:String="un_j";
		public static const CM_GUILD_R:String="un|R";
		public static const SM_GUILD_R:String="un_r";


		//行会副本
		public static const CM_GUILD_COPY_I:String="ucp|I";
		public static const SM_GUILD_COPY_I:String="ucp_i";
		public static const CM_GUILD_COPY_T:String="ucp|T";
		public static const SM_GUILD_COPY_T:String="ucp_t";
		public static const SM_GUILD_COPY_R:String="ucp_r";
		public static const CM_GUILD_COPY_E:String="ucp|E";
		public static const CM_GUILD_COPY_L:String="ucp|L";
		public static const SM_GUILD_COPY_O:String="ucp_o";

		//行会科技
		public static const CM_GUILD_BLESS_I:String="unb|I";
		public static const CM_GUILD_BLESS_Q:String="unb|Q";
		public static const CM_GUILD_BLESS_D:String="unb|D";
		public static const CM_GUILD_BLESS_B:String="unb|B";
		public static const CM_GUILD_BLESS_C:String="unb|C";
		public static const CM_GUILD_BLESS_U:String="unb|U";
		public static const SM_GUILD_BLESS_I:String="unb_i";

		//行会战争
		public static const SM_GUILD_PK_S:String="unw_s";
		public static const CM_GUILD_PK_R:String="unw|R";
		public static const SM_GUILD_PK_R:String="unw_r";
		public static const SM_GUILD_PK_L:String="unw_l";
		public static const CM_GUILD_PK_W:String="unw|W";
		public static const CM_GUILD_PK_I:String="unw|I";
		public static const SM_GUILD_PK_D:String="unw_d";
		public static const CM_GUILD_PK_M:String="unw|M";

		//cd
		public static const SM_CD_I:String="cd_i";
		public static const SM_CD_S:String="cd_s";

		// 商城
		public static const SM_MAK_I:String="mak_i";
		public static const CM_MAK_I:String="mak|I";
		public static const SM_MAK_L:String="mak_l";
		public static const CM_MAK_L:String="mak|L";
		public static const SM_MAK_A:String="mak_a";
		public static const CM_MAK_A:String="mak|A";
		public static const CM_MAK_B:String="mak|B";
		public static const SM_MAK_F:String="mak_f";
		public static const CM_MAK_F:String="mak|F";
		public static const SM_MAK_W:String="mak_w";
		public static const CM_MAK_W:String="mak|W";
		public static const CM_MAK_G:String="mak|G";

		// QQVip奖励
		public static const CM_TX_N:String="tx|N";
		public static const SM_TX_N:String="tx_n";
		public static const CM_TX_J:String="tx|J";
		public static const CM_TX_D:String="tx|D";
		public static const SM_TX_D:String="tx_d";
		public static const CM_TX_X:String="tx|X";
		public static const CM_TX_L:String="tx|L";
		public static const SM_TX_L:String="tx_l";
		public static const CM_TX_Y:String="tx|Y";
		public static const CM_TX_B:String="tx|B";
		public static const SM_TX_B:String="tx_b";
		public static const CM_TX_H:String="tx|H";
		public static const SM_TX_H:String="tx_h";
		public static const SM_TX_R:String="tx_r";
		public static const SM_TX_M:String="tx_m";

		// 收集
		public static const CM_COL_I:String="col|I";
		public static const SM_COL_I:String="col_i";
		public static const CM_COL_G:String="col|G";
		public static const SM_COL_G:String="col_g";
		public static const CM_COL_T:String="col|T";
		
		// 积分
		public static const SM_CLI_I:String="cli_i";
		public static const CM_CLI_I:String="cli|I";
		public static const SM_CLI_B:String="cli_b";
		public static const CM_CLI_B:String="cli|B";
		
		// 连续充值
		public static const SM_CCZ_I:String="ccz_i";
		public static const CM_CCZ_I:String="ccz|I";
		public static const SM_CCZ_L:String="ccz_l";
		public static const CM_CCZ_L:String="ccz|L";
		public static const SM_CCZ_C:String="ccz_c";
		public static const CM_CCZ_C:String="ccz|C";

		// 和服连冲
		public static const SM_HCCZ_I:String="hccz_i";
		public static const CM_HCCZ_I:String="hccz|I";
		public static const SM_HCCZ_C:String="hccz_c";
		public static const CM_HCCZ_C:String="hccz|C";

		// 寄售
		public static const SM_CGT_I:String="cgt_i";
		public static const CM_CGT_I:String="cgt|I";
		public static const SM_CGT_S:String="cgt_s";
		public static const CM_CGT_S:String="cgt|S";
		public static const SM_CGT_C:String="cgt_c";
		public static const CM_CGT_C:String="cgt|C";
		public static const SM_CGT_B:String="cgt_b";
		public static const CM_CGT_B:String="cgt|B";
		public static const SM_CGT_F:String="cgt_f";
		public static const CM_CGT_F:String="cgt|F";
		public static const SM_CGT_G:String="cgt_g";
		public static const CM_CGT_G:String="cgt|G";
		public static const SM_CGT_M:String="cgt_m";
		public static const CM_CGT_M:String="cgt|M";
		public static const SM_CGT_R:String="cgt_r";
		public static const CM_CGT_R:String="cgt|R";
//		public static const SM_CGT_D:String="cgt_d";
		public static const CM_CGT_L:String="cgt|L";
		public static const SM_CGT_L:String="cgt_l";

		//称号
		public static const SM_NCK_S:String="nck_s";
		public static const SM_NCK_I:String="nck_i";
		public static const SM_NCK_U:String="nck_u";
		public static const SM_NCK_G:String="nck_g";
		public static const SM_NCK_T:String="nck_t";
		public static const SM_NCK_N:String="nck_n";
		public static const SM_NCK_D:String="nck_d";

		// 挂机配置
		public static const SM_ASS_I:String="ass_i";
		public static const CM_ASS_I:String="ass|I";
		public static const CM_ASS_S:String="ass|S";

		// PK模式
		public static const SM_PKM_L:String="pkm_l";
		public static const SM_PKM_S:String="pkm_s";
		public static const CM_PKM_S:String="pkm|S";

		// 功能开启
		public static const SM_MDO_I:String="mdo_i";
		public static const SM_MDO_O:String="mdo_o";

		// 农场
		public static const SM_FAM_I:String="fam_i";
		public static const CM_FAM_I:String="fam|I";
		public static const SM_FAM_RS:String="fam_rs";
		public static const CM_FAM_O:String="fam|O";
		public static const CM_FAM_U:String="fam|U";
		public static const SM_FAM_F:String="fam_f";
		public static const CM_FAM_F:String="fam|F";
		public static const CM_FAM_G:String="fam|G";
		public static const CM_FAM_S:String="fam|S";
		public static const CM_FAM_C:String="fam|C";
		public static const CM_FAM_H:String="fam|H";
		public static const SM_FAM_W:String="fam_w";
		public static const CM_FAM_W:String="fam|W";
		public static const SM_FAM_WF:String="fam_wf";
		public static const CM_FAM_WF:String="fam|WF";
		public static const CM_FAM_R:String="fam|R";
		public static const SM_FAM_SL:String="fam_sl";
		public static const CM_FAM_SL:String="fam|SL";
		public static const SM_FAM_T:String="fam_t";
		public static const SM_FAM_L:String="fam_l";
		public static const CM_FAM_L:String="fam|L";
		public static const CM_FAM_A:String="fam|A";
		public static const SM_FAM_P:String="fam_p";
		public static const CM_FAM_P:String="fam|P";
		public static const SM_FAM_SN:String="fam_sn"
		public static const SM_FAM_US:String="fam_us";
		public static const SM_FAM_UT:String="fam_ut";

		//押镖
		public static const CM_YCT_I:String="yct|I";
		public static const SM_YCT_I:String="yct_i";
		public static const CM_YCT_S:String="yct|S";
		public static const CM_YCT_T:String="yct|T";
		public static const CM_YCT_F:String="yct|F";
		public static const CM_YCT_C:String="yct|C";
		public static const CM_YCT_J:String="yct|J";
		public static const CM_YCT_Q:String="yct|Q";
		public static const SM_YCT_R:String="yct_r";
		public static const SM_YCT_K:String="yct_k";

		//防沉迷
		public static const SM_FCM_I:String="fcm_i";
		public static const SM_FCM_S:String="fcm_s";

		//竞技场
		public static const CM_JJC_I:String="jjc|I";
		public static const SM_JJC_I:String="jjc_i";
		public static const CM_JJC_L:String="jjc|L";
		public static const CM_JJC_C:String="jjc|C";
		public static const CM_JJC_F:String="jjc|F";
		public static const CM_JJC_Z:String="jjc|Z";
		public static const CM_JJC_W:String="jjc|W";
		public static const CM_JJC_T:String="jjc|T";
		public static const CM_JJC_R:String="jjc|R";
		public static const CM_JJC_A:String="jjc|A";
		public static const CM_JJC_Q:String="jjc|Q";
		public static const SM_JJC_R:String="jjc_r";
		public static const SM_JJC_L:String="jjc_l";
		public static const SM_JJC_J:String="jjc_j";
		public static const SM_JJC_K:String="jjc_k";
		public static const SM_JJC_X:String="jjc_x";

		// 副本
		public static const SM_SCP_I:String="scp_i";
		public static const SM_SCP_E:String="scp_e";
		public static const SM_SCP_T:String="scp_t";
		public static const SM_SCP_X:String="scp_x";
		public static const SM_SCP_U:String="scp_u";
		public static const SM_SCP_R:String="scp_r";
		public static const CM_SCP_I:String="scp|I";
		public static const CM_SCP_E:String="scp|E";
		public static const CM_SCP_L:String="scp|L";
		public static const CM_SCP_A:String="scp|A";
		public static const CM_SCP_R:String="scp|R";
		public static const CM_SCP_J:String="scp|J";
		public static const CM_SCP_C:String="scp|C"

		// BOSS副本
		public static const SM_BCP_I:String="bcp_i";
		public static const SM_BCP_R:String="bcp_r";
		public static const SM_BCP_A:String="bcp_a";
		public static const SM_BCP_T:String="bcp_t";
		public static const SM_BCP_X:String="bcp_x";
		public static const CM_BCP_I:String="bcp|I";
		public static const CM_BCP_E:String="bcp|E";
		public static const CM_BCP_A:String="bcp|A";
		public static const CM_BCP_B:String="bcp|B";
		public static const CM_BCP_L:String="bcp|L";

		// 充值排行
		public static const SM_CRANK_I:String="crak_i";
		public static const CM_CRANK_I:String="crak|I";
		public static const SM_CRANK_A:String="crak_a";

		// 开服庆典
		public static const SM_KF_T:String="kf_t";
		public static const SM_KF_I:String="kf_i";
		public static const CM_KF_I:String="kf|I";
		public static const SM_KF_R:String="kf_r";
		public static const CM_KF_R:String="kf|R";

		// 野外BOSS
		public static const SM_YBS_I:String="ybs_i";
		public static const CM_YBS_I:String="ybs|I";
		public static const SM_YBS_R:String="ybs_r";
		public static const CM_YBS_R:String="ybs|R";
		public static const SM_YBS_J:String="ybs_j";
		public static const SM_YBS_T:String="ybs_t";
		public static const SM_YBS_X:String="ybs_x";
		public static const SM_YBS_L:String="ybs_l";
		public static const CM_YBS_L:String="ybs|L";
		
		// 龙珠
		public static const SM_LONGZ_I:String="longz_i";
		public static const CM_LONGZ_I:String="longz|I";
//		public static const CM_LONGZ_F:String="longz|F";
		public static const SM_LONGZ_W:String="longz_w";
		public static const CM_LONGZ_W:String="longz|W";
		public static const SM_LONGZ_C:String="longz_c";
		public static const CM_LONGZ_C:String="longz|C";
		public static const CM_LONGZ_E:String="longz|E";
		public static const CM_LONGZ_L:String="longz|L";
		public static const SM_LONGZ_T:String="longz_t";
		public static const CM_LONGZ_D:String="longz|D";
		public static const SM_LONGZ_D:String="longz_d";
		public static const CM_LONGZ_A:String="longz|A";
		public static const SM_LONGZ_A:String="longz_a";
		public static const CM_LONGZ_H:String="longz|H";
		public static const SM_LONGZ_H:String="longz_h";
		public static const CM_LONGZ_P:String="longz|P";
		public static const SM_LONGZ_P:String="longz_p";
		public static const CM_LONGZ_Z:String="longz|Z";
		
		// 道具抽奖
		public static const SM_ITU_L:String="itu_l";
		
		// 霜炎战场
		public static const SM_ZC_L:String="zc_l";
		public static const CM_ZC_L:String="zc|L";
		public static const SM_ZC_U:String="zc_u";
		public static const SM_ZC_C:String="zc_c";
		public static const SM_ZC_N:String="zc_n";
		public static const CM_ZC_E:String="zc|E";
		public static const CM_ZC_Q:String="zc|Q";
		public static const CM_ZC_B:String="zc|B";
		public static const SM_ZC_B:String="zc_b";
		public static const CM_ZC_I:String="zc|I";
		public static const SM_ZC_I:String="zc_i";
		public static const CM_ZC_H:String="zc|H";
		public static const SM_ZC_H:String="zc_h";

		//答题
		public static const CM_QA_E:String="qa|E";
		public static const CM_QA_X:String="qa|X";
		public static const SM_QA_E:String="qa_e";
		public static const SM_QA_X:String="qa_x";
		public static const SM_QA_T:String="qa_t";
		public static const SM_QA_R:String="qa_r";
		public static const SM_QA_J:String="qa_j";
		public static const SM_QA_Q:String="qa_q";

		// 经验副本
		public static const SM_EXPC_I:String="expc_i";
		public static const SM_EXPC_T:String="expc_t";
		public static const SM_EXPC_X:String="expc_x";
		public static const CM_EXPC_I:String="expc|I";
		public static const CM_EXPC_E:String="expc|E";
		public static const CM_EXPC_B:String="expc|B";
		public static const CM_EXPC_L:String="expc|L";

		//连斩
		public static const CM_LZ_J:String="lz|J";
		public static const SM_LZ_I:String="lz_i";

		//pkCopy
		public static const SM_ACT_I:String="act_i";
		public static const CM_ACT_G:String="act|G";
		public static const CM_ACT_C:String="act|C";
		public static const SM_ACT_A:String="act_a";
		public static const CM_ACT_I:String="act|I";

		//福利
		public static const CM_SIGN_I:String="sign|I";
		public static const CM_SIGN_S:String="sign|S";
		public static const CM_SIGN_J:String="sign|J";
		public static const CM_SIGN_V:String="sign|V";
		public static const SM_SIGN_I:String="sign_i";
		public static const SM_SIGN_Z:String="sign_z";
		public static const SM_OL_I:String="ol_i";
		public static const CM_OL_I:String="ol|I";
		public static const SM_OL_J:String="ol_j";
		public static const CM_OL_J:String="ol|J";
		public static const SM_ULV_I:String="ulv_i";
		public static const CM_ULV_I:String="ulv|I";
		public static const CM_ULV_J:String="ulv|J";
		public static const SM_ULV_Z:String="ulv_z";
		public static const CM_CDK_J:String="cdk|J";
		public static const SM_OFL_I:String="ofl_i";
		public static const CM_OFL_I:String="ofl|I";
		public static const CM_OFL_L:String="ofl|L";

		//ecp
		public static const SM_ECP_T:String="ecp_t";
		public static const SM_ECP_X:String="ecp_x";
		public static const SM_ECP_R:String="ecp_r";
		public static const CM_ECP_L:String="ecp|L";

		//wbs
		public static const SM_WBS_I:String="wbs_i";
		public static const SM_WBS_X:String="wbs_x";
		public static const SM_WBS_J:String="wbs_j";
		public static const CM_WBS_Q:String="wbs|Q";
		public static const CM_WBS_B:String="wbs|B";

		//在线累计奖励 
		public static const SM_ONL_I:String="ot_i";
		public static const SM_ONL_X:String="ot_x";
		public static const SM_ONL_Z:String="ot_z";
		public static const CM_ONL_J:String="ot|J";

		//副本进入or退出
		public static const SM_CPY_E:String="cpy_e";
		public static const SM_CPY_Q:String="cpy_q";

		// 排行榜
		public static const SM_RAK_I:String="rak_i";
		public static const CM_RAK_I:String="rak|I";
		public static const SM_RAK_A:String="rak_a";
		public static const CM_RAK_A:String="rak|A";
		public static const SM_RAK_Y:String="rak_y";
		public static const CM_RAK_Y:String="rak|Y";
		public static const SM_RAK_C:String="rak_c";
		public static const CM_RAK_C:String="rak|C";

		// 活跃度
		public static const SM_HYD_I:String="hyd_i";
		public static const CM_HYD_I:String="hyd|I";
		public static const SM_HYD_J:String="hyd_j";
		public static const CM_HYD_J:String="hyd|J";
		public static const SM_HYD_Z:String="hyd_z";

		// 指引
		public static const SM_GUD_I:String="gud_i";
		public static const CM_GUD_F:String="gud|F";
		public static const SM_GUD_T:String="gud_t";
		public static const SM_GUD_N:String="gud_n";

		// 成就
		public static const CM_HSY_S:String="hsy|S";
		public static const SM_HSY_S:String="hsy_s";
		public static const CM_HSY_I:String="hsy|I";
		public static const SM_HSY_I:String="hsy_i";
		public static const CM_HSY_R:String="hsy|R";
		public static const SM_HSY_R:String="hsy_r";
		public static const SM_HSY_N:String="hsy_n";

		// VIP
		public static const SM_VIP_I:String="vip_i";
		public static const SM_VIP_U:String="vip_u";
		public static const CM_VIP_I:String="vip|I";
		public static const CM_VIP_J:String="vip|J";
		public static const SM_VIP_J:String="vip_j";
		public static const SM_VIP_L:String="vip_l";
		public static const CM_VIP_S:String="vip|S";

		// 世界经验
		public static const SM_WEXP_I:String="wexp_i";

		// 我要变强
		public static const SM_RISE_I:String="rise_i";
		public static const CM_RISE_I:String="rise|I";

		// 聊天
		public static const SM_CHAT_S:String="say_s";

		// 膜拜
		public static const SM_WSP_I:String="wsp_i";
		public static const CM_WSP_I:String="wsp|I";
		public static const CM_WSP_M:String="wsp|M";

		// 七天任务
		public static const SM_SEVD_I:String="sevd_i";
		public static const CM_SEVD_I:String="sevd|I";
		public static const SM_SEVD_T:String="sevd_t";
		public static const SM_SEVD_D:String="sevd_d";
		public static const CM_SEVD_D:String="sevd|D";
		public static const SM_SEVD_R:String="sevd_r";
		public static const CM_SEVD_R:String="sevd|R";

		// 决斗
		public static const CM_DUEL_T:String="duel|T";
		public static const CM_DUEL_R:String="duel|R";
		public static const CM_DUEL_L:String="duel|L";
		public static const SM_DUEL_M:String="duel_m";
		public static const SM_DUEL_S:String="duel_s";

		// 投资理财
		public static const SM_TZ_I:String="tz_i";
		public static const CM_TZ_I:String="tz|I";
		public static const SM_TZ_J:String="tz_j";
		public static const CM_TZ_J:String="tz|J";
		public static const CM_TZ_T:String="tz|T";
		public static const SM_TZ_L:String="tz_l";
		public static const SM_TZ_C:String="tz_c";
		public static const CM_TZ_C:String="tz|C";
		public static const CM_TZ_Z:String="tz|Z";
		public static const CM_TZ_D:String="tz|D";
		public static const SM_TZ_D:String="tz_d";

		// 行会争霸
		public static const SM_UNZ_I:String="unz_i";
		public static const CM_UNZ_I:String="unz|I";
		public static const SM_UNZ_L:String="unz_l";
		public static const CM_UNZ_L:String="unz|L";
		public static const SM_UNZ_U:String="unz_u";
		public static const CM_UNZ_U:String="unz|U";
		public static const SM_UNZ_N:String="unz_n";
		public static const CM_UNZ_E:String="unz|E";
		public static const CM_UNZ_Q:String="unz|Q";

		// 首冲返利
		public static const SM_FCZ_I:String="fcz_i";
		public static const CM_FCZ_I:String="fcz|I";
		public static const SM_FCZ_J:String="fcz_j";
		public static const CM_FCZ_J:String="fcz|J";
		public static const SM_FCZ_A:String="fcz_a";
		
		// 黑市
		public static const SM_BMAK_A:String="bmak_a";
		public static const CM_BMAK_A:String="bmak|A";
		public static const SM_BMAK_I:String="bmak_i";
		public static const CM_BMAK_I:String="bmak|I";
		public static const SM_BMAK_B:String="bmak_b";
		public static const CM_BMAK_B:String="bmak|B";
		public static const CM_BMAK_F:String="bmak|F";
		
		// 超级返利
		public static const SM_SFCZ_A:String="sfcz_a";

		// 抽奖
		public static const SM_LBOX_I:String="lbox_i";
		public static const CM_LBOX_I:String="lbox|I";
		public static const SM_LBOX_D:String="lbox_d";
		public static const CM_LBOX_D:String="lbox|D";
		public static const CM_LBOX_J:String="lbox|J";
		public static const SM_LBOX_H:String="lbox_h";
		public static const CM_LBOX_H:String="lbox|H";
		public static const SM_LBOX_B:String="lbox_b";
		public static const CM_LBOX_B:String="lbox|B";
		public static const CM_LBOX_Z:String="lbox|Z";
		public static const CM_LBOX_T:String="lbox|T";
		public static const CM_LBOX_V:String="lbox|V";
		public static const SM_LBOX_U:String="lbox_u";
		
		// 团购
		public static const SM_GBUY_I:String="gbuy_i";
		public static const CM_GBUY_I:String="gbuy|I";
		public static const CM_GBUY_B:String="gbuy|B";
		public static const SM_GBUY_B:String="gbuy_b";
		public static const CM_GBUY_J:String="gbuy|J";
		public static const SM_GBUY_J:String="gbuy_j";
		
		// 主城争霸
		public static const SM_WARC_I:String="warc_i";
		public static const CM_WARC_I:String="warc|I";
		public static const CM_WARC_N:String="warc|N";
		public static const CM_WARC_E:String="warc|E";
		public static const CM_WARC_Q:String="warc|Q";
		public static const CM_WARC_C:String="warc|C";
		public static const SM_WARC_T:String="warc_t";
		public static const SM_WARC_J:String="warc_j";
		public static const CM_WARC_D:String="warc|D";
		public static const CM_WARC_Z:String="warc|Z";
		public static const CM_WARC_B:String="warc|B";
		public static const CM_WARC_M:String="warc|M";
		public static const SM_WARC_M:String="warc_m";
		public static const CM_WARC_S:String="warc|S";
		
		// 神器锻造
		public static const SM_SQ_M:String="sq_m";
		public static const CM_SQ_M:String="sq|M";
		
		// 宠物
		public static const SM_PET_L:String="pet_l";
		public static const CM_PET_L:String="pet|L";
		public static const SM_PET_I:String="pet_i";
		public static const CM_PET_I:String="pet|I";
		public static const SM_PET_E:String="pet_e";
		public static const CM_PET_E:String="pet|E";
		public static const SM_PET_C:String="pet_c";
		public static const CM_PET_C:String="pet|C";
		public static const SM_PET_B:String="pet_b";
		public static const CM_PET_B:String="pet|B";
		public static const SM_PET_T:String="pet_t";
		public static const CM_PET_T:String="pet|T";
		public static const CM_PET_A:String="pet|A";
		public static const CM_PET_D:String="pet|D";
		public static const CM_PET_U:String="pet|U";
		public static const CM_PET_S:String="pet|S";
		public static const CM_PET_F:String="pet|F";
		public static const SM_PET_K:String="pet_k";
		public static const CM_PET_K:String="pet|K";
		public static const SM_PET_G:String="pet_g";
		public static const CM_PET_G:String="pet|G";
		
		// 任务集市
		public static const SM_YD_I:String="yd_i";
		public static const CM_YD_I:String="yd|I";
		public static const SM_YD_L:String="yd_l";
		public static const CM_YD_L:String="yd|L";
		public static const SM_YD_J:String="yd_j";
		public static const CM_YD_J:String="yd|J";
		public static const SM_YD_T:String="yd_t";
		public static const CM_YD_T:String="yd|T";
		
		// 拍卖
		public static const SM_PM_I:String="pm_i";
		public static const CM_PM_I:String="pm|I";
		public static const SM_PM_F:String="pm_f";
		public static const CM_PM_F:String="pm|F";
		public static const SM_PM_L:String="pm_l";
		public static const CM_PM_L:String="pm|L";
		public static const CM_PM_P:String="pm|P";
		

		// 充值返利
		public static const SM_FANL_I:String="fanl_i";
		public static const CM_FANL_I:String="fanl|I";
		public static const SM_FANL_J:String="fanl_j";
		public static const CM_FANL_J:String="fanl|J";
		public static const SM_FANL_D:String="fanl_d";
		public static const CM_FANL_D:String="fanl|D";
		public static const CM_FANL_A:String="fanl|A";
		public static const CM_FANL_B:String="fanl|B";

		// 引导计数
		public static const SM_TCS_I:String="tcs_i";

		//天天首充
		public static const SM_DDSC_I:String="ddsc_i";
		public static const CM_DDSC_I:String="ddsc|I";
		public static const CM_DDSC_J:String="ddsc|J";
//		public static const CM_DDSC_F:String="ddsc|F";

		//龙穴探宝
		public static const SM_WBOX_I:String="wbox_i";
		public static const CM_WBOX_I:String="wbox|I";
		public static const CM_WBOX_L:String="wbox|L";

		//保卫布伦特
		public static const SM_BLT_I:String="blt_i";
		public static const CM_BLT_I:String="blt|I";
		public static const CM_BLT_L:String="blt|L";

		//宝石
		public static const SM_GEM_I:String="gem_i";
		public static const CM_GEM_I:String="gem|I";
		public static const CM_GEM_O:String="gem|O";
		public static const SM_GEM_H:String="gem_h";
		public static const CM_GEM_H:String="gem|H";
		public static const CM_GEM_X:String="gem|X";
		public static const CM_GEM_Z:String="gem|Z";
		
		//炼金
		public static const CM_LJ_H:String="lj|H";
		public static const SM_LJ_H:String="lj_h";
	 

		//time
		public static const SM_STIME_I:String="stime_i";

		//组队副本
		public static const CM_TEAM_COPY_I:String="cptm|I";
		public static const SM_TEAM_COPY_I:String="cptm_i";
		public static const CM_TEAM_COPY_T:String="cptm|T";
		public static const SM_TEAM_COPY_T:String="cptm_t";
		public static const CM_TEAM_COPY_M:String="cptm|M";
		public static const SM_TEAM_COPY_M:String="cptm_m";
		public static const CM_TEAM_COPY_C:String="cptm|C";
		public static const CM_TEAM_COPY_Z:String="cptm|Z";
		public static const CM_TEAM_COPY_J:String="cptm|J";
		public static const CM_TEAM_COPY_Q:String="cptm|Q";
		public static const CM_TEAM_COPY_K:String="cptm|K";
		public static const CM_TEAM_COPY_E:String="cptm|E";
		public static const SM_TEAM_COPY_E:String="cptm_e";
		public static const CM_TEAM_COPY_L:String="cptm|L";
		public static const CM_TEAM_COPY_A:String="cptm|A";
		public static const SM_TEAM_COPY_S:String="cptm_s";
		public static const SM_TEAM_COPY_G:String="cptm_g";
		public static const CM_TEAM_COPY_F:String="cptm|F";
		
		//七日奖励
		public static const CM_DAY7_I:String="lday|I";
		public static const SM_DAY7_I:String="lday_i";
		public static const SM_DAY7_J:String="lday_j";
		public static const CM_DAY7_J:String="lday|J";
		
		//通天塔
		public static const SM_TTT_T:String="bbt_t";
		public static const CM_TTT_K:String="bbt|K";
		public static const CM_TTT_I:String="bbt|I";
		public static const SM_TTT_I:String="bbt_i";
		public static const CM_TTT_U:String="bbt|U";
		public static const SM_TTT_U:String="bbt_u";
		public static const SM_TTT_R:String="bbt_r";
		public static const CM_TTT_E:String="bbt|E";
		public static const CM_TTT_L:String="bbt|L";
		public static const CM_TTT_F:String="bbt|F";
		
		//拉霸
		public static const CM_LABA_I:String="laba|I";
		public static const SM_LABA_I:String="laba_i";
		public static const CM_LABA_H:String="laba|H";
		public static const SM_LABA_H:String="laba_h";
		public static const CM_LABA_D:String="laba|D";
		public static const SM_LABA_D:String="laba_d";
		public static const CM_LABA_J:String="laba|J";
		
		//结婚
		public static const CM_MARRY_I:String="marry|I";
		public static const SM_MARRY_I:String="marry_i";
		public static const CM_MARRY_R:String="marry|R";
		public static const SM_MARRY_R:String="marry_r";
		public static const CM_MARRY_Y:String="marry|Y";
		public static const SM_MARRY_Y:String="marry_y";
		public static const CM_MARRY_P:String="marry|P";
		public static const SM_MARRY_P:String="marry_p";
		public static const CM_MARRY_U:String="marry|U";
		public static const CM_MARRY_C:String="marry|C";
		public static const CM_MARRY_J:String="marry|J";
		public static const CM_MARRY_L:String="marry|L";
		
		/**
		 *背包
		 */
		public static const CMD_BAG_TYPE_BAG:int=1;

		/**
		 * 仓库
		 */
		public static const CMD_BAG_TYPE_STOREGE:int=2

		/**
		 * 人物装备
		 */
		public static const CMD_BAG_TYPE_ROLE_EQUIP:int=3;

		/**
		 * 任务
		 */
		public static const CMD_BAG_TYPE_TASK:int=6;

		//public static const CMD_BAG_TYPE_CARD:int=1;
		//public static const CMD_BAG_TYPE_STOREGE:int=2



	}
}
