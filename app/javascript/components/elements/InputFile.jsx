import React from 'react';

const Button = (props) => {
    return (
        <input 
            className={props.fileClass}
            required="required" 
            type="file" 
            name={props.name}
            id={props.id} 
            onChange={props.change}
        />
    )
}

export default Button;