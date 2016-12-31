package com.brickmice.controller
{
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.component.layer.UiLayer;
	import com.brickmice.view.solar.SolarScene;

	public class SolarController
	{
		
		public function showSolar():void
		{
			ModelManager.solarModel.getSolarData(0, function():void
			{	
				// 获取场景
				var solarScene:SolarScene = new SolarScene();
				// 变更场景
				Main.self.changeScene(solarScene, UiLayer.HIDE);
			});
		}
		
	}
}
