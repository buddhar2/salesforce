
global class TaskScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        TaskGenerator.handleTimesheetReminders(insertedTimesheets);
    }
}
