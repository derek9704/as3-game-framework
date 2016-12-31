package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.layer.WindowLayer;
	import com.brickmice.view.component.prompt.TextMessage;
	import com.brickmice.view.girlhero.GirlHero;
	import com.brickmice.view.girlhero.OtherGirlHero;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;

	/**
	 * 口袋相关逻辑
	 * 
	 * @author derek
	 */
	public class GirlHeroController
	{
		
		public function showGirlHero():void
		{
			if (!ViewManager.hasView(GirlHero.NAME))
			{
				var data:Object = Data.data.girlHero;
				var heroArr:Array = [];
				for each(var k:Object in data) heroArr.push(k);
				if(heroArr.length == 0){
					TextMessage.showEffect("你还没有招募科学美人", 2);
					return;
				}
				ResourceLoader.loadRes([Consts.resourceDic["girlHero"]], function():void{
					var data:WindowData = new WindowData(GirlHero);
					ControllerManager.windowController.showWindow(data);
				}); 
			}else{
				(ViewManager.retrieveView(GirlHero.NAME) as GirlHero).closeWindow();
			}
		}
		
		public function showOtherGirlHero(id:int):void
		{
			ModelManager.girlHeroModel.girlHeroInfo(id, function():void{
				ResourceLoader.loadRes([Consts.resourceDic["girlHero"]], function():void{
					var win:BmWindow = new OtherGirlHero();
					var windowLayer:WindowLayer = Main.self.windowLayer;
					windowLayer.addChildCenter(win);	
				});
			});
		}
		
	}
}
