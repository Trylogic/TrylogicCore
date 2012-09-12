package tl.adapters
{

	import flash.geom.Rectangle;

	import tl.view.IView;

	public interface IViewContainerAdapter
	{
		function addView( view : IView ) : void;

		function addViewAtIndex( view : IView, index : int ) : void;

		function setViewIndex( view : IView, index : int ) : void;

		function removeView( view : IView ) : void;

		function removeViewAt( index : int ) : void;

		function get numViews() : uint;

		function set viewScrollRect( value : Rectangle ) : void;

		function get viewScrollRect() : Rectangle;
	}
}
