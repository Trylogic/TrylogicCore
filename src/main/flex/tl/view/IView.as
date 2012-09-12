package tl.view
{

	import flash.events.IEventDispatcher;

	import mx.core.IStateClient2;

	import tl.viewController.IVIewController;

	/**
	 * Main interface for any View
	 *
	 */
	public interface IView extends IEventDispatcher, IStateClient2, IDisplayObject
	{
		function get controller() : IVIewController;

		function get face() : IDisplayObject;

		/**
		 * Destroy this IView instance for future GC. After destroy this instance will not be used.
		 *
		 */
		function destroy() : void;
	}
}
