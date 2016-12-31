package com.framework.utils
{

	/**
	 * 日期时间相关助手
	 */
	public class DateUtils
	{
		/**
		 * 转换字符串为dateTime
		 *
		 * @param	日期字符串 ,为空则返回当前时间
		 * @return
		 */
		public static function parse(dateTime:String):Date
		{
			if (dateTime == "" || dateTime == null)
				return new Date();

			return new Date(parseInt(dateTime.substr(6, dateTime.length - 8)));
		}

		/**
		 * 指定日期时间转换为短字符串 yyyy-mm-dd hh:mm
		 *
		 * @param	date
		 * @return
		 */
		public static function toShortString(date:Date):String
		{
			var min:String = date.getMinutes().toString();
			if (min.length == 1)
				min = "0" + min;

			return date.getFullYear().toString() + "-" + (date.getMonth() + 1).toString() + "-" + date.getDate().toString() + " " + date.getHours().toString() + ":" + min;
		}

		/**
		 * 转换成短日期格式
		 * @param	date
		 * @return
		 */
		public static function toShortDateString(date:Date):String
		{
			return date.getFullYear().toString() + "-" + (date.getMonth() + 1).toString() + "-" + date.getDate().toString();
		}

		/**
		 * 指定日期转换为长字符串 yyyy-mm-dd hh:mm:ss
		 *
		 * @param	date
		 * @return
		 */
		public static function toLongString(date:Date):String
		{
			var sec:String = date.getSeconds().toString();
			if (sec.length == 1)
				sec = "0" + sec;
			return toShortString(date) + ":" + sec;
		}

		/**
		 * 秒数 -> 时间字符串
		 * hh:mm:ss
		 *
		 * @param sec 秒数
		 */
		public static function toTimeString(sec:int):String
		{
			var result:String;

			var hour:int = int(sec / 3600);
			result = hour < 10 ? '0' + hour + ":" : hour.toString() + ":";
			var min:int = int((sec % 3600) / 60);
			result += min < 10 ? '0' + min + ":" : min.toString() + ":";
			var second:int = int(sec % 60);
			result += second < 10 ? '0' + second : second.toString();

			return result;
		}

		/**
		 * 获取和服务器差距后的当前时间
		 * @param gap 和服务器差距时间，若参数为0则是取当前时间
		 * @param multiple 和服务器时间的单位倍数，默认为0.001
		 * @return
		 */
		public static function nowDateTimeByGap(gap:Number = 0, multiple:Number = 0.001):Number
		{
			var nowTime:Date = new Date();

			var returnTime:Number = (nowTime.time * multiple) + gap;

			return returnTime;
		}

	}
}
