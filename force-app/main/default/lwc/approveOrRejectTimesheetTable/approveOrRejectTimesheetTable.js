import { LightningElement, api } from 'lwc';

export default class ApproveOrRejectTimesheetTable extends LightningElement {
    @api timesheets;

    selectedTimesheets = []
    enableAccept = true;

    columns = [
        {label : 'Name', fieldName:'Name', type:'text'},
        {label : 'Status', fieldName:'Timesheet_Status__c', type:'text'},
        {label : 'Rejected_Count', fieldName:'Reject_Count__c', type:'text'}
    ];

    handleRowSelection(event){
        let selectedRows = event.detail.selectedRows;
        this.selectedTimesheets = selectedRows;
    }

    get disableButton(){
        if(this.selectedTimesheets.length > 0) {
            this.enableAccept = false;
        }else{
            this.enableAccept = true;        
        }
        return this.enableAccept;
    }

    rejectSelectedTimesheets(){

        let eventPayLoad = {
            timesheets: this.selectedTimesheets
        }

        const rejectTimesheetEvent = new CustomEvent('rejecttimesheets',{
            detail: eventPayLoad
        })

        this.dispatchEvent(rejectTimesheetEvent);
        this.template.querySelector('lightning-datatable').selectedRows = [];
    }

    approveSelectedTimesheets(){
        let eventPayLoad = {
            timesheets: this.selectedTimesheets
        }

        const approveTimesheetEvent = new CustomEvent('approvetimesheets',{
            detail: eventPayLoad
        })

        this.dispatchEvent(approveTimesheetEvent);
        this.template.querySelector('lightning-datatable').selectedRows = [];
    }
}