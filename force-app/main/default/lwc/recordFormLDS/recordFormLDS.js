import { LightningElement, api } from 'lwc';

export default class RecordFormLDS extends LightningElement {
    @api recordId;
    @api objectApiName='Account';
    fields = ['AccountId', 'Name', 'Title', 'Phone', 'Email'];
}