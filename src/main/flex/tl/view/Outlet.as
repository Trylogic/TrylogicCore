package tl.view
{

	import flash.events.IEventDispatcher;
	import flash.utils.flash_proxy;

	import mx.utils.ObjectProxy;
	import mx.utils.object_proxy;

	use namespace flash_proxy;
	use namespace object_proxy;

	public dynamic class Outlet extends ObjectProxy implements IEventDispatcher
	{
		private var changedProperties : Object = {};

		public function get outletObject() : *
		{
			return super.object;
		}

		public function set instance( value : Object ) : void
		{
			if(value == super.object)
			{
				return;
			}

			if ( value != null )
			{
				for ( var prop : String in changedProperties )
				{
					value[prop] = changedProperties[prop];
				}
			}

			super.readExternal( new SimpleInput( value == null ? {} : value ) );
		}

		public function Outlet()
		{

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