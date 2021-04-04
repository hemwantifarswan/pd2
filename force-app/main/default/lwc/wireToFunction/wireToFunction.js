import { LightningElement, wire } from 'lwc';
import getBillAmount from '@salesforce/apex/WireHelper.getBillAmount';

export default class WireToFunction extends LightningElement {
    murl='https://www.clipartmax.com/png/middle/217-2176714_mango-free-icon-mango.png';
    altText='Delicious mangoes';
    quantity;   
    payableAmount; 
    error;

    @wire(getBillAmount, { qty: '$quantity'})
    wiredBill({ error, data }) {
        if (data) {
            this.payableAmount = data;
            this.error = undefined;
        } else if (error) {            
            this.error = JSON.stringify(error);
            this.payableAmount = undefined;
        }
    }

    handleSubmit(event){       
        var inputCmp = this.template.querySelector(".quantityInput");
        this.quantity = inputCmp.value;
    }
}