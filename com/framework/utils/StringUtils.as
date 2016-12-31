package com.framework.utils
{
	import flash.utils.Dictionary;

	/**
	 * 字符串相关助手
	 * @author derek
	 */
	public class StringUtils
	{
		/**
		 * 用0填充的数字字符串(左补零)
		 *
		 * @param num 数字
		 * @param length 字符串长度
		 */
		public static function zeroize(num:int, length:int = 2):String
		{
			var temp:String = num.toString();

			while (temp.length < length)
				temp = "0" + temp;

			return temp;
		}

		/**
		 * 从指定数据读取字符串.如果目标是null.则返回''
		 *
		 * @param obj 目标数据
		 */
		public static function getString(obj:*):String
		{
			return obj == null ? '' : obj.toString();
		}

		/**
		 * dic转换为字符串.
		 *
		 * @param dic 字典
		 */
		public static function dic2String(dic:Dictionary):String
		{
			var temp:String = "";
			var index:int = 0;

			for (var key:String in dic)
			{
				if (index > 0)
					temp += "&";
				temp += key + "=" + dic[key];
			}
			return temp;
		}

		/**
		 * 数字转换为字符串
		 *
		 * @param num 数字
		 * @param fixed 小数位数
		 */
		public static function number2Str(num:Number, fixed:int):String
		{
			var s:int = Math.floor(num);
			var tn:Number = num - s;
			var output:String = s.toString();
			output += ".";

			for (var i:int = 0; i < fixed; i++)
			{
				tn *= 10;
				output += String(Math.floor(tn) % 10);
			}

			return output;
		}

		/**
		 * 字符串转换为JS字符串
		 *
		 * @param input 字符串
		 */
		public static function ToJsonString(input:String):String
		{
			var output:String = input;
			output = output.replace(/\\/g, "\\\\");
			output = output.replace(/"/g, "\\\"");
			output = output.replace(/\t/g, "\\t");
			output = output.replace(/\n/g, "\\n");
			output = output.replace(/\r/g, "\\r");
			// others
			return "\"" + output + "\"";
		}

		/**
		 * 使用指定文本替换掉格式字符串
		 *
		 * @param format 格式字符串.需要替换的内容为 ($0) ($1) 等等.INDEX从0开始
		 * @param args 参数列表.内容为字符串数组.个数应该与.格式字符串中的($N) 数量相同.
		 */
		public static function formatText(format:String, args:Array):String
		{
			var result:String = format;

			for (var i:int = 0; i < args.length; i++)
			{
				result = result.replace('($' + i + ')', args[i]);
			}

			return result;
		}

		/**
		 * 删除指定的结尾字符
		 *
		 * @param str 字符串
		 * @param char 要删除的字符
		 */
		public static function clearString(str:String, char:String):String
		{
			return str.indexOf(char) > -1 ? str.substring(0, str.indexOf(char)) : str;
		}

		/**
		 * 去除字符串的两端空白
		 *
		 * @param txt 目标字符串
		 */
		public static function trim(txt:String):String
		{
			var myPattern:RegExp = /^\s+|\s+$/im;

			return txt.replace(myPattern, "");
		}

		/**
		 * 使用指定格式生成一个.html文本
		 *
		 * @param txt 显示文本
		 * @param color 颜色
		 * @param bold 粗体
		 * @param size 大小
		 */
		public static function generateHtmlText(txt:Object, color:String = '#ff0000', bold:Boolean = false, size:int = 12):String
		{
			var result:String = '<font color="' + color + '" size="' + size + '">' + StringUtils.trim(txt.toString()) + '</font>';

			if (bold)
				result = '<b>' + result + '</b>';

			return result;
		}
	}
}
