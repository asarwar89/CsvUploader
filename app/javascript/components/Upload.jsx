import React from "react";

import UserFile from './elements/InputFile';
import Button from './elements/InputButton';

const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

class Persons extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            file: null
        }
    }

    onChange = (e) => {
        this.setState({file:e.target.files[0]})
    }

    handleSubmit = () => {

        if (this.state.file) {

            var data = new FormData()
            data.append('file', this.state.file)

            fetch('/api/v1/persons/create', {
                method: 'post',
                headers: {'X-CSRF-Token': csrfToken },
                body: data
            })
            .then(() => {
                this.props.history.push('/');
            });
        }
    }
    
    render() {

        return (
            <div className="main">

                <h1>Data uploader</h1>

                <p>Select a CSV file to upload data</p>

                <div className="form-group">
                    <label className="file-upload">
                        <UserFile 
                            fileClass="form-control-file"
                            name="person[file]"
                            id="person_file"
                            change={this.onChange}
                        />
                        <span>Choose file</span>
                    </label>
                </div>
                <p>
                    <Button 
                        value="Upload file"
                        clicked={this.handleSubmit}
                    />
                </p>

            </div>
        );
    }

}
export default Persons;