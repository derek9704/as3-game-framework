package com.brickmice.view.rank
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Data;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author derek
	 */
	public class RankGuildItem extends Sprite
	{
		private var _mc:ResRankGuildItem;

		public function RankGuildItem(info : Object)
		{
			_mc = new ResRankGuildItem;
			addChild(_mc);
			_mc.mouseEnabled = _mc.mouseChildren = false;
			
			var preStr:String = '';
			var nextStr:String = '';
			if(info.id == Data.data.guild.id){
				preStr = '<font color="#ff0000">';
				nextStr = '</font>';
			}
			_mc._rank.htmlText = info.rank;
			_mc._campLogo.gotoAndStop(int(info.union) == 1 ? 1 : 2);
			_mc._guildName.htmlText = preStr + info.name + nextStr;
			_mc._guildLvl.htmlText = preStr + info.level + nextStr;
			_mc._guildManager.htmlText = preStr + info.leader + nextStr;
			_mc._memberNumber.htmlText = preStr + info.memberCount + nextStr;
			
			this.addEventListener(MouseEvent.CLICK, function():void{
				ControllerManager.guildController.showOtherGuildInfo(info.id);
			});
		}

	}
}
