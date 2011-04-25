package com.flexherotabletui.controls.treemap
{
	import mx.core.IDataRenderer;

	public interface ITreemapLeafItemRenderer extends IDataRenderer
	{
		function set mapOwner(map:Treemap):void;
		
		function get mapOwner():Treemap;
		
		function get label():String;
	}
}