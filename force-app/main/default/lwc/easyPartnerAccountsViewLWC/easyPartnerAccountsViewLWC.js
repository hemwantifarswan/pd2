import { LightningElement, track, wire } from 'lwc';
import getPartners from '@salesforce/apex/EasyPartnerAccountsController.getPartners';

export default class EasyPartnerAccountsViewLWC extends LightningElement {
    columns = [
        { label: 'Id', fieldName: 'Id' },
        { label: 'Account Name', fieldName: 'Name', type: 'text' }    
    ];
    accList;
    error;

    @wire(getPartners)
    wiredAccounts({error,data}){
        if(data)
            this.accList = data;
        else if(error)
            this.error = JSON.stringify(error);
    }

    getSelectedName(event) {
        const selectedRows = event.detail.selectedRows;
        // Display that fieldName of the selected rows
        for (let i = 0; i < selectedRows.length; i++){
            alert("You selected: " + selectedRows[i].Name);
        }
    }
}