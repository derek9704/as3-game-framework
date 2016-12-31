package com.framework.ui.sprites
{
	import com.framework.ui.basic.sprite.CSprite;

	/**
	 * tip的基类
	 * @author derek
	 */
	public class CTip extends CSprite
	{
		public function CTip(name:String = '', w:Object = null, h:Object = null)
		{
			super(name, w, h, false);
			mouseChildren = false;
			mouseEnabled = false;
		}

		public function getData():void
		{
		}
	}
}
