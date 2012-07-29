package tl.adapters.nativeDisplayList
{

	import tl.core.*;
	import tl.ioc.IoCHelper;
	import tl.view.IViewContainerAdapter;

	public class NativeBootstrap extends AbstractBootstrap
	{
		{
			IoCHelper.registerType( IViewContainerAdapter, NativeViewContainerAdapter );
		}

		public function NativeBootstrap()
		{
		}

		override public function init( applicationLoader : TrylogicApplicationLoader ) : void
		{
			super.init( applicationLoader );

			applicationView.controller.addViewToContainer( (applicationLoader.addChild( IoCHelper.resolve( IViewContainerAdapter ) ) as IViewContainerAdapter ) );
		}
	}
}
