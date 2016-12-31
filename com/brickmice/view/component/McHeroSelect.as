package com.brickmice.view.component
{
	import com.brickmice.data.Trans;
	import com.brickmice.view.component.BmButton;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.FilterUtils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author derek
	 */
	public class McHeroSelect extends CSprite
	{
		private var _mc : MovieClip;	
		private var _img : McImage;
		private var _selected:Boolean = false;
		private var _isRadio:Boolean = false;
		private var _lvl:TextField;
		
		/**
		 * 构造函数
		 * 
		 * @param imgName 物品的图片名称.
		 * @param num 左上方数字
		 * @param text 员工名
		 * @param selected 默认是否选择
		 * @param enabled 是否可用
		 * @param isRadio 是否单选
		 */
		public function McHeroSelect(imgName : String = '', num : int = 0, text : String = null, quality:int = 0, selected:Boolean = false, enabled:Boolean = true, isRadio:Boolean = false)
		{
			// 构造一个item
			_mc = new ResHeroSelect;
			addChildEx(_mc);

			// 按照背景宽高设置组件宽高
			cWidth = _mc.width;
			cHeight = _mc.height;
			
			if(quality) _mc._name.htmlText = '<font color="' + Trans.heroQualityColor[quality] + '">' + text + '</font>';
			else  _mc._name.text = text;

			_isRadio = isRadio;
			
			var tf : TextFormat = new TextFormat();
			tf.size = 14;
			tf.color = 0xF4E8CD;
			
			_lvl = new TextField();
			_lvl.defaultTextFormat = tf;
			_lvl.filters = [FilterUtils.createGlow(0x950000, 500)];
			_lvl.autoSize = TextFieldAutoSize.LEFT;
			_lvl.mouseEnabled = false;
			_lvl.multiline = false;
			addChildEx(_lvl, 2);		
			
			// 0不显示数字
			_lvl.text = num == 0 ? '' : num.toString();
			
			// 生成图片
			_img = new McImage();
			_img.mouseEnabled = false;
			if (imgName != '' && imgName != null)
			{
				resetImage(imgName);
			}
			
			_mc._checkBox.mouseEnabled = false;
			_mc._checkBox.gotoAndStop(1);
			_mc._radioBox.gotoAndStop(1);
			
			_mc._checkBox.visible = !_isRadio;
			_mc._radioBox.visible = _isRadio;
			
			if(selected) switchSelect();
			
			if(!enabled) {
				enable = false;
				_mc._chooseBtn.gotoAndStop(1);
			}else{		
				_mc._chooseBtn.hitArea = _mc;
				new BmButton(_mc._chooseBtn, function(event : MouseEvent) : void
				{
					switchSelect();
				});	
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if(!value){
				_selected = false;
				_mc._checkBox.gotoAndStop(1);
				_mc._radioBox.gotoAndStop(1);
			}else{
				_selected = true;
				_mc._checkBox.gotoAndStop(2);			
				_mc._radioBox.gotoAndStop(2);			
			}
		}

		private function switchSelect():void
		{
			if(_selected){
				selected = false;
			}else{
				selected = true;
			}
		}

		/**
		 * 重设图片名
		 * 
		 * @param imgName 新的图片名称
		 */
		public function resetImage(imgName : String) : void
		{
			// 更换图片
			_img.reload(imgName, function() : void
			{
				// 判断是否加入
				if (_img.parent != this){
					addChildH(_img, 3);
					setChildIndex(_img, 2);
				}
			});
			_img.visible = true;
		}
		
		/**
		 * 清空图片
		 */
		public function clear() : void
		{
			_img.visible = false;
			_lvl.visible = false;
		}

	}
}
