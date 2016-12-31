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
	
	public class PlanetController
	{
		public function showPlanet(pid:int):void
		{
			ModelManager.planetModel.getPlanetData(pid, function():void
			{	
				if (!ViewManager.hasView(Planet.NAME))
				{
					//预警和星球公用一个FLA
					if (!ViewManager.hasView(WarAlarm.NAME))
					{
						ResourceLoader.loadRes([Consts.resourceDic["planet"]], function():void{
							showPlanetWin(pid);
						}); 
					}
					else
					{
						showPlanetWin(pid);
					}
				}else{
					(ViewManager.retrieveView(Planet.NAME) as Planet).setData(pid);
				}
			});
		}
		
		private function showPlanetWin(pid:int):void
		{
			var data:WindowData = new WindowData(Planet, {"pid" : pid});
			ControllerManager.windowController.showWindow(data);
		}
		
		
	}
}
