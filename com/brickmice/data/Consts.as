package com.brickmice.data
{
	import flash.utils.Dictionary;

	/**
	 * 配置文件
	 *
	 * @author derek
	 */
	public class Consts
	{
		/**
		 * 默认高度
		 */
		public static const HEIGHT:uint = 800;
		/**
		 * 默认宽度
		 */
		public static const WIDTH:uint = 1200;
		/**
		 * 发条鼠
		 */
		public static const ID_MOUSE:uint = 12001;
		/**
		 * 原浆ID
		 */
		public static const ID_PUREE:uint = 21001;
		/**
		 * 稀铁ID
		 */
		public static const ID_IRON:uint = 22001;
		/**
		 * 月石ID
		 */
		public static const ID_MOONSTONE:uint = 23001;
		/**
		 * 夜石ID
		 */
		public static const ID_NIGHTSTONE:uint = 23002;
		/**
		 * 生命石ID
		 */
		public static const ID_LIFESTONE:uint = 23003;
		
		/**
		 * 服务器地址
		 */
		public static var requestURL:String = "";
		/**
		 * 资源服务器地址
		 */
		public static var resourceURL:String = "";
		/**
		 * 官网地址
		 */
		public static var siteURL:String = "";
		/**
		 * 是否DEBUG模式
		 */
		public static var debug:Boolean = false;
		/**
		 * 实时加载资源的字典
		 */
		public static var resourceDic:Dictionary = new Dictionary();
		/**
		 * 是否心跳
		 */
		public static var heartBool:Boolean = false;
		/**
		 * 聊天服务器IP
		 */
		public static var chatServer:String = "";
		/**
		 * 是否绿色服
		 */
		public static var isGreen:Boolean = false;
		/**
		 * 聊天服务器端口
		 */
		public static var chatPort:int = 0;
		/**
		 * 服务器和本地时间差距
		 */
		public static var timeGap : int = 0;
		/**
		 * 发条鼠体重
		 */
		public static var mouseWeight : int = 20;	
	}
}
