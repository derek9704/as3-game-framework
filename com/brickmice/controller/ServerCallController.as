package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.Main;
	import com.brickmice.data.Consts;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.frame.TaskFinishPanel;
	import com.brickmice.view.component.layer.WindowLayer;
	import com.brickmice.view.component.prompt.ConfirmMessage;
	import com.brickmice.view.component.prompt.NoticeMessage;
	import com.brickmice.view.component.prompt.TextMessage;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * 统一处理服务器CALL，进行命令分发
	 * @author derek
	 */
	public class ServerCallController
	{
		public function execute(cmd:String, data:* = null):void
		{
			switch(cmd)
			{
				case "enterGame":	//进入游戏
				{
					ControllerManager.initController.enterGame();
					break;
				}
				case "pageJump"://掉线
				{
					// 关闭心跳
					Consts.heartBool = false;
					//弹出提示
					var callback:Function = function():void{
						navigateToURL(new URLRequest(Consts.siteURL), "_top");
					};
					var data2:Object = {msg:data, title:'系统提示', callback:callback};
					ControllerManager.windowController.showWindow(new WindowData(NoticeMessage, data2, true, 0, 0, 0, false));
					break;
				}
				case "errorMsg":	//负面提示
				{
					TextMessage.showEffect(data, 2);
					break;
				}
				case "correctMsg":	//正面提示
				{
					TextMessage.showEffect(data, 1);
					break;
				}				
				case "yahuanMsg":	//丫鬟提示
				{
					ControllerManager.yahuanController.showYahuan(data.msg, data.from);
					break;
				}
				case "confirmMsg": //弹出确认框（带确认、取消按钮）
				{
					data.server = true; //标记server端回调
					ControllerManager.windowController.showWindow(new WindowData(ConfirmMessage, data, true, 0, 0, 0, false));
					break;
				}
				case "noticeMsg": //弹出提示框(带确认按钮)
				{
					ControllerManager.windowController.showWindow(new WindowData(NoticeMessage, data, false, 0, 0, 0, false));
					break;
				}
				case "newMail": //新邮件提示
				{
					ViewManager.sendMessage(ViewMessage.NEW_MAIL);
					break;
				}
				case "refreshPlanet": //刷新星球归属
				{
					ViewManager.sendMessage(ViewMessage.UPDATE_PLANET, data);
					break;
				}
				case "refreshStock": //刷新股市
				{
					ViewManager.sendMessage(ViewMessage.UPDATE_STOCK, data);
					break;
				}
				case "heroLevelUpAnim": //员工升级动画
				{
					ViewManager.sendMessage(ViewMessage.HERO_LEVELUP, data);
					break;
				}
				case "discoveryAnim": //探索动画
				{
					ViewManager.sendMessage(ViewMessage.GOT_DISCOVERY, data);
					break;
				}
				case "finishTask": //任务完成
				{
					var win:BmWindow = new TaskFinishPanel(data);
					var windowLayer:WindowLayer = Main.self.windowLayer;
					windowLayer.addChildCenter(win);
					break;
				}
				default:
				{
					break;
				}
			}
		}
	}
}
