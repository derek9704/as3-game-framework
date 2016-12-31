package com.brickmice.view.component
{
	import com.framework.ui.basic.sprite.CSprite;
	
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	/**
	 * 逐字显示工具
	 * @author derek
	 */
	public class McLabelOneByOneCom extends CSprite
	{
		public var ndelay : int;
		// 默认间隔时间(ms)

		public function get playing():Boolean
		{
			return _playing;
		}

		private var _callBack : Function;
		private var position : int = 0;
		// 扫描位置
		private var num1 : int;
		// 存储用
		private var num2 : int;
		// 存储用
		private var str1 : String;
		// 存储用
		private var _playing : Boolean;
		// 是否在播放
		public var content : String;
		// 内容
		public var discontent : String;
		// htmltext自动换行补丁OTL
		public var textfield : TextField;
		// 目标文本框
		public var mytimer : Timer;
		private var timer1 : Timer;
		// sp1停顿用timer
		
		/**
		 * @param obj 传入需要逐字显示的文本
		 * @param callBack 完成后的回调函数
		 * @param getbreak 停顿时间
		 */
		public function McLabelOneByOneCom(obj : TextField, callBack : Function, getbreak : int = 100)
		{
			ndelay = getbreak;
			textfield = obj;
			_callBack = callBack;
		}

		/**
		 * 停止播放
		 */
		public function stop(callBackBool : Boolean = true) : void
		{
			if (playing)
			{
				mytimer.removeEventListener("timer", go);
				_playing = false;
				mytimer.stop();
			}
			;

			if (callBackBool)
			{
				_callBack();
			}
		}

		/**
		 * 开始播放
		 * @param cont 播放的文字
		 */
		public function play(cont : String) : void
		{
			if (playing != true)
			{
				_playing = true;
				content = cont;
				textfield.htmlText = "";
				discontent = "";
				position = 0;
				mytimer = new Timer(ndelay, content.length);
				mytimer.addEventListener("timer", go);
				mytimer.start();
			}
		}
		
		//直接播放到底
		public function showAll():void
		{
			if(!playing) return;
			textfield.htmlText = content;

			mytimer.removeEventListener("timer", go);
			_playing = false;
			mytimer.stop();
			_callBack();
		}

		/**
		 * timer运行的函数
		 * @param evt
		 */
		private function go(evt : TimerEvent) : void
		{
			while (content.substr(position, 1) == "<" || content.substr(position, 1) == "[")
			{
				checksp1();
				checksp2();
				checksp3();
				checksp4();
				checksp5();
				checksp6();
			}

			discontent += content.substr(position++, 1);
			textfield.htmlText = discontent;

			if (content.substr(position, 3) == "")
			{
				mytimer.removeEventListener("timer", go);
				_playing = false;
				mytimer.stop();
				_callBack();
			}
		}

		// iroiro检测-------------------------------------------------------------------
		/**
		 * 检测停顿用[ms]标签
		 */
		private function checksp1() : void
		{
			if (content.substr(position, 3) == "[ms")
			{
				num1 = content.indexOf("]", position + 3);
				// 标签头结尾位置
				str1 = content.substr(position + 3, num1 - position - 3);
				// 获得毫秒数
				position = num1 + 1;
				mytimer.stop();
				timer1 = new Timer(Number(str1), 1);
				timer1.addEventListener("timer", mytimerplay);
				timer1.start();
			}
		}

		/**
		 * 检测停顿范围<ms></ms>标签
		 */
		private function checksp2() : void
		{
			if (content.substr(position, 3) == "<ms")
			{
				num1 = content.indexOf(">", position);
				// 标签头结尾位置
				str1 = content.substr(position + 3, num1 - position - 3);
				// 获得毫秒数
				num2 = content.indexOf("</ms>", position);
				// 获得标签尾开头位置
				position = num1 + 1;
				mytimer.delay = Number(str1);
			}
			else if (content.substr(position, 5) == "</ms>")
			{
				mytimer.delay = ndelay;
				position += 5;
			}
		}

		/**
		 * 检测字体标签 
		 */
		private function checksp3() : void
		{
			if (content.substr(position, 5) == "<size")
			{
				num1 = content.indexOf(">", position + 4);
				// 标签头结尾位置
				str1 = content.substr(position + 5, num1 - position - 5);
				// 获得字体大小
				position = num1 + 1;
				discontent += "<font size='" + str1 + "'>";
			}
			else if (content.substr(position, 7) == "</size>")
			{
				discontent += "</font>";
				position += 7;
			}
		}

		/**
		 * 检测颜色标签
		 */
		private function checksp4() : void
		{
			if (content.substr(position, 2) == "<@")
			{
				num1 = content.indexOf(">", position + 1);
				// 标签头结尾位置
				str1 = content.substr(position + 2, num1 - position - 1);
				// 获得颜色
				position = num1 + 1;
				discontent += "<font color='#" + str1 + "'>";
			}
			else if (content.substr(position, 4) == "</@>")
			{
				discontent += "</font>";
				position += 4;
			}
		}

		/**
		 * 检测加粗<b>标签 
		 */
		private function checksp5() : void
		{
			if (content.substr(position, 3) == "<b>")
			{
				discontent += "<b>";
				position += 3;
			}
			else if (content.substr(position, 4) == "</b>")
			{
				discontent += "</b>";
				position += 4;
			}
		}

		/**
		 * 检测换行<br>标签
		 */
		private function checksp6() : void
		{
			if (content.substr(position, 5) == "<br>")
			{
				discontent += "<br>";
				position += 5;
			}
		}

		private function mytimerplay(evt : TimerEvent) : void
		{
			mytimer.start();
		}
	}
}