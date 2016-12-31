package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.layer.WindowLayer;
	import com.brickmice.view.userinfo.OtherUserInfo;
	import com.brickmice.view.userinfo.UserInfo;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	
	public class UserInfoController
	{
		public function showUserInfo():void
		{
			if (!ViewManager.hasView(UserInfo.NAME))
			{
				ResourceLoader.loadRes([Consts.resourceDic["userInfo"]], function():void{
					var data:WindowData = new WindowData(UserInfo);
					ControllerManager.windowController.showWindow(data);
				}); 
			}else{
				(ViewManager.retrieveView(UserInfo.NAME) as UserInfo).setData();
			}
		}
		
		public function showOtherUserInfo(id:int):void
		{
			ModelManager.userModel.getOtherUserData(id, function():void{
				ResourceLoader.loadRes([Consts.resourceDic["userInfo"]], function():void{
					var win:BmWindow = new OtherUserInfo();
					var windowLayer:WindowLayer = Main.self.windowLayer;
					windowLayer.addChildCenter(win);	
				}); 
			});
		}
	}
}
