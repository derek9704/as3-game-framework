package com.brickmice.view.component
{
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
	public class McItem extends CSprite
	{
		private var _mc : MovieClip;	
		private var _img : McImage;
		private var _big:Boolean = true;
		private var _num1:TextField;
		private var _num2:TextField;
		
		/**
		 * 位置 
		 */
		public var pos:int;
		
		/**
		 * 构造函数
		 * 
		 * @param imgName 物品的图片名称.(图片名称应该为 imgName.png.如 girl.png，为init时不触发image loader)
		 * @param num1 左上方数字
		 * @param num2 右下方数字
		 * @param big 尺寸大还是小
		 * @param text 物品下方文字
		 * @param dragId 拖拽id(如果设置了拖拽id.则自身是可以拖拽的.默认 = -1.即不可拖拽)
		 * @param data 拖拽成功后发送出去的数据(dragId = -1时无效)
		 * @param onDragHit 当碰到与dragId相同的placeId的时候.会触发.格式 onDragHit():void;
		 * @param onDragOver 当拖拽结束的时候会触发本函数.格式 onDragOver(flag:Boolean):void; 
		 * 										flag = true则自己被丢到了某个合法物件上.flag = false.则只是普通的拖拽结束.
		 */
		public function McItem(imgName : String = 'init', num1 : int = 0, num2 : int = 0, big : Boolean = true, text : String = null, dragId : int = -1, data : * = null, onDragHit : Function = null, onDragOver : Function = null, ignoreBg:Boolean = false)
		{
			// 构造一个item
			_mc = big ? new ResItem : new ResSItem;
			addChildH(_mc, 1);
			
			if(ignoreBg) _mc.visible = false;
			
			_big = big;
			
			_mc._delBtn.visible = false;

			// 按照背景宽高设置item宽高
			cWidth = big ? 72 : 44;
			cHeight = big ? 72 : 44;
			
			// 指定了下方文字则生成文字的textfield
			if (text != null)
			{
				var tf : TextFormat = new TextFormat();
				tf.size = 12;
				tf.color = 0x000000;
				
				var txt : TextField = new TextField();
				txt.defaultTextFormat = tf;
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.mouseEnabled = false;
				txt.multiline = true;
				txt.htmlText = text;
				
				// 由于添加了文字.修改一下item高度
				cHeight += txt.height;
				
				// 修正宽度
//				if (txt.width > cWidth)
//					cWidth = txt.width;
				
				addChildEx(txt, (_mc.width - txt.width) / 2, _mc.height);
			}

			var tf2 : TextFormat = new TextFormat();
			tf2.size = big ? 12 : 10;
			tf2.color = 0xF5EAD0;
			
			_num1 = new TextField();
			_num1.defaultTextFormat = tf2;
			_num1.filters = [FilterUtils.createGlow(0xAC0000, 500)];
			_num1.autoSize = TextFieldAutoSize.LEFT;
			_num1.mouseEnabled = false;
			_num1.multiline = false;
			addChildEx(_num1);		
			
			_num2 = new TextField();
			_num2.defaultTextFormat = tf2;
			_num2.filters = [FilterUtils.createGlow(0xAC0000, 500)];
			_num2.autoSize = TextFieldAutoSize.RIGHT;
			_num2.mouseEnabled = false;
			_num2.multiline = false;
			addChildEx(_num2, 0, big ? 55 : 28, rt);
			
			// 0不显示数字
			_num1.text = num1 == 0 ? '' : num1.toString();
			//小于2不显示数字
			_num2.text = num2 < 2 ? '' : num2.toString();
			
			_mc._itemBox.gotoAndStop(1);
			
			// 生成图片
			_img = new McImage();
			_img.mouseEnabled = false;
			if (imgName == 'init')
			{
				_mc._itemBox.gotoAndStop(3);
			}		
			else if(imgName == 'unopen')
			{
				_mc._itemBox.gotoAndStop(4);
			}
			else
			{
				resetImage(imgName);
			}

			// 如果指定了拖拽id.则设定拖拽逻辑
			if (dragId >= 0)
			{
				this.dragInfo.setDrag(dragId, data, true, true, onDragHit, onDragOver);
			}
		}

		/**
		 * 重设图片名
		 * 
		 * @param imgName 新的图片名称
		 */
		public function resetImage(imgName : String) : void
		{
			if (imgName == 'init')
			{
				_mc._itemBox.gotoAndStop(3);
			}		
			else if(imgName == 'unopen')
			{
				_mc._itemBox.gotoAndStop(4);
			}
			else
			{
				_mc._itemBox.gotoAndStop(1);
			}
			
			// 更换图片
			_img.reload(imgName, function() : void
			{
				// 判断是否加入
				if (_img.parent != this){
					if(!_big){
						_img.width = cWidth;
						_img.height = cHeight;	
					}else{
						_img.height = 72.5;
						_img.width = 72.5;
					}
					addChildH(_img);
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
			_mc._itemBox.gotoAndStop(1);
			_img.visible = false;
			_num1.visible = false;
			_num2.visible = false;
		}
		
		public function set borderLight(val : Boolean) : void
		{
			if (val)
			{
				FilterUtils.glow(_mc, 0xFFFF00, 15, 5);
			}
			else
			{
				FilterUtils.clearGlow(_mc);
			}
		}
		
		public function set delFunc(func:Function) : void
		{
			this.evts.addEventListener(MouseEvent.MOUSE_OVER, function():void{
				_mc._delBtn.visible = true;
			});
			this.evts.addEventListener(MouseEvent.MOUSE_OUT, function():void{
				_mc._delBtn.visible = false;
			});
			new BmButton(_mc._delBtn, func, false, true);
		}
		
		public function set num1(num1:int) : void
		{
			// 0不显示数字
			_num1.text = num1 == 0 ? '' : num1.toString();
		}
		
		public function set num2(num2:int) : void
		{
			//小于2不显示数字
			_num2.text = num2 < 2 ? '' : num2.toString();
		}

	}
}
