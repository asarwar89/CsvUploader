import React from 'react';

const InputText = (props) => {
    return (
        <input 
            type="text" 
            value={props.value} 
            onKeyPress={props.keypress} 
            onChange={props.changed} 
            placeholder={props.placeholder} 
        />
    )
}

export default InputText;