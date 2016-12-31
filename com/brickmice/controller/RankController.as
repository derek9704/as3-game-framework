package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.rank.Rank;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;

	public class RankController
	{
		
		public function showRank():void
		{
			if (!ViewManager.hasView(Rank.NAME))
			{
				ModelManager.rankModel.getMyRankData(1, function():void
				{
					ResourceLoader.loadRes([Consts.resourceDic["rank"]], function():void{
						var data:WindowData = new WindowData(Rank);
						ControllerManager.windowController.showWindow(data);
					}); 
				}); 
			}else{
				(ViewManager.retrieveView(Rank.NAME) as Rank).closeWindow();
			}
		}
		
	}
}
