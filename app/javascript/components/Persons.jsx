import React from "react";
import { Link } from "react-router-dom";
import ReactPaginate from 'react-paginate';

import UserInput from './UserInput';

class Persons extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            persons: [],
            currentPage: 1,
            pageCount: 1,
            search: "",
            ordering: {
                orderBy: "",
                order: ""
            },

        };
    }

    componentDidMount() {
        this.fetchData();
    }

    handlePageClick(data) {

        this.setState({ currentPage: data.selected + 1 }, () => {
            this.fetchData();
        });
        
    };

    fetchData() {

        const url = this.processURL();

        fetch(url)
        .then(response => {
          if (response.ok) {
            return response.json();
          }
          throw new Error("Network response was not ok.");
        })
        .then(response => {
            this.setState({ 
                persons: response.persons,
                currentPage: response.page,
                pageCount: response.page_count 
            })
        })
        .catch((e) => console.log(e));
    }

    processURL(){
        const ordering = this.state.ordering;
        let url = `/api/v1/persons/index?page=${this.state.currentPage}`;

        if (this.state.search) {
            url += `&searchfor=${this.state.search}`
        }
        
        if (ordering.orderBy) {
            url += `&orderby=${ordering.orderBy}&order=${ordering.order}`
        }

        console.log(url)

        return url
    }

    handleOrdering(orderBy) {

        let ordering = this.state.ordering;

        if (ordering.orderBy === orderBy) {
            if (ordering.order) {
                ordering.order = "";
            } else {
                ordering.order = "desc";
            }
        } else {
            ordering.orderBy = orderBy;
            ordering.order = "";
        }

        this.setState({
            currentPage: 1,
            ordering: ordering
        }, () => {
            this.fetchData();
        });
        
    }

    updateSearch = (event) => {
        this.setState({
          search: event.target.value,
          currentPage: 1
        });
    }

    hangleSearch = () => {
        this.fetchData();
    }

    handleKeyDown = (e) => {
        if (e.key === 'Enter') {
            this.hangleSearch();
        }
    }

    resetAll = () => {
        this.setState({
            currentPage: 1,
            pageCount: 1,
            search: "",
            ordering: {
                orderBy: "",
                order: ""
            },
        }, () => {
            this.fetchData();
        });
    }
    
    render() {

        const { persons, currentPage, pageCount } = this.state;

        const allPersons = persons.map((person, index) => (
            <tr key={index}>
                <td>{person.firstname}</td>
                <td>{person.lastname}</td>
                <td>{person.species}</td>
                <td>{person.gender}</td>
                <td>{person.weapon}</td>
                <td>{person.vehicle}</td>
                <td>{person.locations.map(location => <p key={person.id + location.id}>{ location.name }</p>)}</td>
                <td>{person.affiliations.map(affiliation => <p key={person.id + affiliation.id}>{ affiliation.title }</p>)}</td>
            </tr>
        ));

        const noItem = (
            <div>
                <h2 className="noperson">No person available</h2>
            </div>
        );

        return (
            <div className="main">

                <h1>Persons</h1>

                <UserInput 
                    search={this.state.search} 
                    changed={this.updateSearch} 
                    searchClicked={this.hangleSearch} 
                    keypress={this.handleKeyDown}
                    resetFilters={this.resetAll}
                />

                { allPersons.length > 0 ?
                    <div className="table-responsive">
                        <table className="table">
                            <tbody>

                            <tr>
                                <th onClick={ () => this.handleOrdering("firstname") }>
                                    First Name <i className='fas fa-sort'></i>
                                </th>
                                <th onClick={ () => this.handleOrdering("lastname") }>
                                    Last Name <i className='fas fa-sort'></i>
                                </th>
                                <th onClick={ () => this.handleOrdering("species") }>
                                    Species <i className='fas fa-sort'></i>
                                </th>
                                <th onClick={ () => this.handleOrdering("gender") }>
                                    Gender <i className='fas fa-sort'></i>
                                </th>
                                <th onClick={ () => this.handleOrdering("weapon") }>
                                    Weapon <i className='fas fa-sort'></i>
                                </th>
                                <th onClick={ () => this.handleOrdering("vehicle") }>
                                    Vehicle <i className='fas fa-sort'></i>
                                </th>
                                <th onClick={ () => this.handleOrdering("affiliations.title") }>
                                    Affiliations <i className='fas fa-sort'></i>
                                </th>
                                <th onClick={ () => this.handleOrdering("locations.name") }>
                                    Locations <i className='fas fa-sort'></i>
                                </th>
                            </tr>

                                { allPersons }

                            </tbody>
                        </table>

                        <ReactPaginate
                            previousLabel={"Previous"}
                            nextLabel={"Next"}
                            breakLabel={"..."}
                            breakClassName={"break-me"}
                            forcePage={currentPage - 1}
                            pageCount={pageCount}
                            marginPagesDisplayed={2}
                            pageRangeDisplayed={5}
                            onPageChange={ (data) => this.handlePageClick(data) }
                            containerClassName={"pagination"}
                            subContainerClassName={"pages pagination"}
                            activeClassName={"active"}/>
                        </div>

                : noItem }
                
            </div>
        );
    }

}
export default Persons;