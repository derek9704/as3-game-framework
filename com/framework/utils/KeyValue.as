package com.framework.utils
{

	/**
	 * 键值对
	 *
	 * @author derek
	 */
	public class KeyValue
	{
		/**
		 * KEY
		 */
		public var key:String;
		/**
		 * VALUE
		 */
		public var value:*;

		public function KeyValue(key:String, value:*)
		{
			this.key = key;
			this.value = value;
		}
	}
}
