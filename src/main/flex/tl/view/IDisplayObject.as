package tl.view
{

	public interface IDisplayObject
	{
		function get x() : Number;

		function set x( value : Number ) : void;

		function get y() : Number;

		function set y( value : Number ) : void;

		function get width() : Number;

		function set width( value : Number ) : void;

		function get height() : Number;

		function set height( value : Number ) : void;

		function get scaleX() : Number;

		function set scaleX( value : Number ) : void;

		function get scaleY() : Number;

		function set scaleY( value : Number ) : void;

		function get alpha() : Number;

		function set alpha( value : Number ) : void;

		function get visible() : Boolean;

		function set visible( value : Boolean ) : void;
	}
}
