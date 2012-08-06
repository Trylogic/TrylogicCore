package tl.view
{

	import mx.core.IMXMLObject;

	import mx.core.UIComponent;

	import tl.ioc.IoCHelper;
	import tl.viewController.ViewController;
	import tl.viewController.IVIewController;

	/**
	 * Basic IView implementation
	 *
	 * Note: Yep, it's extends UIComponent... BUT! This "mx.mx.core.UIComponent" is monkey-patched,
	 * and there is no flex-related stuff (argh...).
	 * UIComponent is necessary for MXML - that's why i'm using it, don't judge me xD
	 *
	 * @see IViewController
	 *
	 */
	public class AbstractView extends UIComponent implements IMXMLObject, IView
	{
		public var eventMaps : Vector.<EventMap>;

		public namespace lifecycle = "http://www.trylogic.ru/view/lifecycle";

		protected var _face : *;

		private var _controllerClass : Class;
		private var _controller : IVIewController;

		[Bindable(event="propertyChange")]
		public function get face() : *
		{
			return _face;
		}

		public function get controllerClass() : Class
		{
			return _controllerClass;
		}

		public function set controllerClass( value : Class ) : void
		{
			_controllerClass = value;
		}

		public function get controller() : IVIewController
		{
			if ( _controller == null )
			{
				initController();
			}

			return _controller;
		}

		public function AbstractView()
		{
			IoCHelper.injectTo( this );
		}

		public function initController() : void
		{
			if ( _controllerClass == null || !(_controller is _controllerClass) )
			{
				destroyController();

				_controller = _controllerClass == null ? (new ViewController()) : (new _controllerClass());

				_controller.initWithView( this );

				if ( eventMaps )
				{
					for each( var eventMap : EventMap in eventMaps )
					{
						eventMap.bind();
					}
				}
			}
		}

		public function initialized( document : Object, id : String ) : void
		{
			initController();

			lifecycle::init();
		}

		/**
		 * Destroy a IView.
		 *
		 * @see internalDispose
		 *
		 */
		public final function destroy() : void
		{
			internalDestroy();
			lifecycle::destroy();


			destroyController();
		}

		internal function internalDestroy() : void
		{

		}

		private function destroyController() : void
		{
			var eventMap : EventMap;
			if ( _controller )
			{
				if ( eventMaps )
				{
					for each( eventMap in eventMaps )
					{
						eventMap.unbind();
					}
				}

				_controller.initWithView( null );
			}
		}

		/**
		 * custom init logic here
		 *
		 */
		lifecycle function init() : void
		{

		}

		/**
		 * custom dispose logic here
		 *
		 */
		lifecycle function destroy() : void
		{

		}
	}
}