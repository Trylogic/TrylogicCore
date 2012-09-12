package tl.utils
{

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import mx.core.*;
	import mx.events.StateChangeEvent;
	import mx.states.IOverride;
	import mx.states.State;

	public class StatesImpl extends EventDispatcher implements IStateClient2
	{
		private var _currentState : String;
		private var _oldState : String;
		private var _states : Array = [];
		private var _transitions : Array;

		private var _target : IEventDispatcher;

		public function StatesImpl( target : IEventDispatcher )
		{
			_target = target;
		}

		public function get currentState() : String
		{
			return _currentState;
		}

		public function set currentState( value : String ) : void
		{
			_oldState = _currentState;
			_currentState = value;
			statesInvalidate();
			_target.dispatchEvent( new StateChangeEvent( StateChangeEvent.CURRENT_STATE_CHANGE, false, false, _oldState, _currentState ) );
		}

		[ArrayElementType("mx.states.State")]
		public function get states() : Array
		{
			return _states == null ? [] : _states.concat();
		}

		public function set states( value : Array ) : void
		{
			_states = value == null ? [] : value;

			statesInvalidate();
		}

		[ArrayElementType("mx.states.Transition")]
		public function get transitions() : Array
		{
			return _transitions;
		}

		public function set transitions( value : Array ) : void
		{
			_transitions = value;
		}

		public function hasState( stateName : String ) : Boolean
		{
			return getState( stateName ) == null;
		}

		protected function statesInvalidate() : void
		{
			if ( !_states || _oldState == _currentState )
			{
				return;
			}
			var oride : IOverride;

			var state : State = getState( _oldState );

			if ( state )
			{
				for each ( oride in state.overrides )
				{
					oride.remove( _target );
				}
				state.mx_internal::dispatchExitState();
			}

			state = getState( _currentState );

			initializeState( _currentState );

			if ( state )
			{
				for each ( oride in state.overrides )
				{
					oride.apply( _target );
				}
				state.mx_internal::dispatchEnterState();
			}

		}

		private function getState( stateName : String ) : State
		{
			for each( var state : State in _states )
			{
				if ( state.name == stateName )
				{
					return state;
				}
			}

			return null;
		}

		private function initializeState( stateName : String ) : void
		{
			var state : State = getState( stateName );

			while ( state )
			{
				state.mx_internal::initialize();
				state = getState( state.basedOn );
			}
		}
	}
}
