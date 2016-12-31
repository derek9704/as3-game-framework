package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.planet.Planet;
	import com.brickmice.view.planet.WarAlarm;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;

	public class WarAlarmController
	{
		
		public function showWarAlarm():void
		{
			if (!ViewManager.hasView(WarAlarm.NAME))
			{
				ModelManager.warModel.getWarAlarmData(function():void
				{	
					//预警和星球公用一个FLA
					if (!ViewManager.hasView(Planet.NAME))
					{
						ResourceLoader.loadRes([Consts.resourceDic["planet"]], showWarAlarmWin); 
					}
					else
					{
						showWarAlarmWin();
					}
				});
			}else{
				(ViewManager.retrieveView(WarAlarm.NAME) as WarAlarm).closeWindow();
			}
		}
		
		private function showWarAlarmWin():void
		{
			var data:WindowData = new WindowData(WarAlarm);
			ControllerManager.windowController.showWindow(data);
		}
		
	}
}
