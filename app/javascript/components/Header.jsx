import React from 'react';
import { Link } from 'react-router-dom';

const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

class Header extends React.Component {
    constructor(props) {
        super(props);
    }

    deleteAll = (e) => {
        e.preventDefault();
        fetch('/api/v1/persons', {
            method: 'delete',
            headers: {'X-CSRF-Token': csrfToken }
        })
        .then(() => {
            window.location.href = "/";
        });
    }

    render(){
        return (
            <div className="header"> 
                <Link to="/">
                    <img src="/images/logo.svg" alt="Logo" className="logo"/>
                </Link>
        
                <nav>
                    <Link className="nav-link" to="/">
                        Home
                    </Link>
                    <Link className="nav-link" to="/upload">
                        Upload
                    </Link>
                    <a className="nav-link" href="https://docs.google.com/spreadsheets/d/10c7r-kjdWM4L8kWK0nfE6JgHskzqp7DTF8MkUIo7-_o/edit?usp=sharing" target="_blank">
                        Sample
                    </a>
                    <Link className="nav-link" to="#" onClick={this.deleteAll}>
                        Destroy
                    </Link>
                </nav>
            </div>
        )
    }
}

export default Header;