package mindmaps2.elements.task.queries {

    import collections.TreeCollectionEx;

    import commonutils.NumberUtil;

    import vos.Task;

    public class TaskTimeAndPriorityTimeRatioCalculator {
        public const defaultTime:Number = 0.1;
        public const decimalDigitPrecision:uint = 3;
        private const roundingMultiplier:int = Math.pow(10, decimalDigitPrecision);

        public function calculate(taskRoot:TreeCollectionEx):TreeCollectionEx {

            var task:Task = Task(taskRoot.vo);
            if (!NumberUtil.isNaNOrZero(task.estimatedHours)) {
                task.time = task.estimatedHours;
            } else if (taskRoot.isLeaf()) { //use estimated hours for leaf nodes
                task.time = defaultTime;
            } else { //use estimated hours of child nodes, ignore non-leaf estimated hours
                task.time = 0;
                for each (var childNode:TreeCollectionEx in taskRoot.children) {
                    var calculatedChildNode:TreeCollectionEx = calculate(childNode);
                    var calculatedChildTask:Task = Task(calculatedChildNode.vo);
                    task.time += calculatedChildTask.time;
                }
            }

            task.ptRatio = Math.round(task.priority * roundingMultiplier / task.time) / roundingMultiplier; //round to 3 decimal point digits
            return taskRoot;
        }
    }
}
