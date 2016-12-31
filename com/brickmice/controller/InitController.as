package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.data.tcp.Tcp;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.layer.UiLayer;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.CTip;
	import com.framework.utils.TipHelper;
	
	import flash.system.System;

	/**
	 * 初始化逻辑
	 *
	 * @author derek
	 */
	public class InitController
	{
		public function initApp():void
		{
			// 初始化公用层
			Main.self.initLayers();

			// 初始化tip类
			TipHelper.mouseOver = function(tip:CTip):void
			{
				ControllerManager.tipController.showTip(tip);
			};

			TipHelper.mouseOut = function(tip:CTip):void
			{
				ControllerManager.tipController.hideTip(tip);
			};

			// 读取配置文件
			ResourceLoader.loadXml('config.xml?ver=' + Math.random(), function(xml:XML):void
			{
				var debug:Boolean = xml.debug.toString() == 'true';

				// 设置值
				Consts.debug = debug;

				// 设置加载资源地址字典
				for each (var info:* in xml.resource)
				{
					var tempStr:String = "swf/" + info.url.toString() + ".swf?ver=" + info.ver.toString();

					Consts.resourceDic[info.url.toString()] = tempStr;
				}
				for each (var info2:* in xml.pkResource)
				{
					var tempStr2:String = "swf/pk/" + info2.url.toString() + ".swf?ver=" + info2.ver.toString();
					
					Consts.resourceDic[info2.url.toString()] = tempStr2;
				}

				// 释放
				System.disposeXML(xml);

				/*************** 进入游戏*************/
				// 隐藏所有ui
				Main.self.uiLayer.headVisible = UiLayer.HIDE;

				// 去服务器获取数据.进行初始化程序
				ModelManager.userModel.initUser(enterGame);
			});
		}
		
		public function enterGame():void
		{
			// 获取服务器配置
			Consts.chatServer = Data.data.system.socketIp;
			Consts.chatPort = Data.data.system.socketPort;
			Consts.siteURL = Data.data.system.siteUrl;
			if(Data.data.system.socketIp == 'miao00.com'){
				Consts.isGreen = true;
			}
			// 获取服务器和本地时间差距
			var serverDate : int = Data.data.system.timeNow;
			var nowData:int = Math.floor((new Date).getTime() * 0.001);
			Consts.timeGap = serverDate - nowData;
			// 显示ui
			Main.self.uiLayer.visible = true;
			Main.self.uiLayer.headVisible = UiLayer.ALL;
			// 显示月球城
			ControllerManager.cityController.enterCity();
			// 开始心跳
			Consts.heartBool = true;
			ModelManager.userModel.startHeartbeat();
			// 连接聊天TCP 
			Tcp.getInstance().Connect(Consts.chatServer, Consts.chatPort);
//			Tcp.getInstance().Connect('192.168.0.107', 7000);
			//音乐按钮
			ViewManager.sendMessage(ViewMessage.SET_MUSIC, Data.data.user.musicOn == 1);
			//刷新经验条
			ViewManager.sendMessage(ViewMessage.REFRESH_EXPBAR);
			//刷新资源
			ViewManager.sendMessage(ViewMessage.REFRESH_MATERIAL);
			//刷新每日登陆奖励
			if(Data.data.user.logonReward.name){
				ViewManager.sendMessage(ViewMessage.REFRESH_DAILYLOGONREWARD);
			}
			//首冲奖励
			ViewManager.sendMessage(ViewMessage.REFRESH_SHOUCHONGREWARD);
		}
	}
}
