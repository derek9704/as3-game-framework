package com.brickmice.view.rank
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Data;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author derek
	 */
	public class RankTechItem extends Sprite
	{
		private var _mc:ResRankTechItem;

		public function RankTechItem(info : Object)
		{
			_mc = new ResRankTechItem;
			addChild(_mc);
			_mc.mouseEnabled = _mc.mouseChildren = false;
			
			var preStr:String = '';
			var nextStr:String = '';
			if(info.id == Data.data.user.id){
				preStr = '<font color="#ff0000">';
				nextStr = '</font>';
			}
			_mc._rank.htmlText = info.rank;
			_mc._campLogo.gotoAndStop(int(info.unionid) == 1 ? 1 : 2);
			_mc._playName.htmlText = preStr + info.name + nextStr;
			_mc._postName.htmlText = preStr + info.honorName + nextStr;
			_mc._guildName.htmlText = preStr + info.guildName + nextStr;
			_mc._techLvl.htmlText = preStr + info.techLevel + nextStr;
			
			this.addEventListener(MouseEvent.CLICK, function():void{
				ControllerManager.userInfoController.showOtherUserInfo(info.id);
			});
		}

	}
}
