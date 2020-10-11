import React from 'react';

import Button from './elements/InputButton';
import InputText from './elements/InputText';

class UserInput extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <div className="searchBlock">

                <InputText 
                    value={this.props.search} 
                    keypress={this.props.keypress}
                    changed={this.props.changed}
                    placeholder="Search here" 
                />

                <Button 
                    value="Search"
                    clicked={this.props.searchClicked}
                />
                
                <Button 
                    value="Clear result"
                    clicked={this.props.resetFilters}
                />

            </div>
        )
    }
}

export default UserInput;