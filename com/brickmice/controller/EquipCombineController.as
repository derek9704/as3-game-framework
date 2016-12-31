package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.equipcombine.EquipCombine;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;

	public class EquipCombineController
	{
		
		public function showEquipCombine():void
		{
			if (!ViewManager.hasView(EquipCombine.NAME))
			{
				ResourceLoader.loadRes([Consts.resourceDic["equipCombine"]], function():void{
					var data:WindowData = new WindowData(EquipCombine);
					ControllerManager.windowController.showWindow(data);
				}); 
			}else{
				(ViewManager.retrieveView(EquipCombine.NAME) as EquipCombine).closeWindow();
			}
		}
		
	}
}
