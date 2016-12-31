package com.brickmice.view.rank
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.framework.utils.FilterUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author derek
	 */
	public class RankBoyItem extends Sprite
	{
		private var _mc:ResRankBoyItem;

		public function RankBoyItem(info : Object)
		{
			_mc = new ResRankBoyItem;
			addChild(_mc);
			_mc.mouseEnabled = _mc.mouseChildren = false;
			
			var preStr:String = '';
			var nextStr:String = '';
			if(info.userId == Data.data.user.id){
				preStr = '<font color="#ff0000">';
				nextStr = '</font>';
			}
			_mc._rank.htmlText = info.rank;
			_mc._campLogo.gotoAndStop(int(info.unionid) == 1 ? 1 : 2);
			_mc._Name.htmlText = preStr + info.userName + nextStr;
			_mc._boyHeroName.filters = [FilterUtils.createGlow(0x000000, 500)];
			_mc._boyHeroName.htmlText = '<font color="' + Trans.heroQualityColor[info.quality] + '">' + info.name + '</font>';
			_mc._boyHeroLvl.htmlText = preStr + info.level + nextStr;
			_mc._troops.htmlText = preStr + info.troop + nextStr;
			_mc._ATK.htmlText = preStr + info.lead + nextStr;
			_mc._Def.htmlText = preStr + info.spirit + nextStr;
			
			this.addEventListener(MouseEvent.CLICK, function():void{
				ControllerManager.boyHeroController.showOtherBoyHero(info.id);
			});
		}

	}
}
