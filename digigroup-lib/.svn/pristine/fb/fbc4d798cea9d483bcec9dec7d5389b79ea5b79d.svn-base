/*
 Copyright (c) 2007 Eric J. Feminella  <eric@ericfeminella.com>
 All rights reserved.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 @internal
 */

package commonutils
{
    import flash.utils.getTimer;

    /**
     *
     * Convenience class which provides a simple API whereby
     * a specific code execution duration can be measured for
     * calculating relative time in milliseconds
     *
     * <p>
     * Determines the number of milliseconds which have elapsed
     * for a specific code block, method or asynchronous
     * service invocation execution
     * </p>
     *
     * <p>
     * The following demonstrate a few common use-case examples
     * of the <code>Execution</code> API.
     * </p>
     *
     * <p>
     * The first example demonstrates how <code>Execution</code>
     * can be utilized for calculating the duration of a specific
     * for loop execution
     * </p>
     *
     * @example
     * <listing version="3.0">
     *
     * var execution:IExecutable = Execution.createExecution();
     *
     * for (var i:int = 0; i < 10000; i++)
     * {
     *    trace( execution.elapsedTime() );
     * }
     *
     * trace( execution.getExecutionDuration() );
     *
     * </listing>
     *
     * <p>
     * The next example demonstrates how <code>Execution</code>
     * can be utilizes for calculating the duration of an
     * asynchronous service invocation. The example calls
     * an <code>HTTPService</code> with an id of "service"
     * and calculates the execution time of the call.
     * </p>
     *
     * @example
     * <listing version="3.0">
     *
     * var execution:IExecutable;
     *
     * service.addEventListener("invoke", monitor);
     * service.result = this.result;
     * service.send();
     *
     * private function monitor(evt:Event) : void
     * {
     *    execution = Execution.createExecution();
     * }
     *
     * private function result(data:Object) : void
     * {
     *    trace( execution.getExecutionDuration() );
     * }
     *
     * </listing>
     *
     * @see flash.utils.getTimer
     * @see IExecution
     *
     */
    public class ExecutionTimer// implements IExecutable
    {
        /**
         *
         * Defines the value of an execution start time which is
         * used to determine the elapsed code execution duration
         *
         */
        protected var executionStartTime:int;

        /**
         *
         * Defines the value of an execution stop time which is
         * used to determine the elapsed code execution duration
         *
         */
        protected var executionStopTime:int;

        /**
         *
         * Creates a new instance of Execution from which a code
         * execution duration can be measured
         *
         * <p>
         * The following example demonstrates the most basic and
         * typical use of a concrete IExecutable implementation.
         * </p>
         *
         * @example
         * <listing version="3.0">
         *
         * var execution:IExecutable = new ExecutionDuration();
         * execution.start();
         *
         * for (var i:int = 0; i < 10000; i++)
         * {
         *    trace( execution.elapsedTime() );
         * }
         *
         * trace( execution.elapsedTime() );
         *
         * </listing>
         *
         */
        public function ExecutionTimer(autoStart:Boolean = false)
        {
            if ( autoStart )
            {
               start();
            }
        }

        /**
         *
         * Static factory method which defers instantiation of the
         * concrete <code>IExecutable</code> implementation to the
         * class object and sets the autoStart parameter to true by
         * default as is typical of most <code>Execution</code>
         * implementations
         *
         * @example
         * <listing version="3.0">
         *
         * var execution:IExecutable = ExecutionDuration.createExecution();
         *
         * someMethod();
         *
         * trace( execution.getExecutionDuration() );
         *
         * </listing>
         *
         * @return a newly created Execution object instance
         *
         */
        public static function createExecution() : ExecutionTimer
        {
            return new ExecutionTimer( true );
        }

        /**
         *
         * Starts the current execution measurements and sets the
         * value of the <code>executionStartTime</code> property
         * to the value of the current getTimer(); Flash Player
         * call
         *
         * @example
         * <listing version="3.0">
         *
         * var execution:IExecutable = new ExecutionDuration( true );
         *
         * someMethod();
         *
         * trace( execution.getExecutionDuration() );
         *
         * </listing>
         *
         * @return an integer representing the start time
         *
         */
        public function start() : int
        {
            return executionStartTime = getTimer();
        }

        /**
         *
         * Stops the current execution measurements and sets the
         * value of the <code>executionStopTime</code> property
         * to the value of the current getTimer(); Flash Player
         * call
         *
         * @example
         * <listing version="3.0">
         *
         * var execution:IExecutable = new ExecutionDuration( true );
         *
         * if ( someMethod() == null )
         * {
         *     execution.stop();
         *     trace( execution.getExecutionDuration() );
         * }
         * else
         * {
         *     someOtherMethod()
         * }
         *
         * trace( execution.getExecutionDuration() );
         *
         * </listing>
         *
         * @return an integer representing the stop time
         *
         */
        public function stop() : int
        {
            return executionStopTime = getTimer();
        }

        /**
         *
         * Retrieves the initial start time for the current
         * <code>Execution</code> instance
         *
         * @return the start time in milliseconds
         *
         */
        public function get startTime() : int
        {
            return executionStartTime;
        }

        /**
         *
         * Retrieves the initial start time for the current
         * <code>Execution</code> instance
         *
         * @return the start time in milliseconds
         *
         */
         public function get stopTime() : int
         {
             return executionStopTime;
         }

        /**
         *
         * Retrieves the total execution measurement based on the
         * current <code>executionStartTime</code> and the current
         * <code>executionStopTime</code>
         *
         * @example
         * <listing version="3.0">
         *
         * var execution:IExecutable = new ExecutionDuration();
         * execution.start();
         *
         * for (var prop:String in someObject)
         * {
         *    trace( prop + "=" + someObject[prop])
         * }
         *
         * trace( execution.elapsedTime() );
         *
         * </listing>
         *
         * @return integer representing the total execution duration
         *
         */
        public function get elapsedTime() : int
        {
            return stop() - executionStartTime;
        }

        /**
         *
         * Determines the total time (in milliseconds) which
         * has elapsed for a specific <code>Execution</code>
         *
         * <p>
         * Calls to <code>getExecutionResults</code> finalizes
         * a <code>Execution</code> instance, that is, when a
         * call to <code>getExecutionResults</code> is made
         * the execution object immediately stops calculating
         * the <code>getElapsedTime</code>. Therefore by calling
         * <code>getExecutionResults</code> it is implied that
         * the execution instance has completed
         * </p>
         *
         * <p>
         * Use this operation when the code you are monitoring
         * has completed
         * </p>
         *
         * @example
         * <listing version="3.0">
         *
         * var execution:IExecutable = new ExecutionDuration( true );
         *
         * someMethod();
         *
         * trace( execution.getExecutionDuration() );
         *
         * </listing>
         *
         * @return the total execution time in milliseconds
         *
         */
        public function getExecutionResults() : int
        {
            var elapsedDuration:int = ( stop() - executionStartTime );

            return elapsedDuration;
        }

        /**
         *
         * Resets the <code>Execution</code> instance by reassigning
         * a new value to the <code>executionStartTime</code> to the
         * current <code>getTimer()</code>
         *
         * <p>
         * This method allows a single <code>Execution</code> instance
         * to be resused and should be utilized as an alternative to
         * creating new <code>Execution</code> objects
         * </p>
         *
         * @example
         * <listing version="3.0">
         *
         * var execution:IExecutable = new ExecutionDuration( true );
         *
         * someMethod();
         *
         * trace( execution.getExecutionDuration() );
         *
         * // reset the execution instance for determining the execution
         * // duration of another operation
         * execution.reset();
         *
         * someotherMethod();
         *
         * trace( execution.getExecutionDuration() );
         * </listing>
         *
         */
        public function reset() : void
        {
            this.executionStartTime = getTimer();
        }
    }
}

