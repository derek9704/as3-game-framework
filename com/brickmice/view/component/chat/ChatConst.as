package com.brickmice.view.component.chat
{
	/**
	 * @author derek
	 */	
	public class ChatConst
	{
		//聊天性质的分类
		public static const UNION:String = "阵营";
		public static const WORLD:String = "世界";
		public static const GUILD:String = "联盟";
		public static const WHISPER:String = "私聊";
		public static const ALL:String = "综合";

		//展示颜色
		public static var COLOR_HERO:uint = 0x00FF00;
		
		//文字颜色
		public static const COLOR_SYSTEM:uint = 0x950000;
		public static const COLOR_UNION:uint = 0x7d5103;
		public static const COLOR_GUILD:uint = 0x165206;
		public static const COLOR_WORLD:uint = 0x000000;
		public static const COLOR_WHISPER:uint = 0x470264;
		public static const COLOR_COMMON:uint = 0x383736;
		public static const COLOR_USER:uint = 0x000000;
		
		//表情格式
		public static const faceFormat_Front:String = "<{";
		public static const faceFormat_Back:String = "}>";
		
		//装备, 人物展示 格式
		public static const showFormat_Front:String = "<|-";
		public static const showFormat_Back:String = "-|>";
		public static const showSplit:String = "|";
	}
}