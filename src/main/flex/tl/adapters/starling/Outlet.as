package tl.adapters.starling
{

	import starling.events.EventDispatcher;

	import flash.utils.flash_proxy;

	import mx.utils.ObjectProxy;
	import mx.utils.object_proxy;

	import tl.view.*;

	use namespace flash_proxy;
	use namespace object_proxy;

	public dynamic class Outlet extends ObjectProxy implements IOutlet
	{
		private var changedProperties : Object = {};
		private var eventsInterests : Array = [];

		private var starlingDispatcher : EventDispatcher;

		public function get outletObject() : *
		{
			return super.object;
		}

		public function set instance( value : Object ) : void
		{
			var interest : String;

			if ( outletObject )
			{
				for each( interest in eventsInterests )
				{
					outletObject.removeEventListener( interest, dispatcher.dispatchEvent );
				}
			}

			if ( value != null )
			{
				for ( var prop : String in changedProperties )
				{
					value[prop] = changedProperties[prop];
				}

				if ( value is EventDispatcher )
				{
					for each( interest in eventsInterests )
					{
						value.addEventListener( interest, dispatcher.dispatchEvent );
					}
				}
			}

			super.readExternal( new SimpleInput( value == null ? {} : value ) );
		}

		public function Outlet()
		{
			starlingDispatcher = new EventDispatcher();
		}

		override flash_proxy function setProperty( name : *, value : * ) : void
		{
			changedProperties[name] = value;

			super.setProperty( name, value );
		}

		override flash_proxy function getProperty( name : * ) : *
		{
			if ( name == "constructor" )
			{
				return Outlet;
			}
			else
			{
				return super.getProperty( name );
			}
		}

		override flash_proxy function deleteProperty( name : * ) : Boolean
		{
			delete changedProperties[name];

			return super.deleteProperty( name );
		}

		override public function addEventListener( type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false ) : void
		{
			if ( !(type in eventsInterests) )
			{
				eventsInterests.push( type );
				if ( outletObject is EventDispatcher )
				{
					outletObject.addEventListener( type, starlingDispatcher.dispatchEvent );
				}
			}

			super.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}

		override public function removeEventListener( type : String, listener : Function, useCapture : Boolean = false ) : void
		{
			if ( type in eventsInterests )
			{
				eventsInterests.splice( eventsInterests.indexOf( type ), 1 );
				if ( outletObject )
				{
					outletObject.removeEventListener( type, starlingDispatcher.dispatchEvent );
				}
			}

			super.removeEventListener( type, listener, useCapture );
		}
	}
}

import flash.utils.ByteArray;

class SimpleInput extends ByteArray
{
	private var value : *;

	public function SimpleInput( value : * )
	{
		this.value = value;
	}

	override public function readObject() : *
	{
		return value;
	}
}