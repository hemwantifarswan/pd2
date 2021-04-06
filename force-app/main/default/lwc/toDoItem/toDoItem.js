import { api, LightningElement } from 'lwc';
import updateTodo from "@salesforce/apex/ToDoController.updateTodo";
import deleteTodo from "@salesforce/apex/ToDoController.deleteTodo";

export default class ToDoItem extends LightningElement {
    @api todoId;
    @api todoName;
    @api done=false;

    get containerClass(){
        return this.done ? "todoitem completed" : "todoitem upcoming";
    }

    get iconName(){
        return this.done ? "utility:check" : "utility:add";
    }

    updateHandler(){
        const todo = {
            todoId : this.todoId,
            todoName : this.todoName,
            done : !this.done
        }
        updateTodo({payload: JSON.stringify(todo)})
            .then(result => {
                console.log("The item is updated successfully.");
                const updateEvent = new CustomEvent('update');
                this.dispatchEvent(updateEvent); 
            })
            .catch(error => {
                console.error("Error in update: "+JSON.stringify(error)); 
            });

    }

    deleteHandler(){

        deleteTodo({todoId: this.todoId})
            .then(result => {
                console.log("item deleted successfully.");
                const deleteEvent = new CustomEvent('delete');
                this.dispatchEvent(deleteEvent); 
            })
            .catch(error => {
                console.error("Error in delete: "+JSON.stringify(error)); 
            });

    }
}