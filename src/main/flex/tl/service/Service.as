package tl.service
{

	public class Service implements IService
	{
		protected namespace lifecycle = "http://www.trylogic.ru/service/lifecycle";

		protected var serviceInitialized : Boolean = false;

		public function get initialized() : Boolean
		{
			return serviceInitialized;
		}

		public function Service()
		{

		}

		public final function init() : void
		{
			lifecycle::init();
			serviceInitialized = true;
		}

		lifecycle function init() : void
		{
		}
	}
}
