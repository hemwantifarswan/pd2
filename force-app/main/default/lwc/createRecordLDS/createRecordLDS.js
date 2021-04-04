import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import { reduceErrors } from 'c/ldsUtils';

export default class CreateRecordLDS extends LightningElement {
    accountId;
    name='';
    strPhone='717494407';

    handleNameChange(event){
        this.accountId = undefined;
        this.name = event.target.value;
    }

    createAccount(){
        
        const fields = {'Name' : this.name, 'Phone' : this.strPhone};
        const recordInput = {apiName: 'Account',  fields};
        createRecord(recordInput)
        .then((account) => {
            this.accountId = account.id;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Account created',
                    variant: 'success'
                })
            );
        }).catch((error)=>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: reduceErrors(error).join(', '),
                    variant: 'error'
                })
            );
        });        
    }
}