package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.mine.Mine;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	
	public class MineController
	{
		public function showMine(type:String):void
		{
			if (!ViewManager.hasView(Mine.NAME))
			{
				ResourceLoader.loadRes([Consts.resourceDic["mine"]], function():void{
					var data:WindowData = new WindowData(Mine, {"type" : type});
					ControllerManager.windowController.showWindow(data);
				}); 
			}else{
				(ViewManager.retrieveView(Mine.NAME) as Mine).setData(type);
			}
		}
	}
}
