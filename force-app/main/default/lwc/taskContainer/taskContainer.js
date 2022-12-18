import { LightningElement, api, wire } from 'lwc';
import getSuggestedTasks from '@salesforce/apex/AssignProgramTasksContainer.getSuggestedTasks';
import getOtherTasks from '@salesforce/apex/AssignProgramTasksContainer.getOtherTasks';
import addMultipleProgramTasks from '@salesforce/apex/AssignProgramTasksContainer.addMultipleProgramTasks';
import addProgramTask from '@salesforce/apex/AssignProgramTasksContainer.addProgramTask';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import CATEGORY_FIELD from '@salesforce/schema/Program__c.Category__c';

const fields = [CATEGORY_FIELD];

export default class TaskContainer extends LightningElement {

    @api recordId;
    createTask = false;
    showSuggestedTask = true;
    showOtherTask = false;
    selectedSuggestedTaskList = [];
    selectedOtherTaskList = [];
    tasks;
    otherTasks;
    suggestedTaskListResult;
    taskId;

    columns = [
        {label: 'Task Name', fieldName:'Name', type:'text'},
        {label: 'LOE(In Days)', fieldName:'Effort_In_Days__c', type:'text'},
        {label: 'Description', fieldName:'Description__c', type:'text'},
        {label: 'Category', fieldName:'Category__c', type:'text'},
        {label: 'Task URL', fieldName:'Task_URL__c', type:'url'},
    ];

    @wire(getRecord, { recordId: '$recordId', fields })
    program;

    @wire(getSuggestedTasks,{ programId : '$recordId'})
    taskList(result){
        this.suggestedTaskListResult = result;
        if(result.data){
            this.tasks = result.data;
        }else if(result.error){
            this.tasks = undefined;
        }
    }

    @wire(getOtherTasks,{programId : '$recordId'})
    otherList(result){
        this.otherTaskListResult = result;
        if(result.data){
            this.otherTasks = result.data;
        }else if(result.error){
            this.otherTasks = undefined;
        }
    }
    
    get category() {
        return getFieldValue(this.program.data, CATEGORY_FIELD);
    }

    handleSuggestedRows(event){
        let selectedRows = event.detail.selectedRows;
        this.selectedSuggestedTaskList = selectedRows;
        console.log(JSON.parse(JSON.stringify(this.selectedSuggestedTaskList)));
    }

    get isSuggestedButtonDisabled() {
        return this.selectedSuggestedTaskList.length === 0;
    }

    addSuggestedRecords() {
        addMultipleProgramTasks({selectedTaskIds:this.selectedSuggestedTaskList, programId : this.recordId})
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Tasks are added Successfully',
                    variant: 'success',
                }),
            );
            this.template.querySelector('lightning-datatable').selectedRows = [];
            return refreshApex(this.suggestedTaskListResult);
        })
        .catch(error => {
            this.message = undefined;
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error adding tasks',
                    message: 'Some error',
                    variant: 'error',
                }),
            );
        });
    }

    handleOtherRows(event){
        let selectedRows = event.detail.selectedRows;
        this.selectedOtherTaskList = selectedRows;
        console.log(JSON.parse(JSON.stringify(this.selectedOtherTaskList)));
    }

    get isOtherButtonDisabled() {
        return this.selectedOtherTaskList.length === 0;
    }

    addOtherRecords() {
        addMultipleProgramTasks({selectedTaskIds:this.selectedOtherTaskList, programId : this.recordId})
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Tasks are added Successfully',
                    variant: 'success',
                }),
            );
            this.template.querySelector('lightning-datatable').selectedRows = [];
            return refreshApex(this.otherTaskListResult);
        })
        .catch(error => {
            this.message = undefined;
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error adding tasks',
                    message: 'Some error',
                    variant: 'error',
                }),
            );
        });
    }

    handleSave(event){
        this.taskId = event.detail.id;
        addProgramTask({ taskId: this.taskId, programId : this.recordId})
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Task created!',
                    variant: 'success'
                }),
            );
            const inputFields = this.template.querySelectorAll(
                'lightning-input-field'
            );
            if (inputFields) {
                inputFields.forEach(field => {
                    field.reset();
                });
            }
            return refreshApex(this.suggestedTaskListResult);
        })
        .catch(error => {
            this.message = undefined;
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error adding Program task',
                    message: 'Some error',
                    variant: 'error',
                }),
            );
        });
    }

    allowReset(event) {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }

    toggleCreateTask() {
        this.createTask = !this.createTask;
    }

    toggleShowTasks() {
        this.showSuggestedTask = !this.showSuggestedTask;
        return refreshApex(this.suggestedTaskListResult);
    }

    toggleOtherTasks() {
        this.showOtherTask = !this.showOtherTask;
        return refreshApex(this.otherTaskListResult);
    }
}