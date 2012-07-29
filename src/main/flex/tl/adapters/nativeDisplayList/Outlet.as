package tl.adapters.nativeDisplayList
{

	import tl.view.*;

	import flash.events.IEventDispatcher;
	import flash.utils.flash_proxy;

	import mx.utils.ObjectProxy;
	import mx.utils.object_proxy;

	use namespace flash_proxy;
	use namespace object_proxy;

	[Event(name="softKeyboardDeactivate", type="flash.events.SoftKeyboardEvent")]
	[Event(name="softKeyboardActivate", type="flash.events.SoftKeyboardEvent")]
	[Event(name="softKeyboardActivating", type="flash.events.SoftKeyboardEvent")]
	[Event(name="textInput", type="flash.events.TextEvent")]
	[Event(name="imeStartComposition", type="flash.events.IMEEvent")]
	[Event(name="contextMenu", type="flash.events.MouseEvent")]
	[Event(name="tabIndexChange", type="flash.events.Event")]
	[Event(name="tabEnabledChange", type="flash.events.Event")]
	[Event(name="tabChildrenChange", type="flash.events.Event")]
	[Event(name="keyUp", type="flash.events.KeyboardEvent")]
	[Event(name="keyDown", type="flash.events.KeyboardEvent")]
	[Event(name="rightMouseUp", type="flash.events.MouseEvent")]
	[Event(name="rightMouseDown", type="flash.events.MouseEvent")]
	[Event(name="rightClick", type="flash.events.MouseEvent")]
	[Event(name="middleMouseUp", type="flash.events.MouseEvent")]
	[Event(name="middleMouseDown", type="flash.events.MouseEvent")]
	[Event(name="middleClick", type="flash.events.MouseEvent")]
	[Event(name="gestureSwipe", type="flash.events.TransformGestureEvent")]
	[Event(name="gestureZoom", type="flash.events.TransformGestureEvent")]
	[Event(name="gestureRotate", type="flash.events.TransformGestureEvent")]
	[Event(name="gesturePressAndTap", type="flash.events.PressAndTapGestureEvent")]
	[Event(name="gesturePan", type="flash.events.TransformGestureEvent")]
	[Event(name="gestureTwoFingerTap", type="flash.events.GestureEvent")]
	[Event(name="touchTap", type="flash.events.TouchEvent")]
	[Event(name="touchRollOver", type="flash.events.TouchEvent")]
	[Event(name="touchRollOut", type="flash.events.TouchEvent")]
	[Event(name="touchOver", type="flash.events.TouchEvent")]
	[Event(name="touchOut", type="flash.events.TouchEvent")]
	[Event(name="touchMove", type="flash.events.TouchEvent")]
	[Event(name="touchEnd", type="flash.events.TouchEvent")]
	[Event(name="touchBegin", type="flash.events.TouchEvent")]
	[Event(name="rollOver", type="flash.events.MouseEvent")]
	[Event(name="rollOut", type="flash.events.MouseEvent")]
	[Event(name="mouseWheel", type="flash.events.MouseEvent")]
	[Event(name="mouseUp", type="flash.events.MouseEvent")]
	[Event(name="mouseOver", type="flash.events.MouseEvent")]
	[Event(name="mouseOut", type="flash.events.MouseEvent")]
	[Event(name="mouseMove", type="flash.events.MouseEvent")]
	[Event(name="mouseDown", type="flash.events.MouseEvent")]
	[Event(name="doubleClick", type="flash.events.MouseEvent")]
	[Event(name="click", type="flash.events.MouseEvent")]
	[Event(name="mouseFocusChange", type="flash.events.FocusEvent")]
	[Event(name="keyFocusChange", type="flash.events.FocusEvent")]
	[Event(name="focusOut", type="flash.events.FocusEvent")]
	[Event(name="focusIn", type="flash.events.FocusEvent")]
	[Event(name="selectAll", type="flash.events.Event")]
	[Event(name="paste", type="flash.events.Event")]
	[Event(name="cut", type="flash.events.Event")]
	[Event(name="copy", type="flash.events.Event")]
	[Event(name="clear", type="flash.events.Event")]
	public dynamic class Outlet extends ObjectProxy implements IEventDispatcher, IOutlet
	{
		private var changedProperties : Object = {};
		private var eventsInterests : Array = [];

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

				if ( value is IEventDispatcher )
				{
					for each( interest in eventsInterests )
					{
						value.addEventListener( interest, dispatcher.dispatchEvent, false, 0, true );
					}
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

		override public function addEventListener( type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false ) : void
		{
			if ( !(type in eventsInterests) )
			{
				eventsInterests.push( type );
				if ( outletObject is IEventDispatcher )
				{
					outletObject.addEventListener( type, dispatcher.dispatchEvent, false, 0, true );
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
					outletObject.removeEventListener( type, dispatcher.dispatchEvent );
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