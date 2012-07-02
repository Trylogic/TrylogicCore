package tl.starling.view
{

	import flash.events.*;

	import mx.core.IMXMLObject;

	[Event(name="listener", type="starling.events.Event")]
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
			if ( document != null )
			{
				unbind();
				_source = value;
				bind();
			}
			else
			{
				_source = value;
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
						IEventDispatcher( document ).dispatchEvent( Event( destination ) );
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
