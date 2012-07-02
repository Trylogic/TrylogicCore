﻿package tl.starling.view
{

	import mx.core.IMXMLObject;

	import flash.events.EventDispatcher;

	import mx.core.IStateClient2;
	import mx.core.UIComponent;
	import mx.events.PropertyChangeEvent;

	import starling.display.Sprite;

	import tl.ioc.IoCHelper;
	import tl.starling.viewController.StarlingViewController;

	[DefaultProperty("subViews")]
	/**
	 * Basic IView implementation
	 *
	 * @see IViewController
	 *
	 */
	public class StarlingView extends UIComponent implements IMXMLObject
	{
		public var eventMaps : Vector.<EventMap>;

		public namespace lifecycle = "http://www.trylogic.ru/view/lifecycle";

		protected var _face : Sprite;

		private var _controllerClass : Class;
		private var _subViews : Vector.<StarlingView> = new Vector.<StarlingView>();
		private var _controller : StarlingViewController;

		[Bindable(event="propertyChange")]
		public function get face() : Sprite
		{
			if ( _face == null )
			{
				_face = new starling.display.Sprite();
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "face", null, _face));
			}
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

		public function get controller() : StarlingViewController
		{
			if ( _controller == null )
			{
				initController();
			}

			return _controller;
		}

		public function StarlingView()
		{
			IoCHelper.injectTo( this );
		}

		public function isAddedToStage() : Boolean
		{
			return face.stage != null;
		}

		public function initController() : void
		{
			if ( _controllerClass == null || !(_controller is _controllerClass) )
			{
				destroyController();

				_controller = _controllerClass == null ? (new StarlingViewController()) : (new _controllerClass());

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

		public function addElement( element : StarlingView ) : void
		{
			if ( _subViews.indexOf( element ) != -1 )
			{
				return;
			}

			if ( element is StarlingView )
			{
				element.controller.addViewToContainer( face );
				_subViews.push( element );
			}
			else
			{
				throw new ArgumentError( "Element with type '" + Object( element ).constructor + "' can't be child of View!" );
			}
		}

		public function addElementAt( element : StarlingView, index : int ) : void
		{
			addElement( element );

			setElementIndex( element, index );
		}

		public function setElementIndex( element : StarlingView, index : int ) : void
		{
			if ( _subViews.indexOf( element ) == -1 )
			{
				return;
			}

			if ( element is StarlingView )
			{
				// TODO: throw error if element is not our child
				element.controller.setViewIndexInContainer( face, index );
			}
			else
			{
				throw new ArgumentError( "Element with type '" + Object( element ).constructor + "' can't be child of View!" );
			}
		}

		public function removeElement( element : StarlingView ) : void
		{
			if ( _subViews.indexOf( element ) == -1 )
			{
				return;
			}

			if ( element is StarlingView )
			{
				StarlingView( element ).controller.removeViewFromContainer( face );

				_subViews.splice( _subViews.indexOf( element ), 1 );
			}
			else
			{
				throw new ArgumentError( "Element with type '" + Object( element ).constructor + "' can't be child of View!" );
			}
		}

		/**
		 * Inner childs.
		 *
		 * @param value
		 */
		public function set subViews( value : Vector.<StarlingView> ) : void
		{
			if ( value == null )
			{
				value = new Vector.<StarlingView>();
			}

			var element : *;

			for each ( element in _subViews.concat() )
			{
				if ( value.indexOf( element ) == -1 )
				{
					removeElement( element );
				}
			}

			for each ( element in value )
			{
				if ( _subViews.indexOf( element ) == -1 )
				{
					addElement( element );
				}
				else
				{
					setElementIndex( element, -1 );
				}
			}

			_subViews = value;
		}

		public final function get subViews() : Vector.<StarlingView>
		{
			return _subViews.concat();
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
			subViews = null;
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