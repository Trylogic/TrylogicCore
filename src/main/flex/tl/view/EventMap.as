package tl.view
{

	import flash.events.*;

	import mx.core.IMXMLObject;

	[Event(name="listener", type="Object")]
	public class EventMap extends EventDispatcher implements IMXMLObject
	{
		public var type : String;
		public var destination : Object;

		protected var document : Object;
		protected var listener : Function;

		private var _source : *;

		public function get source() : *
		{
			return _source;
		}

		public function set source( value : * ) : void
		{
			if ( _source == value )
			{
				return;
			}

			unbind();
			_source = value;
			if ( _source )
			{
				bind();
			}
		}

		public function EventMap()
		{

		}

		override public function addEventListener( type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false ) : void
		{
			if ( type == "listener" )
			{
				this.listener = listener;
			}
		}

		public function bind() : void
		{
			if ( _source != null )
			{
				_source.addEventListener( type, handler );
			}
		}

		public function unbind() : void
		{
			if ( _source != null )
			{
				_source.removeEventListener( type, handler );
			}
		}

		private function handler( e : * ) : void
		{
			if ( listener != null )
			{
				if ( destination )
				{
					throw new Error( "You can't set destination when using listener!" );
				}

				listener( e );
			}
			else
			{
				if ( destination is Function )
				{
					var destFunc : Function = destination as Function;
					destFunc.apply( null, destFunc.length == 1 ? [e] : null );
				}
				else if ( destination is Event )
				{
					if ( document is IEventDispatcher )
					{
						IEventDispatcher( document ).dispatchEvent( ( destination as Event ) );
					}
				}
			}
		}

		public function initialized( document : Object, id : String ) : void
		{
			this.document = document;
		}
	}
}
