import { LightningElement, api, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getContactList from '@salesforce/apex/AssignProgramToContacts.getContactList';
import assignToMultipleContacts from '@salesforce/apex/AssignProgramToContacts.assignToMultipleContacts'

export default class MassAssignProgram extends LightningElement {

    @api recordId;
    contacts;
    selectedEmployeeList = [];
    employeeListResult;
    columns = [
        {label: 'Employee Name', fieldName:'Name', type:'text'},
        {label: 'Title', fieldName:'Title', type:'text'}
    ];

    @wire(getContactList,{ programId : '$recordId'})
    employeeList(result){
        this.employeeListResult = result;
        if(result.data){
            this.contacts = result.data;
            this.error = undefined;
        }else if(result.error){
            this.contacts = undefined;
            this.error = error;
        }
    }

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleRowSelection(event){
        let selectedRows = event.detail.selectedRows;
        this.selectedEmployeeList = selectedRows;      
    }

    addProgramAssignments(){
        assignToMultipleContacts({selectedContactList:this.selectedEmployeeList, programId : this.recordId})
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Program is assigned to the contacts',
                    variant: 'success',
                }),
            );
            this.updateRecordView();
            this.template.querySelector('lightning-datatable').selectedRows = [];
            return refreshApex(this.employeeListResult);
        })
        .catch(error => {
            this.message = undefined;
            this.error = error;
            console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error assigning programs',
                    message: error.body,
                    variant: 'error',
                }),
            );
        });
    }

    get isButtonDisabled() {
        return this.selectedEmployeeList.length === 0;
    }

    updateRecordView() {
        setTimeout(() => {
             eval("$A.get('e.force:refreshView').fire();");
        }, 1000); 
     }

}