import React from 'react';

const TableRow = (props) => {
    return (
        <tr key={props.index}>
            <td>{props.person.firstname}</td>
            <td>{props.person.lastname}</td>
            <td>{props.person.species}</td>
            <td>{props.person.gender}</td>
            <td>{props.person.weapon}</td>
            <td>{props.person.vehicle}</td>
            <td>{props.person.locations.map(location => <p key={props.person.id + location.id}>{ location.name }</p>)}</td>
            <td>{props.person.affiliations.map(affiliation => <p key={props.person.id + affiliation.id}>{ affiliation.title }</p>)}</td>
        </tr>
    )
}

export default TableRow;