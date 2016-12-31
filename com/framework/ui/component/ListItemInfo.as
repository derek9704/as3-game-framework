package com.framework.ui.component
{
	import com.framework.ui.basic.sprite.CSprite;

	import flash.display.DisplayObject;
	import flash.text.TextField;

	/**
	 * @author derek
	 */
	public class ListItemInfo
	{
		public static const NORMAL : int = 0;
		public static const HOT : int = 1;
		public static const SELECTED : int = 2;
		public var canvas : CSprite;
		public var textfield : TextField;
		public var id : String;
		public var text : String;
		public var hotBg : DisplayObject;
		public var selectedBg : DisplayObject;
		public var hotColor : int;
		public var selectedColor : int;
		public var normalColor : int;

		public function setStatus(flag : int) : void
		{
			hotBg.visible = false;
			selectedBg.visible = false;

			if (hotBg != null && flag == HOT)
			{
				textfield.textColor = hotColor;
				hotBg.visible = true;

				return;
			}

			if (selectedBg != null && flag == SELECTED)
			{
				textfield.textColor = selectedColor;
				selectedBg.visible = true;

				return;
			}

			textfield.textColor = normalColor;
		}
	}
}
