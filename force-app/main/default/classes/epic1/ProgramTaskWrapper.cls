public with sharing class ProgramTaskWrapper {
    public Id taskName;
    public Id programName;
    public TaskWrapperClass(Id taskId, Id programId) {
        taskName = taskId;
        programName = programId;
    }

    public Boolean equals(Object obj) {
        if(obj instanceof TaskWrapperClass) {
            TaskWrapperClass pwc = (TaskWrapperClass)obj;
            return ((taskName == pwc.taskName) && (programName == pwc.programName));
        }
        return false;
    }

    public Integer hashCode() {
        return (2 * String.valueOf(taskName).hashCode()) ^ String.valueOf(programName).hashCode();
    }
}
