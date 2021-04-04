import getContactList from '@salesforce/apex/ContactController.getContactList';
import { LightningElement } from 'lwc';

export default class ImperativeApexCall extends LightningElement {
    contacts;
    error;
    
    /* Run Code When a Component Is Created */
    connectedCallback() {
        this.handleLoad();
    }

    handleLoad(){
        getContactList().then((result) => {
            this.contacts = result;
            console.log(JSON.stringify(this.contacts));
            this.error = undefined;
        }).catch((error) => {
            this.error = error;
            this.contacts = undefined
        });
    }
}