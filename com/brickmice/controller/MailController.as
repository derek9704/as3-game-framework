package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.mail.Mail;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;

	/**
	 * @author derek
	 */
	public class MailController
	{
		public function showMail():void
		{
			if (!ViewManager.hasView(Mail.NAME))
			{
				ModelManager.mailModel.queryMailList(Mail.INBOX, 1, function():void
				{
					ResourceLoader.loadRes([Consts.resourceDic["mail"]], function():void{
						var data:WindowData = new WindowData(Mail);
						ControllerManager.windowController.showWindow(data);
					}); 				
				});
			}else{
				(ViewManager.retrieveView(Mail.NAME) as Mail).closeWindow();
			}
		}
		
	}
}
