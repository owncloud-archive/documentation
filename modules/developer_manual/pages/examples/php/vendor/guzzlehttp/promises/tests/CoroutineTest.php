<?php
namespace GuzzleHttp\Promise\Tests;

use GuzzleHttp\Promise\Coroutine;
use GuzzleHttp\Promise\PromiseInterface;
use PHPUnit_Framework_TestCase;
use ReflectionClass;

class CoroutineTest extends PHPUnit_Framework_TestCase
{
    /**
     * @dataProvider promiseInterfaceMethodProvider
     *
     * @param string $method
     * @param array $args
     */
    public function testShouldProxyPromiseMethodsToResultPromise($method, $args = [])
    {
        $coroutine = new Coroutine(function () { yield 0; });
        $mockPromise = $this->getMockForAbstractClass(PromiseInterface::class);
        call_user_func_array([$mockPromise->expects($this->once())->method($method), 'with'], $args);

        $resultPromiseProp = (new ReflectionClass(Coroutine::class))->getProperty('result');
        $resultPromiseProp->setAccessible(true);
        $resultPromiseProp->setValue($coroutine, $mockPromise);

        call_user_func_array([$coroutine, $method], $args);
    }

    public function promiseInterfaceMethodProvider()
    {
        return [
            ['then', [null, null]],
            ['otherwise', [function () {}]],
            ['wait', [true]],
            ['getState', []],
            ['resolve', [null]],
            ['reject', [null]],
        ];
    }

    public function testShouldCancelResultPromiseAndOutsideCurrentPromise()
    {
        $coroutine = new Coroutine(function () { yield 0; });

        $mockPromises = [
            'result' => $this->getMockForAbstractClass(PromiseInterface::class),
            'currentPromise' => $this->getMockForAbstractClass(PromiseInterface::class),
        ];
        foreach ($mockPromises as $propName => $mockPromise) {
            /**
             * @var $mockPromise \PHPUnit_Framework_MockObject_MockObject
             */
            $mockPromise->expects($this->once())
                ->method('cancel')
                ->with();

            $promiseProp = (new ReflectionClass(Coroutine::class))->getProperty($propName);
            $promiseProp->setAccessible(true);
            $promiseProp->setValue($coroutine, $mockPromise);
        }

        $coroutine->cancel();
    }
}
