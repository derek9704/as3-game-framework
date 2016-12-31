package com.brickmice.view.activity
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.McPanel;
	import com.brickmice.view.component.prompt.NoticeMessage;
	import com.framework.ui.sprites.WindowData;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Notice extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Notice";
		
		private var _mc:MovieClip;
		private var _noticeInfo:McPanel;

		public function Notice(data : Object)
		{
			_mc = new ResNoticeWindow;
			super(NAME, _mc);
	
			_noticeInfo = new McPanel('', 442, 244);
			addChildEx(_noticeInfo, 45, 88);
			
			var tf : TextFormat = new TextFormat();
			tf.size = 12;
			tf.color = 0x000000;
			tf.leading = 2;
			tf.font = 'SimSun';
			
			var txt:TextField = new TextField;
			txt.defaultTextFormat = tf;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.mouseEnabled = false;
			txt.multiline = true;
			
			txt.htmlText = Data.data.notice;
			_noticeInfo.addItem(txt);
			
			new BmButton(_mc._najianBtn, function():void{
				var msg:String = "无论是游戏BUG（亦或是小小的界面错位），<br>"
				+ "还是好的游戏展望与建议，我们都愿意倾听！<br><br>"
				+ "一旦被我们采纳，我们将送出最高一万宇宙钻奖励<br>"
				+ "分享方式：游戏内发送邮件给    银河管理员<br><br>"
				+ "感谢大家的支持~我们一直在努力！<br>";
				var title:String = "悬赏纳谏";
				ControllerManager.windowController.showWindow(new WindowData(NoticeMessage, {msg:msg, title:title}, false, 0, 0, 0, false));
			});
			
			new BmButton(_mc._yizhanBtn, function():void{
				var msg:String = "《一站到底》有奖问答现向广大玩家征集竞赛题目，"
				+ "题目类型为选择题，内容应与游戏有关，"
				+ "需给出一个问题及三个可选答案，其中一个标明为正确答案。<br>"
				+ "参与者除了有机会看见自己出的题出现在游戏中，"
				+ "还能获得宇宙钻奖励。<br>"
				+ "提交方式：游戏内发送邮件给    银河管理员";
				var title:String = "一站到底";
				ControllerManager.windowController.showWindow(new WindowData(NoticeMessage, {msg:msg, title:title}, false, 0, 0, 0, false));
			});
			
			_mc._najianBtn.visible = false;
			_mc._yizhanBtn.visible = false;
		}
	}
}