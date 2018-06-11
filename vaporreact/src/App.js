import React, { Component } from 'react';
import './App.css';
import ApiHelper from './ApiHelper.js' // (1)

class App extends Component {

    // (2)
    constructor(props) {
        super(props);
        this.state = {shortform: 'not loaded yet'}
        this.state = {longform: 'not loaded yet'}
        this.state = {creator: 'not loaded yet'}
    }

    componentWillMount() {
        this.getAcronyms(); // (3)
    }

    // (4)
    getAcronyms() {
        ApiHelper.getAllAcronyms().then((result) => {
            this.setState({ shortform: result[0].short})
            this.setState({ longform: result[0].long})
            this.setState({ creator: result[0].creatorID})
            console.log(result);
        }).catch((error) => {
            console.log("error is " + error);
        });
    }



    // (5)
    render() {
        return (
            <div>
                <ul>
                   <h3>Shortform:</h3>
                    <li>{this.state.shortform}</li>
                    <h3>Longform:</h3>
                    <li>{this.state.longform}</li>
                    <h3>CreatorID:</h3>
                    <li>{this.state.creator}</li>
                    <br/>
                </ul>
            </div>
        );
    }
}

export default App;