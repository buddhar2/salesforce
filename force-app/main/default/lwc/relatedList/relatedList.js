import { LightningElement, api, wire } from 'lwc'; 
import fetchRecords from '@salesforce/apex/RelatedListController.fetchRecords';
import { refreshApex } from '@salesforce/apex';  
  
export default class RelatedList extends LightningElement {  
  
    @api objectName;  
    @api fieldName;  
    @api fieldValue;  
    @api parentFieldAPIName;  
    @api recordId;  
    @api strTitle;  
    @api filterType;  
    @api operator;
    @api layout;
    @api columns;  
    get vals() {  
        return this.recordId + '@' + this.objectName + '@' +   
               this.parentFieldAPIName + '@' + this.fieldName + '@' +   
               this.fieldValue + '@' + this.filterType + '@' + this.operator;  
    }  

    connectedCallback(){
        console.log(this.vals);
    }
      
    @wire(fetchRecords, { listValues: '$vals' })  
    records;  

    refreshComponent(){
        console.log(this.records);
        return refreshApex(this.records);
    }
}  