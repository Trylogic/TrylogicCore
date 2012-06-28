package tl.starling.view
{

	import starling.display.*;

	public class StarlingViewContainer extends StarlingView
	{
		protected var controllerContainer : Sprite;

		public function StarlingViewContainer()
		{

		}

		public function get container() : DisplayObjectContainer
		{
			if ( controllerContainer == null )
			{
				controllerContainer = new Sprite();
				addChildAt( controllerContainer, 0 );
			}
			return controllerContainer;
		}

		override internal function internalDestroy() : void
		{
			super.internalDestroy();
			if ( controllerContainer && controllerContainer.parent != null )
			{
				controllerContainer.parent.removeChild( controllerContainer );
			}
			controllerContainer = null;
		}
	}
}
