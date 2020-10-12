import React from 'react';

const TableHead = (props) => {
    return (
        <tr>
            <th onClick={ () => props.handleOrder("firstname") }>
                First Name <i className='fas fa-sort'></i>
            </th>
            <th onClick={ () => props.handleOrder("lastname") }>
                Last Name <i className='fas fa-sort'></i>
            </th>
            <th onClick={ () => props.handleOrder("species") }>
                Species <i className='fas fa-sort'></i>
            </th>
            <th onClick={ () => props.handleOrder("gender") }>
                Gender <i className='fas fa-sort'></i>
            </th>
            <th onClick={ () => props.handleOrder("weapon") }>
                Weapon <i className='fas fa-sort'></i>
            </th>
            <th onClick={ () => props.handleOrder("vehicle") }>
                Vehicle <i className='fas fa-sort'></i>
            </th>
            <th onClick={ () => props.handleOrder("affiliations.title") }>
                Affiliations <i className='fas fa-sort'></i>
            </th>
            <th onClick={ () => props.handleOrder("locations.name") }>
                Locations <i className='fas fa-sort'></i>
            </th>
        </tr>
    )
}

export default TableHead;