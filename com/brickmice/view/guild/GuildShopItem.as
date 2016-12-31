package com.brickmice.view.guild
{
	import com.brickmice.view.component.McImage;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.FilterUtils;
	
	import flash.display.MovieClip;
	
	public class GuildShopItem extends CSprite
	{
		private var _mc:MovieClip;
		private var _img : McImage;
		
		public function GuildShopItem(data:Object)
		{
			_mc = new ResGuildShopItem;
			addChildEx(_mc);
			
			//头像
			_img = new McImage(data.img, function():void{
				_img.height = _img.width = 72.5;
			});
			_mc._itemBg.addChild(_img);
			
			_mc._name.text = data.name;
			_mc._price.text = data.buyprice;
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