package com.brickmice.controller
{
	import com.brickmice.Main;
	import com.brickmice.view.component.layer.UiLayer;
	import com.brickmice.view.city.CityScene;

	/**
	 * 城市相关逻辑处理
	 *
	 * @author derek
	 */
	public class CityController
	{
		public function enterCity():void
		{
			// 获取城市场景
			var cityScene:CityScene = new CityScene();
			// 变更场景
			Main.self.changeScene(cityScene, UiLayer.ALL);
		}
	}
}
