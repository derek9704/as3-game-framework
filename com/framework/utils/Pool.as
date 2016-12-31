package com.framework.utils
{
	import flash.utils.Dictionary;

	/**
	 * 资源池
	 * 用于重复使用的对象
	 *
	 * @author derek
	 */
	public class Pool
	{
		public static function getResource(clsRef:Class):Object
		{
			if (_dic[clsRef] == null)
				_dic[clsRef] = new clsRef();

			return _dic[clsRef];
		}

		private static var _dic:Dictionary = new Dictionary();
	}
}
