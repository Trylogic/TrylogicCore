package tl.viewController
{

	import flash.display.DisplayObjectContainer;

	import tl.view.IView;
	import tl.adapters.IViewContainerAdapter;

	public interface IVIewController
	{
		function addViewToContainer( container : IViewContainerAdapter ) : void;

		function addViewToContainerAtIndex( container : IViewContainerAdapter, index : int ) : void;

		function setViewIndexInContainer( container : IViewContainerAdapter, index : int ) : void;

		function removeViewFromContainer( container : IViewContainerAdapter ) : void;

		function destroy() : void;

		function initWithView( newView : IView ) : void;
	}
}
