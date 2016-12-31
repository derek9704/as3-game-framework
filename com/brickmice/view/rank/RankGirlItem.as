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
	public class RankGirlItem extends Sprite
	{
		private var _mc:ResRankGirlItem;

		public function RankGirlItem(info : Object)
		{
			_mc = new ResRankGirlItem;
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
			_mc._girlHeroName.filters = [FilterUtils.createGlow(0x000000, 500)];
			_mc._girlHeroName.htmlText = '<font color="' + Trans.heroQualityColor[info.quality] + '">' + info.name + '</font>';
			_mc._girlLvl.htmlText = preStr + info.level + nextStr;
			_mc._researchSpeed.htmlText = preStr + info.speed + '/分' + nextStr;
			_mc._logic.htmlText = preStr + info.logic + nextStr;
			_mc._creativity.htmlText = preStr + info.create + nextStr;
			
			this.addEventListener(MouseEvent.CLICK, function():void{
				ControllerManager.girlHeroController.showOtherGirlHero(info.id);
			});
		}

	}
}
