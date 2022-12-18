import { LightningElement, api, wire, track } from 'lwc';
import getRelatedTimesheets from '@salesforce/apex/TimesheetApprovalController.getRelatedTimesheets';
import rejectTimesheets from '@salesforce/apex/TimesheetApprovalController.rejectTimesheets';
import approveTimesheets from '@salesforce/apex/TimesheetApprovalController.approveTimesheets';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ApproveOrRejectTimesheetContainer extends LightningElement {

    @api recordId;
    timesheets;
    timesheetResult;
    @wire(getRelatedTimesheets,{ projectId : '$recordId'})
    timesheetList(result){
        this.timesheetResult = result;
        if(result.data){
            this.timesheets = result.data;
        }else if(result.error){
            this.timesheets = undefined;
        }
    }

    handleRejectTimesheets(event) {
        let timesheetsToBeRejected = event.detail.timesheets;

        rejectTimesheets({timesheets :timesheetsToBeRejected })
        .then(apexResponse =>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Selected Timesheets are rejected',
                    variant: 'success',
                }),
            );
            return refreshApex(this.timesheetResult);
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Rejecting',
                    message: error.body.pageErrors[0].message,
                    variant: 'error',
                }),
            );
        })
    }

    handleApproveTimesheets(event) {
        let timesheetsToBeApproved = event.detail.timesheets;

        approveTimesheets({timesheets :timesheetsToBeApproved })
        .then(apexResponse =>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Selected Timesheets are approved',
                    variant: 'success',
                }),
            );
            //this.template.querySelector('lightning-datatable').selectedRows = [];
            return refreshApex(this.timesheetResult);
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Rejecting',
                    message: error.body.pageErrors[0].message,
                    variant: 'error',
                }),
            );
        })
    }
}