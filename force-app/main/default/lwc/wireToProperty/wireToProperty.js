import { LightningElement, wire } from 'lwc';
import checkLeapYear from '@salesforce/apex/WireHelper.checkLeapYear';

export default class WireToProperty extends LightningElement {

    year;

    @wire(checkLeapYear, {year: '$year'})
    response;

    handleSubmit(event){

        var inputCmp = this.template.querySelector(".yearInput");
        this.year = inputCmp.value;
        console.log(`Year: ${this.year}`);

    }
}