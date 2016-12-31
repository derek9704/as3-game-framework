package com.brickmice.view.planet
{
	import com.brickmice.ControllerManager;
	import com.brickmice.view.component.McImage;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.FilterUtils;
	
	import flash.display.MovieClip;
	
	public class HouseSlot extends CSprite
	{
		private var _mc:MovieClip;
		private var _img : McImage;
		
		public function HouseSlot(data:Object, showDetail:Boolean = false)
		{
			super('', 81, 119, false);
			
			_mc = new ResPlanetHouseSlot;
			addChildEx(_mc);
			
			//头像
			_img = new McImage(data.heroImg);
			addChildEx(_img, 5, 15);
			
			_mc._playerName.text = data.username;
			_mc._Lv.text = data.heroLevel;
			_mc._heroName.text = data.heroName;
			_mc._mouseCount.text = data.mouseCount;
			
			if(showDetail) {
				evts.addClick(function():void{
					ControllerManager.boyHeroController.showOtherBoyHero(data.hid);
				});
			}
		}
		
		public function set borderLight(val : Boolean) : void
		{
			if (val)
			{
				FilterUtils.glow(_img, 0xFFFF00, 15, 5);
			}
			else
			{
				FilterUtils.clearGlow(_img);
			}
		}
	}
}