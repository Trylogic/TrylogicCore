﻿package tl.viewController
{

	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mx.events.PropertyChangeEvent;

	import mx.utils.object_proxy;

	import tl.view.IView;
	import tl.adapters.IViewContainerAdapter;
	import tl.utils.describeTypeCached;
	import tl.view.Outlet;

	use namespace object_proxy;
	use namespace outlet;

	public class ViewController extends EventDispatcher implements IVIewController
	{
		public namespace lifecycle = "http://www.trylogic.ru/viewController/lifecycle";

		protected var _viewInstance : IView;
		protected var _viewEventHandlers : Array;
		protected var _viewOutlets : Array;

		public function ViewController()
		{
		}

		public function addViewToContainer( container : IViewContainerAdapter ) : void
		{
			lifecycle::viewBeforeAddedToStage();

			container.addView( view );
		}

		public function addViewToContainerAtIndex( container : IViewContainerAdapter, index : int ) : void
		{
			addViewToContainer( container );

			setViewIndexInContainer( container, index );
		}

		public function setViewIndexInContainer( container : IViewContainerAdapter, index : int ) : void
		{
			container.setViewIndex( view, index < 0 ? (container.numViews + index) : index );
		}

		public function removeViewFromContainer( container : IViewContainerAdapter ) : void
		{
			lifecycle::viewBeforeRemovedFromStage();

			if ( viewIsLoaded )
			{
				container.removeView( view );
			}
		}

		[Event(name="removedFromStage")]
		public final function viewRemovedFromStage() : void
		{
			_viewInstance.destroy();

			initWithView( null );

			destroy();
		}

		public function initWithView( newView : IView ) : void
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
			}
		}

		public final function destroy() : void
		{
			lifecycle::destroy();
			internalDestroy();
		}

		[Event(name="propertyChange")]
		public function onPropertyChange( event : PropertyChangeEvent ) : void
		{
			if ( _viewOutlets && _viewOutlets.indexOf( event.property.toString() ) != -1 )
			{
				setOutlet( String( event.property ) );
			}
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

		protected function get view() : IView
		{
			return _viewInstance;
		}

		private function processView() : void
		{
			const myTypeDescription : XML = describeTypeCached( this );
			if ( _viewEventHandlers == null )
			{
				_viewEventHandlers = [];

				myTypeDescription.method.( valueOf().metadata.( @name == "Event" ).length() > 0 ).(
						registerListener( metadata.arg.( @key == "name" ).@value.toString(), String( @name ) )
						);
			}

			if ( _viewOutlets == null )
			{
				_viewOutlets = [];

				myTypeDescription.variable.( (valueOf()["@uri"] == outlet) ).(
						_viewOutlets.push( @name.toString() )
						);

				myTypeDescription.accessor.(@access != "readonly").( (valueOf()["@uri"] == outlet) ).(
						_viewOutlets.push( @name.toString() )
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
			this[name] = outlet is Outlet ? ( outlet as Outlet ).outletObject : outlet;
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
