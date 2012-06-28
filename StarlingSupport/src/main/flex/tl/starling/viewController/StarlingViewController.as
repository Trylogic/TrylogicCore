package tl.starling.viewController
{

	import mx.utils.object_proxy;

	import starling.display.*;
	import starling.events.*;

	import tl.actions.IActionDispatcher;
	import tl.ioc.IoCHelper;
	import tl.starling.view.StarlingView;
	import tl.utils.describeTypeCached;
	import tl.view.Outlet;

	use namespace object_proxy;

	[Outlet]
	public class StarlingViewController extends EventDispatcher
	{
		{
			if ( describeTypeCached( StarlingViewController )..metadata.( @name == "Outlet" ).length() == 0 )
			{
				throw new Error( "Please add -keep-as3-metadata+=Outlet to flex compiler arguments!" )
			}
		}

		protected namespace lifecycle = "http://www.trylogic.ru/viewController/lifecycle";

		[Inject]
		public var actionDispatcher : IActionDispatcher;

		private var _viewControllerContainer : StarlingViewController;
		private var _viewInstance : StarlingView;
		private var _viewEventHandlers : Array;
		private var _viewOutlets : Array;

		public function StarlingViewController()
		{
			IoCHelper.injectTo( this );
		}

		public function addViewToContainer( container : * ) : void
		{
			const displayObjectContainer : DisplayObjectContainer = DisplayObjectContainer( container );
			if ( DisplayObjectContainer( view ).parent == displayObjectContainer )
			{
				return;
			}

			lifecycle::viewBeforeAddedToStage();

			displayObjectContainer.addChild( view as DisplayObject );
		}

		public function addViewToContainerAtIndex( container : *, index : int ) : void
		{
			addViewToContainer( container );

			setViewIndexInContainer( container, index );
		}

		public function setViewIndexInContainer( container : *, index : int ) : void
		{
			const displayObjectContainer : DisplayObjectContainer = DisplayObjectContainer( container );

			displayObjectContainer.setChildIndex( view as DisplayObject, index < 0 ? (displayObjectContainer.numChildren + index) : index );
		}

		public function removeViewFromContainer( container : * ) : void
		{
			lifecycle::viewBeforeRemovedFromStage();

			if ( viewIsLoaded )
			{
				var viewDisplayObject : DisplayObject = view as DisplayObject;
				if ( viewDisplayObject.parent )
				{
					viewDisplayObject.parent.removeChild( viewDisplayObject );
				}
			}
		}

		public function get parentViewController() : StarlingViewController
		{
			return _viewControllerContainer;
		}

		public function set parentViewController( value : StarlingViewController ) : void
		{
			_viewControllerContainer = value;
		}

		[Event(name="removedFromStage")]
		public final function viewRemovedFromStage() : void
		{
			_viewInstance.destroy();

			initWithView( null );

			destroy();
		}

		public function initWithView( newView : StarlingView ) : void
		{
			if ( newView == null )
			{
				if ( _viewInstance != null )
				{
					for each( var outletName : String in _viewOutlets )
					{
						unsetOutlet( outletName );
					}
					for ( var eventName : String in _viewEventHandlers )
					{
						unsetHandler( eventName );
					}

					_viewInstance = null;
				}
			}
			else
			{
				_viewInstance = newView;
				processView();

				internalViewLoaded();
				lifecycle::viewLoaded();

				if ( _viewInstance.isAddedToStage() )
				{
					lifecycle::viewBeforeAddedToStage();
					viewEventHandler( new Event( Event.ADDED_TO_STAGE ) );
				}
			}
		}

		public final function destroy() : void
		{
			lifecycle::destroy();
			internalDestroy();

			actionDispatcher.removeHandler( this );
			//actionDispatcher = null;
		}

		lifecycle function viewBeforeAddedToStage() : void
		{
		}

		lifecycle function viewBeforeRemovedFromStage() : void
		{
		}

		lifecycle function viewLoaded() : void
		{
		}

		lifecycle function destroy() : void
		{
		}

		internal function internalViewLoaded() : void
		{
		}

		internal function internalDestroy() : void
		{
		}

		protected final function get viewIsLoaded() : Boolean
		{
			return _viewInstance != null;
		}

		protected final function get view() : StarlingView
		{
			return _viewInstance;
		}

		private function processView() : void
		{
			if ( _viewEventHandlers == null )
			{
				_viewEventHandlers = [];

				describeTypeCached( this ).method.( valueOf().metadata.( @name == "Event" ).length() > 0 ).(
						registerListener( metadata.arg.( @key == "name" ).@value.toString(), String( @name ) )
						);
			}

			if ( _viewOutlets == null )
			{
				_viewOutlets = [];

				describeTypeCached( this ).variable.( valueOf().metadata.( @name == "Outlet" ).length() > 0 ).(
						_viewOutlets.push( @name )
						);
			}

			for each( var outletName : String in _viewOutlets )
			{
				setOutlet( outletName );
			}

			for ( var eventName : String in _viewEventHandlers )
			{
				setHandler( eventName );
			}
		}

		protected function setOutlet( name : String ) : void
		{
			var outlet : Object = _viewInstance[name];
			this[name] = outlet is Outlet ? Outlet( outlet ).object_proxy::outletObject : outlet;
		}

		protected function unsetOutlet( name : String ) : void
		{
			this[name] = null;
		}

		protected function setHandler( name : String ) : void
		{
			_viewInstance.addEventListener( name, viewEventHandler );
		}

		protected function unsetHandler( name : String ) : void
		{
			_viewInstance.removeEventListener( name, viewEventHandler );
		}

		private function registerListener( eventName : String, listener : String ) : void
		{
			if ( _viewEventHandlers[ eventName ] == null )
			{
				_viewEventHandlers[ eventName ] = [];
			}

			_viewEventHandlers[ eventName ].push( listener );
		}

		private function viewEventHandler( e : Event ) : void
		{
			var methods : Array = _viewEventHandlers[e.type];
			if ( methods != null )
			{
				for each( var methodName : String in methods )
				{
					var destFunc : Function = this[methodName] as Function;
					if ( destFunc != null )
					{
						destFunc.apply( null, destFunc.length == 1 ? [e] : null );
					}
				}
			}
		}
	}

}
