package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.activity.Activity;
	import com.brickmice.view.activity.Guaji;
	import com.brickmice.view.activity.Notice;
	import com.brickmice.view.activity.ShouChong;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;

	public class ActivityController
	{
		
		public function showActivity():void
		{
			if (!ViewManager.hasView(Activity.NAME))
			{
				ModelManager.activityModel.getActivityData(function():void
				{
					ResourceLoader.loadRes([Consts.resourceDic["activity"]], function():void{
						var data:WindowData = new WindowData(Activity);
						ControllerManager.windowController.showWindow(data);
					}); 
				});
			}else{
				(ViewManager.retrieveView(Activity.NAME) as Activity).closeWindow();
			}
		}
		
		public function showShouChong():void
		{
			if (!ViewManager.hasView(ShouChong.NAME))
			{
				ModelManager.activityModel.getShouChongData(function():void
				{
					ResourceLoader.loadRes([Consts.resourceDic["shop"]], function():void{
						var data:WindowData = new WindowData(ShouChong);
						ControllerManager.windowController.showWindow(data);
					}); 
				});
			}else{
				(ViewManager.retrieveView(ShouChong.NAME) as ShouChong).closeWindow();
			}
		}
		
		public function showNotice():void
		{
			if (!ViewManager.hasView(Notice.NAME))
			{
				ModelManager.activityModel.getNotice(function():void
				{
					var data:WindowData = new WindowData(Notice);
					ControllerManager.windowController.showWindow(data);
				});
			}else{
				(ViewManager.retrieveView(Notice.NAME) as Notice).closeWindow();
			}
		}
		
		public function showGuaji():void
		{
			if (!ViewManager.hasView(Guaji.NAME))
			{
				ResourceLoader.loadRes([Consts.resourceDic["chuchai"]], function():void{
					var data:WindowData = new WindowData(Guaji, null, true);
					ControllerManager.windowController.showWindow(data);
				}); 
			}else{
				(ViewManager.retrieveView(Guaji.NAME) as Guaji).closeWindow();
			}
		}
	}
}
