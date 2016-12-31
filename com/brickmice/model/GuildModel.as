package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class GuildModel
	{	
		
		public function guildList(page:int, name:String, callBack:Function) : void
		{
			var obj : Object = {"action":"guildList", "args":{page:page, name:name}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function guildDetail(id : int, callBack:Function) : void
		{
			var obj : Object = {"action":"guildDetail", "args":{"id" : id}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function guildInfo(id : int, callBack:Function) : void
		{
			var obj : Object = {"action":"guildInfo", "args":{"id" : id}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function createGuild(name:String, verify:int, qq:String, claim:String, callBack:Function) : void
		{
			var obj : Object = {"action":"createGuild", "args":{verify:verify, name:name, qq:qq, claim:claim}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function guildSetting(id:int, verify:int, qq:String, claim:String, callBack:Function) : void
		{
			var obj : Object = {"action":"guildSetting", "args":{verify:verify, id:id, qq:qq, claim:claim}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function applyGuild(id : int) : void
		{
			var obj : Object = {"action":"applyGuild", "args":{"id" : id}};
			GameService.request([obj]);
		}
		
		public function agreeGuildApply(id : int, uid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"agreeGuildApply", "args":{"id" : id, "uid":uid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function rejectGuildApply(id : int, uid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"rejectGuildApply", "args":{"id" : id, "uid":uid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}	
		
		public function guildLeaderChange(id : int, uid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"guildLeaderChange", "args":{"id" : id, "uid":uid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}	
		
		public function kickGuild(id : int, uid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"kickGuild", "args":{"id" : id, "uid":uid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}	
		
		public function quitGuild(id : int, callBack:Function) : void
		{
			var obj : Object = {"action":"quitGuild", "args":{"id" : id}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function disbandGuild(id : int, callBack:Function) : void
		{
			var obj : Object = {"action":"disbandGuild", "args":{"id" : id}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
	}
}
