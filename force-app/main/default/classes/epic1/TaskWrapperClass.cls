public with sharing class TaskWrapperClass {
    public Id taskName;
    public Id employeeName;
    public TaskWrapperClass(Id taskId, Id employeeId) {
        taskName = taskId;
        employeeName = employeeId;
    }

    public Boolean equals(Object obj) {
        if(obj instanceof TaskWrapperClass) {
            TaskWrapperClass pwc = (TaskWrapperClass)obj;
            return ((taskName == pwc.taskName) && (employeeName == pwc.employeeName));
        }
        return false;
    }

    public Integer hashCode() {
        return (2 * String.valueOf(taskName).hashCode()) ^ String.valueOf(employeeName).hashCode();
    }
}
