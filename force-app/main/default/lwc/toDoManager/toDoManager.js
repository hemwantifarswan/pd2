import { LightningElement, track } from 'lwc';
import addToDo from '@salesforce/apex/ToDoController.addTodo';
import getCurrentTodos from '@salesforce/apex/ToDoController.getCurrentTodos'

export default class ToDoManager extends LightningElement {
    time="8:15 PM";
    greeting = "Good Evening";

    @track todos = [];

    connectedCallback(){
        this.getTime();
        //this.populateTodos();
        this.fetchTodos();
        setInterval(()=>{
            this.getTime();
        },1000);
    }

    getTime(){
        const date = new Date();
        const hour = date.getHours();
        const min = date.getMinutes();

        this.time = `${this.getHour(hour)}: ${this.getDoubleDigit(min)} ${this.getMidDay(hour)}`;
        this.setGreeting(hour);
    }
    getHour(hour){
        return hour === 0 ? 12 : hour > 12 ? hour - 12 : hour;
    }
    getMidDay(hour){
        return hour >= 12 ? "PM": "AM";
    }
    getDoubleDigit(digit){
        return digit < 10 ? "0"+digit : digit;
    }

    setGreeting(hour){
        if(hour < 12){
            this.greeting = "Good Morning";
        }else if(hour >= 12 && hour < 17){
            this.greeting = "Good Afternoon";
        }else {
            this.greeting = "Good Eevening";
        }
    }
    addTodoHandler(){
        const inputBox = this.template.querySelector("lightning-input");
        
        const todo = {
            todoName : inputBox.value,
            done : false
        }
        addToDo({payload: JSON.stringify(todo)})
        .then(response => {
            console.log("Item inserted successfully");
            this.fetchTodos();
        }).catch(error => {
            console.error("Error in inserting todo item: "+error);
        });
        //this.todos.push(todo);
        inputBox.value = "";
    }
    get upcomingTasks(){
        return this.todos && this.todos.length 
                ? this.todos.filter(todo => !todo.done) 
                : []
    }
    get completedTasks(){
        return this.todos && this.todos.length 
                ? this.todos.filter(todo => todo.done) 
                : []
    }

    fetchTodos(){
        getCurrentTodos()
            .then(result => {
                if(result){
                    console.log('Retrieved todos from server ', result.length);
                    this.todos = result;
                }
            })
            .catch(error => {
                console.error("Error in fetching todo items: "+JSON.stringify(error));                
            });
    }
    populateTodos(){
        const todos = [
            {
                todoId: 0,
                todoName: "Feed the dog",
                done: false,
                todoData: new Date()
            },
            {
                todoId: 1,
                todoName: "Wash the car",
                done: false,
                todoData: new Date()
            },
            {
                todoId: 2,
                todoName: "Send email to manager",
                done: true,
                todoData: new Date()
            }

        ];
        this.todos = todos;
    }

    updateHandler(){
        this.fetchTodos();
    }

    deleteHandler(){
        this.fetchTodos();
    }
}