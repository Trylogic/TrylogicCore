﻿package tl.view
{

	import mx.core.UIComponent;
	import mx.events.PropertyChangeEvent;

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
	public class AbstractView extends UIComponent implements IView
	{
		public namespace lifecycle = "http://www.trylogic.ru/view/lifecycle";
		public namespace viewInternal = "http://www.trylogic.ru/view/internal";

		use namespace viewInternal;

		public var eventMaps : Vector.<EventMap>;

		public var controllerClass : Class = ViewController;

		protected var _face : *;
		viewInternal var _controller : IVIewController;

		[Bindable(event="propertyChange")]
		public function get face() : *
		{
			if ( _face == null )
			{
				_face = lazyCreateFace();
				lifecycle::init();
				dispatchEvent( PropertyChangeEvent.createUpdateEvent( this, "face", null, _face ) );
			}
			return _face;
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
		}

		/**
		 * Destroy a IView.
		 *
		 * @see internalDispose
		 *
		 */
		public final function destroy() : void
		{
			viewInternal::destroy();
			lifecycle::destroy();

			destroyController();
		}

		viewInternal function initController() : void
		{
			if ( controllerClass == null || !(_controller is controllerClass) )
			{
				destroyController();

				_controller = controllerClass == null ? (new ViewController()) : (new controllerClass());

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

		protected function lazyCreateFace() : *
		{
			return null;
		}

		viewInternal function destroy() : void
		{

		}

		viewInternal function destroyController() : void
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