package com.flexherotabletui.controls.treemap
{
	import mx.core.IDataRenderer;
	/**
	 * Interface for an item render of the treemap.
	 *  
	 * @author c17911
	 */
	public interface ITreemapLeafItemRenderer extends IDataRenderer
	{
		function set mapOwner(map:ITreemap):void;
		
		function get mapOwner():ITreemap;
		
		function get label():String;
	}
}