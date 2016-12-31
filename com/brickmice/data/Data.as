package com.brickmice.data
{
	import com.brickmice.ControllerManager;
	import com.brickmice.view.ViewMessage;
	import com.framework.core.ViewManager;

	/**
	 * 数据解析类(将收到数据解析为本地Object数据)
	 * 包含了数据请求, 返回数据序列化, 返回结果函数调用
	 * @author derek
	 *
	 */
	public class Data
	{
		/**
		 * 服务端数据池
		 */
		public static var data:Object = {};

		/**
		 * 更新数据函数
		 * @param data JSON格式数据
		 * @return 如果返回值为false则说明解析错误, 此次请求失败.
		 */
		public static function setData(v:Object):Boolean
		{
			if (v.responseData == null)
				return false;
			var result:Boolean = true;
			var dataLength:int = v.responseData.length;
			var refreshOb:Object = {};
			for (var i:int = 0; i < dataLength; i++)
			{
				var itemResponseData:Object = v.responseData[i];

				// 检查command
				var cmd:String = itemResponseData.command as String;
				// 执行命令数组
				if (cmd)
				{
					if (cmd == 'errorMsg')
					{
						result = false;
					}
					ControllerManager.serverCallController.execute(cmd, itemResponseData.args);						
				}
				// 解析非command数据 
				else
				{
					// 判断属性描述路径为空
					var dataName:String = itemResponseData.data;
					if (dataName)
					{
						// 赋值
						setValue(dataName, itemResponseData.args);
						// 刷新对应的Key
						for (var dataKey:String in ViewMessage.REFRESH_TYPE)
						{
							var dataType:String = ViewMessage.REFRESH_TYPE[dataKey];
							var poslen:int = dataType.length;
							if (dataType == dataName.substr(0, poslen))
							{
								refreshOb[dataKey] = 1;
							}
						}
					}
					else result = false;  // 没command又不是data的情况，服务器出错？
				}
			}
			for (var refreshOne:String in refreshOb)
			{
				ViewManager.sendMessage(refreshOne);
			}
			return result;
		}

		/**
		 * 解析数据
		 */
		private static function setValue(path:String, args:*):void
		{
			// 初步解析路径.删除],',".然后 "[ => ."
			path = path.replace('[', '/');
			path = path.replace(']', '');
			path = path.replace('"', '');
			path = path.replace("'", '');

			var arrKey:Array = path.split('/');

			// trace('路径:' + path +' || 值:' + args);
			// path解析
			var t:Object = data;
			var len:int = arrKey.length;
			var len2:int = len - 1;

			for (var i:int = 0; i < len; i++)
			{
				var k:Object = arrKey[i];

				// 如果是数字(那就是数组的key)
				if (!isNaN(parseInt(String(k))))
				{
					k = parseInt(String(k));

					// 数组这个值不存在
					if (t[k] == null)
						t[k] = new Object();
				}
				else
				{
					// 如果不是一个数字 则是属性/字典的key
					// 如果没这个属性.新建一个

					if (!t.hasOwnProperty(k))
						t[k] = new Object();
				}
				// 判断是否到最底层
				if (i == len2)
				{
					//判断一下删除操作(只支持对象，不支持数组)
					if(args == '%del%') delete(t[k]);
					//赋值
					else t[k] = args;
					return;
				}

				// 递推到下面
				t = t[k];
			}
		}
	}
}
