package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.arena.Arena;
	import com.brickmice.view.boss.Boss;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	
	public class ArenaController
	{
		public function showArena():void
		{
			if (!ViewManager.hasView(Arena.NAME))
			{
				ModelManager.arenaModel.getArenaData(function():void
				{	
					ResourceLoader.loadRes([Consts.resourceDic["arena"]], function():void{
						var data:WindowData = new WindowData(Arena);
						ControllerManager.windowController.showWindow(data);
					}); 
				});
			}else{
				(ViewManager.retrieveView(Arena.NAME) as Arena).closeWindow();
			}
		}
		
		public function showBoss():void
		{
			if (!ViewManager.hasView(Boss.NAME))
			{
				ModelManager.bossModel.getBossData(function():void
				{	
					ResourceLoader.loadRes([Consts.resourceDic["boss"]], function():void{
						var data:WindowData = new WindowData(Boss);
						ControllerManager.windowController.showWindow(data);
					});
				});
			}else{
				(ViewManager.retrieveView(Boss.NAME) as Arena).closeWindow();
			}
		}
	}
}
