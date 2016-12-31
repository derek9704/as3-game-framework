package com.framework.utils
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	/**
	 * 背景音乐播放
	 * @author derek
	 */
	public class SoundUtils
	{
		public static var musicState:Boolean = true;
		private static var _isInit:Boolean = false;
		private static var _song:SoundChannel;
		private static var _music:Sound;
		private static var _nowPlayPosition:Number = 0;

		/**
		 * @param onOrOff state为真时，当前状态播放，为假时，当前状态停播
		 */
		public static function init(soundURL:String, onOrOff:Boolean = true):void
		{
			// 已经初始化了
			_isInit = true;

			// 根据默认传进来的值定影全局变量
			musicState = onOrOff;
			
			// 清空当前位置
			_nowPlayPosition = 0;

			// 定义音乐变量
			_song = new SoundChannel();
			_music = new Sound();

			// 获取音乐路径
			_music.load(new URLRequest(soundURL));

			// 根据当前状态来显示图片和播放音乐
			musicControl();
		}

		/**
		 * 根据当前状态显示图片播放音乐的控制函数
		 * @param state 当前状态
		 */
		public static function musicControl():void
		{
			if (!_isInit)
				return;

			// state为真时，当前状态播放，为假时，当前状态停播
			if (musicState)
			{
				// 音乐播放
				_song = _music.play(_nowPlayPosition);
				var st:SoundTransform = new SoundTransform();
				st.volume = 0.1;
				_song.soundTransform = st;
				
				// 音乐播放完成后重复播放
				_song.addEventListener(Event.SOUND_COMPLETE, completeHandler);
			}
			else
			{
				// 记录当前播放的位置
				_nowPlayPosition = _song.position;

				// 音乐停止
				_song.stop();
			}
		}

		/**
		 * 音乐播放完成后操作
		 */
		private static function completeHandler(evt:Event):void
		{
			_song.removeEventListener(Event.SOUND_COMPLETE, completeHandler);
			// 清空当前位置
			_nowPlayPosition = 0;
			// 根据状态操作
			musicControl();
		}
	}
}
