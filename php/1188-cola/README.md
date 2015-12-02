#Cola IoC

## 容器
Cola类继承了一个IoC容器，可以在bootstrap阶段把需要用到的类绑定到该容器，以便重用。以下介绍具体用法。容器可以为类名以字符串形式，或者闭包形式绑定，所以绑定不是立刻new一个实例，而是在需要解析的时候才产生或者直接从容器中取出已经存在的实例。
容器可以通过以下方法获得：

	$app = Cola::getInstance()


##绑定接口：

- 这两种绑定相同，在$app->make()的时候，都返回一个新的实例
	
		$app->bind('App\DAO\UserDAO',function(){
			return new UserDAOImpl();
		});
		
		$app->bind('App\DAO\UserDAO','App\DAO\Impl\UserDAOImpl');

- bind还可以设置alias，如下，第一个参数传入数组，key为别名，value为接口名


		$app->bind(['dao.user' => 'App\DAO\UserDAO'],'App\DAO\Impl\UserDAOImpl');


- 第三个参数为true就是singleton的效果一样
 
		$app->bind(['dao.user' => 'App\DAO\UserDAO'],'App\DAO\Impl\UserDAOImpl', true);

		$app->singleton(['dao.user' => 'App\DAO\UserDAO'],'App\DAO\Impl\UserDAOImpl');

- 绑定实例
		$app->instance('App\DAO\UserDAO', $userDAO)

- Controller的方法默认可以使用IoC

	 	public function showMoneyAction(MoneyRepository $money)

- 任意方法都可以使用IoC

例如有以下一个类

		class ThingDoer
		{
		    public function doThing($thing_key, ThingRepository $repository)
		    {
		        $thing = $repository->getThing($thing_key);
		        $thing->do();
		    }
		}
$app->call()方法可以为某个类的某个方法使用IoC, 第二个数组参数是传入doThing方法参数

		$app->call(
            [$thingDoer, 'doThing'],
            ['thing_key' => 'awesome-parameter-here']
        );

## 解析实例
因为容器实现了ArrayAccess接口，所以可以直接用下标取其中实例，例如：

	$app = Cola::getInstance()['app'];

或者使用make方法：
	
	$app->make('App\DAO\UserDAO');
	$app->make('App\DAO\UserDAO\UserDAOImpl');


## Controller例子
	
	class IndexController extends BaseController
	{
	    public $app;
	    public function __construct(\Illuminate\Container\Container $app){
	        $this->app = $app;
			parent::__contruct();
	    }
	
	    public function indexAction(\Illuminate\Container\Container $app){
	
	        //$app = Cola::getInstance()['app'];
	        //$userDAO = Cola::getInstance()['userDAO'];
	        die(var_dump($app));
	
	        $this->display();
	    }
	}

其中\Illuminate\Container\Container $app 可以正常传入。需要注意的是，不能忘记 `parent::__contruct();` ，因为父类包含了view路径的设置。

# Service Provider

目的是把一组功能相关的类在初始阶段

	$cola = Cola::getInstance();
	// 注册服务组件。
	$cola->register('C18\Providers\AppServiceProvider');

在入口文件 `sites/wwwroot/index.php`  中注册需要的服务。
服务文件：

	class AppServiceProvider extends ServiceProvider {
	
	    /**
	     * Register the service provider.
	     *
	     * @return void
	     */
	    public function register()
	    {
	        $this->app->bind('userDAO', 'C18\DAO\UserDAO', true);
	    }
	}

实现register方法即可。
ServiceProvider 有一个属性 `$app`, 就是Cola容器本身，可以从中取其他需要的实例。

#效率

脚本执行等待时间几乎和没加IoC之前一样。