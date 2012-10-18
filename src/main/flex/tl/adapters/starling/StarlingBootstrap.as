package tl.adapters.starling
{

	import tl.core.AbstractBootstrap;
	import tl.ioc.IoCHelper;
	import tl.adapters.IViewContainerAdapter;
	import tl.view.IView;

	[Frame(factoryClass="tl.adapters.starling.StarlingApplicationLoader")]
	public class StarlingBootstrap extends AbstractBootstrap
	{
		{
			IoCHelper.registerType( IViewContainerAdapter, StarlingViewContainerAdapter );
		}

		public function get starlingApplicationView() : IView
		{
			return applicationView;
		}

		public function StarlingBootstrap()
		{
		}
	}
}
