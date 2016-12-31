package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.boyhero.BoyHero;
	import com.brickmice.view.boyhero.OtherBoyHero;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.layer.WindowLayer;
	import com.brickmice.view.component.prompt.TextMessage;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;

	/**
	 * 口袋相关逻辑
	 * 
	 * @author derek
	 */
	public class BoyHeroController
	{
		
		public function showBoyHero():void
		{
			if (!ViewManager.hasView(BoyHero.NAME))
			{
				var data:Object = Data.data.boyHero;
				var heroArr:Array = [];
				for each(var k:Object in data) heroArr.push(k);
				if(heroArr.length == 0){
					TextMessage.showEffect("你还没有招募噩梦鼠", 2);
					return;
				}
				ResourceLoader.loadRes([Consts.resourceDic["boyHero"]], function():void{
					var data:WindowData = new WindowData(BoyHero);
					ControllerManager.windowController.showWindow(data);
				}); 
			}else{
				(ViewManager.retrieveView(BoyHero.NAME) as BoyHero).closeWindow();
			}
		}
		
		public function showOtherBoyHero(id:int):void
		{
			ModelManager.boyHeroModel.boyHeroInfo(id, function():void{
				ResourceLoader.loadRes([Consts.resourceDic["boyHero"]], function():void{
					var win:BmWindow = new OtherBoyHero();
					var windowLayer:WindowLayer = Main.self.windowLayer;
					windowLayer.addChildCenter(win);	
				});
			});
		}
		
	}
}