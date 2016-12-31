package com.brickmice.view.discovery
{
	import com.brickmice.ModelManager;
	import com.brickmice.view.component.BmButton;
	import com.framework.utils.UiUtils;
	
	import flash.display.Sprite;

	/**
	 * @author derek
	 */
	public class DiscoveryListItem extends Sprite
	{
		private var _mc:ResDiscoveryListItem;
		
		public function DiscoveryListItem(info : Object)
		{
			_mc = new ResDiscoveryListItem;
			addChild(_mc);
			
			_mc._boyHero.text = info.heroName;
			_mc._planetName.text = info.pName;
			
			UiUtils.setButtonEnable(_mc._exploreBtn, info.flag == 0);
					
			new BmButton(_mc._exploreBtn, function() : void
			{
				ModelManager.discoveryModel.finishDiscovery(info.hid, function():void{
					UiUtils.setButtonEnable(_mc._exploreBtn, false);
				});
			});
	
		}
	}
}
