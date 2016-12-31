package com.brickmice.view.component
{
	import com.framework.ui.basic.sprite.CSprite;
	import com.brickmice.view.component.BmButton;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author derek
	 */
	public class McTrainSelect extends CSprite
	{
		private var _mc : MovieClip;	
		private var _img : McImage;
		private var _selected:Boolean = false;
		
		/**
		 * 构造函数
		 * 
		 * @param imgName 物品的图片名称.
		 * @param num 左上方数字
		 * @param text 载重
		 * @param selected 默认是否选择
		 * @param enabled 是否可用
		 */
		public function McTrainSelect(imgName : String = '', num : int = 0, text : String = null, selected:Boolean = false, enabled:Boolean = true)
		{
			// 构造一个item
			_mc = new ResTrainSelect;
			addChildEx(_mc);

			// 按照背景宽高设置组件宽高
			cWidth = _mc.width;
			cHeight = _mc.height;
			
			_mc._carry.htmlText = text;

			// 0不显示数字
			_mc._lvl.text = num == 0 ? '' : num.toString();
			
			// 生成图片
			_img = new McImage();
			if (imgName != '' && imgName != null)
			{
				resetImage(imgName);
			}
			
			new BmButton(_mc._chooseBtn, function():void{});
			
			_mc._checkBox.gotoAndStop(1);
			
			if(selected) switchSelect();
			
			evts.addClick(function():void{
				switchSelect();
			});
			
			if(!enabled) enable = false;
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
			}else{
				_selected = true;
				_mc._checkBox.gotoAndStop(2);			
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
				if (_img.parent != this)
					addChildH(_img, -2);
			});
			_img.visible = true;
		}
		
		/**
		 * 清空图片
		 */
		public function clear() : void
		{
			_img.visible = false;
			_mc._lvl.visible = false;
		}

	}
}
