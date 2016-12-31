package com.brickmice.controller
{
	import com.brickmice.Main;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.component.layer.UiLayer;
	import com.brickmice.view.research.ResearchScene;

	public class ResearchController
	{
		
		public function showResearch():void
		{
			ResourceLoader.loadRes([Consts.resourceDic["research"]], function():void{
				var girls:Array = Data.data.institute.research.girls;
				var loadResArr:Array = [Consts.resourceDic["enemy1001"]]; //BOSS现在默认只有一个
				for each (var hid:int in girls) 
				{
					var img:String = Data.data.girlHero[hid].img;
					loadResArr.push(Consts.resourceDic[img]);
				}
				//加载PK资源
				ResourceLoader.loadRes(loadResArr, function():void{
					// 获取场景
					var researchScene:ResearchScene = new ResearchScene();
					// 变更场景
					Main.self.changeScene(researchScene, UiLayer.HIDE);
				});
			});
		}
		
	}
}
