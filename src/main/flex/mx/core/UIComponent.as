package mx.core
{

	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;

	import mx.events.PropertyChangeEvent;
	import mx.styles.IStyleManager2;

	import tl.ioc.IoCHelper;

	[Event(name="propertyChange", type="mx.events.PropertyChangeEvent")]
	[Event(name="currentStateChange", type="mx.events.StateChangeEvent")]
	public class UIComponent extends EventDispatcher implements IStateClient2
	{
		[Inject]
		public var _statesImpl : IStateClient2;

		public function UIComponent()
		{
			IoCHelper.injectTo( this );
		}

		public function get currentState() : String
		{
			return _statesImpl.currentState;
		}

		[Bindable(event="propertyChange")]
		public function set currentState( value : String ) : void
		{
			var oldValue : String = _statesImpl.currentState;
			if ( value == oldValue )
			{
				return;
			}

			_statesImpl.currentState = value;

			dispatchEvent( PropertyChangeEvent.createUpdateEvent( this, "currentState", oldValue, value ) );
		}

		[ArrayElementType("mx.states.State")]
		public function get states() : Array
		{
			return _statesImpl.states;
		}

		public function set states( value : Array ) : void
		{
			if ( value == _statesImpl.states )
			{
				return;
			}

			_statesImpl.states = value;
		}

		[ArrayElementType("mx.states.Transition")]
		public function get transitions() : Array
		{
			return _statesImpl.transitions;
		}

		public function set transitions( value : Array ) : void
		{
			if ( value == _statesImpl.transitions )
			{
				return;
			}

			_statesImpl.transitions = value;
		}

		public function hasState( stateName : String ) : Boolean
		{
			return _statesImpl.hasState( stateName );
		}


		protected function createChildren() : void
		{
		}

		protected function commitProperties() : void
		{
		}

		protected function measure() : void
		{
		}

		protected function updateDisplayList( unscaledWidth : Number, unscaledHeight : Number ) : void
		{
		}

		public function styleChanged( styleProp : String ) : void
		{
		}

		public function regenerateStyleCache( recursive : Boolean ) : void
		{
		}

		public function notifyStyleChangeInChildren( styleProp : String, recursive : Boolean ) : void
		{
		}

		public function get styleManager() : IStyleManager2
		{
			return null;
		}

		public function initialize() : void
		{
		}

		protected function keyDownHandler( event : KeyboardEvent ) : void
		{
		}

		protected function keyUpHandler( event : KeyboardEvent ) : void
		{
		}
	}
}