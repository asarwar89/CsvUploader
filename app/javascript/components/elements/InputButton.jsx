import React from 'react';

const Button = (props) => {
    return (
        <input 
            type="button" 
            value={props.value}
            onClick={props.clicked} 
            className="btn btn-primary mb-3 mb-md-0" 
        />
    )
}

export default Button;