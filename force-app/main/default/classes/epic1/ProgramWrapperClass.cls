public with sharing class ProgramWrapperClass {

    public Id programName;
    public Id employeeName;
    public ProgramWrapperClass(Id programId, Id employeeId) {
        programName = programId;
        employeeName = employeeId;
    }

    public Boolean equals(Object obj) {
        if(obj instanceof ProgramWrapperClass) {
            ProgramWrapperClass pwc = (ProgramWrapperClass)obj;
            return ((programName == pwc.programName) && (employeeName == pwc.employeeName));
        }
        return false;
    }

    public Integer hashCode() {
        return (2 * String.valueOf(programName).hashCode()) ^ String.valueOf(employeeName).hashCode();
    }
}
