package com.flexherotabletui.controls
{
	import com.flexherotabletui.skins.PromptListSkin;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.List;
	import spark.components.SkinnableContainer;
	
	public class PromptList extends List
	{
		[SkinPart(required="true")]
		public var acceptButton:Button;
		
		[SkinPart(required="true")]
		public var cancelButton:Button;
		
		public static var CANCEL:String = "cancel";
		
		public static var ACCEPT:String = "accept";
		
		
		public function PromptList()
		{
			super();
			setStyle("skinClass", PromptListSkin);
		}
		/**
		 * @inheritDoc 
		 */		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if (instance == acceptButton)
			{
				acceptButton.addEventListener(MouseEvent.CLICK, handleAccept);
			}
			if (instance == cancelButton)
			{
				cancelButton.addEventListener(MouseEvent.CLICK, handleCancel );
			}
		}
		/**
		 * @inheritDoc 
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if (instance == acceptButton)
			{
				acceptButton.removeEventListener(MouseEvent.CLICK, handleAccept);
			}
			if (instance == cancelButton)
			{
				cancelButton.removeEventListener(MouseEvent.CLICK, handleCancel );
			}
		}
		
		private function handleCancel(event:MouseEvent):void
		{
			this.dispatchEvent(new Event(CANCEL));
		}
		
		private function handleAccept(event:MouseEvent):void
		{
			this.dispatchEvent(new Event(ACCEPT));
		}
	}
}