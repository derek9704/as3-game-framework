package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.battle.Battle;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	
	public class BattleController
	{
		public function showBattle(info:Object):void
		{
			if (!ViewManager.hasView(Battle.NAME))
			{
				var data:WindowData = new WindowData(Battle, info, true, 0, 0, 0, false);
				ControllerManager.windowController.showWindow(data);
			}
		}
	}
}