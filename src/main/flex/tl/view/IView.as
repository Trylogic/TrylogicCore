package tl.view
{

	import flash.display.Stage;
	import flash.events.IEventDispatcher;

	import mx.core.IStateClient2;

	import tl.viewController.IVIewController;

	/**
	 * Main interface for any View
	 *
	 */
	public interface IView extends IEventDispatcher, IStateClient2
	{
		function get controller() : IVIewController;

		function get face() : *;

		/**
		 * Destroy this IView instance for future GC. After destroy this instance will not be used.
		 *
		 */
		function destroy() : void;
	}
}
