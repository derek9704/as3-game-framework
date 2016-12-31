package com.brickmice.controller
{
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.component.layer.UiLayer;
	import com.brickmice.view.world.WorldScene;

	/**
	 * 银河相关逻辑处理
	 *
	 * @author derek
	 */
	public class WorldController
	{
		public function enterWorld():void
		{
			ResourceLoader.loadRes([Consts.resourceDic["world"]], function():void{
				// 获取城市场景
				var worldScene:WorldScene = new WorldScene();
				// 变更场景
				Main.self.changeScene(worldScene, UiLayer.ALL);
			});	
		}
	}
}
