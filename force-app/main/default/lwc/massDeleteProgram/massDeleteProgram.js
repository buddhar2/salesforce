import { LightningElement, api, wire  } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getProgramAssignments from '@salesforce/apex/AssignProgramToContacts.getProgramAssignments';
import deleteProgramAssignments from '@salesforce/apex/AssignProgramToContacts.deleteProgramAssignments';

export default class MassDeleteProgram extends LightningElement {
    @api recordId;
    contacts;
    selectedEmployeeList = [];
    employeeListResult;
    columns = [
        {label: 'Employee Name', fieldName:'Name', type:'text'},
        {label: 'Title', fieldName:'Title', type:'text'}
    ];

    @wire(getProgramAssignments,{ programId : '$recordId'})
    employeeList(result){
        this.employeeListResult = result;
        if(result.data){
                let tempRecords = JSON.parse( JSON.stringify( result.data ) );
                tempRecords = tempRecords.map(row=>{
                    return{...row, Name: row.Employee__r.Name, Title: row.Employee__r.Title}
                });
            this.contacts = tempRecords;
            this.error = undefined;
        }else if(result.error){
            this.contacts = undefined;
            this.error = error;
        }
    }

    get isButtonDisabled() {
        return this.selectedEmployeeList.length === 0;
    }

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleRowSelection(event){
        let selectedRows = event.detail.selectedRows;
        this.selectedEmployeeList = selectedRows;
    }

    deleteAssignments(){
        deleteProgramAssignments({selectedAssignments:this.selectedEmployeeList})
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Program is un assigned from the employee',
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

    updateRecordView() {
        setTimeout(() => {
             eval("$A.get('e.force:refreshView').fire();");
        }, 1000); 
     }
}