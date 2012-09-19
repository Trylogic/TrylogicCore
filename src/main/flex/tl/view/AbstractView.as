package tl.view
{

	import flash.events.EventDispatcher;

	import mx.core.IStateClient2;
	import mx.events.PropertyChangeEvent;

	import tl.ioc.IoCHelper;
	import tl.viewController.IVIewController;
	import tl.viewController.ViewController;

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
	public class AbstractView extends EventDispatcher implements IView, IStateClient2
	{
		public namespace lifecycle = "http://www.trylogic.ru/view/lifecycle";
		public namespace viewInternal = "http://www.trylogic.ru/view/internal";

		use namespace viewInternal;

		public var eventMaps : Vector.<EventMap>;

		public var controllerClass : Class = ViewController;

		[Inject]
		protected var _statesImpl : IStateClient2 = IoCHelper.resolve( IStateClient2, this );

		protected var _face : IDisplayObject;

		viewInternal var _controller : IVIewController;

		[Bindable(event="propertyChange")]
		public function get face() : IDisplayObject
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

		public function get x() : Number
		{
			return face.x;
		}

		[Bindable]
		public function set x( value : Number ) : void
		{
			face.x = value;
		}

		public function get y() : Number
		{
			return face.y;
		}

		[Bindable]
		public function set y( value : Number ) : void
		{
			face.y = value;
		}

		public function get width() : Number
		{
			return face.width;
		}

		[Bindable]
		public function set width( value : Number ) : void
		{
			face.width = value;
		}

		public function get height() : Number
		{
			return face.height;
		}

		[Bindable]
		public function set height( value : Number ) : void
		{
			face.height = value;
		}

		public function get scaleX() : Number
		{
			return face.scaleX;
		}

		[Bindable]
		public function set scaleX( value : Number ) : void
		{
			face.scaleX = value;
		}

		public function get scaleY() : Number
		{
			return face.scaleY;
		}

		[Bindable]
		public function set scaleY( value : Number ) : void
		{
			face.scaleY = value;
		}

		public function get alpha() : Number
		{
			return face.alpha;
		}

		[Bindable]
		public function set alpha( value : Number ) : void
		{
			face.alpha = value;
		}

		public function get visible() : Boolean
		{
			return face.visible;
		}

		[Bindable]
		public function set visible( value : Boolean ) : void
		{
			face.visible = value;
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

		protected function lazyCreateFace() : IDisplayObject
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

		public function get currentState() : String
		{
			return _statesImpl.currentState;
		}

		[Bindable(event="currentStateChange")]
		public function set currentState( value : String ) : void
		{
			_statesImpl.currentState = value;
		}

		[ArrayElementType("mx.states.State")]
		public function get states() : Array
		{
			return _statesImpl.states;
		}

		public function set states( value : Array ) : void
		{
			_statesImpl.states = value;
		}

		[ArrayElementType("mx.states.Transition")]
		public function get transitions() : Array
		{
			return _statesImpl.transitions;
		}

		public function set transitions( value : Array ) : void
		{
			_statesImpl.transitions = value;
		}

		public function hasState( stateName : String ) : Boolean
		{
			return _statesImpl.hasState( stateName );
		}
	}
}