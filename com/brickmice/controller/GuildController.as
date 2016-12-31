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
	import com.brickmice.view.guild.Guild;
	import com.brickmice.view.guild.GuildList;
	import com.brickmice.view.guild.GuildListDetail;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;

	public class GuildController
	{
		
		public function showGuild(type:String = "task"):void
		{
			if (!ViewManager.hasView(Guild.NAME) && !ViewManager.hasView(GuildList.NAME))
			{
				ResourceLoader.loadRes([Consts.resourceDic["guild"]], function():void{
					var data:WindowData;
					if(Data.data.guild && Data.data.guild.id){
						ModelManager.guildModel.guildInfo(Data.data.guild.id, function():void{
							data = new WindowData(Guild, {"type" : type});
							ControllerManager.windowController.showWindow(data);	
						});
					}else{
						ModelManager.guildModel.guildList(1, '', function():void{
							data = new WindowData(GuildList);
							ControllerManager.windowController.showWindow(data);	
						});
					}
				}); 
			}else{
				if (ViewManager.hasView(Guild.NAME)) (ViewManager.retrieveView(Guild.NAME) as Guild).closeWindow();
				if (ViewManager.hasView(GuildList.NAME)) (ViewManager.retrieveView(GuildList.NAME) as GuildList).closeWindow();
			}
		}
		
		public function showOtherGuildInfo(id:int):void
		{
			ModelManager.guildModel.guildDetail(id, function():void{
				ResourceLoader.loadRes([Consts.resourceDic["guild"]], function():void{
					var win:BmWindow = new GuildListDetail();
					var windowLayer:WindowLayer = Main.self.windowLayer;
					windowLayer.addChildCenter(win);	
				});
			});
		}
		
	}
}