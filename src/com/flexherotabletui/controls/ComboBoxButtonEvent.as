package com.flexherotabletui.controls
{
	import flash.events.Event;
	/**
	 * Event dispatched by the combo when the user cancel or accept a list selection.
	 *  
	 * @author c17911
	 */	
	public class ComboBoxButtonEvent extends Event
	{
		/**
		 * Hold selected data. 
		 */		
		public var data:Vector.<Object>;
		
		public function ComboBoxButtonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}