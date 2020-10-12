import React from "react";
import ReactPaginate from 'react-paginate';

import UserInput from './UserInput';
import TableHead from './person/TableHead';
import TableRow from './person/TableRow';

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
            isLoading: true
        };
    }

    componentDidMount() {
        this.fetchData();
    }

    fetchData() {

        const url = this.processURL();

        fetch(url)
        .then(response => {
            this.setState({ isLoading: true })
            if (response.ok) {
                return response.json();
            }
            throw new Error("Network response was not ok.");
        })
        .then(response => {
            this.setState({ isLoading: false })
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

        return url
    }

    handlePageClick(data) {
        // ReactPaginate counts page position from 0
        // So require +1 to get correct page
        this.setState({ currentPage: data.selected + 1 }, () => {
            this.fetchData();
        });
        
    };

    handleOrdering = (orderBy) => {

        let ordering = this.state.ordering;

        // order empty string means ascending order
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

        // Ordering reset current page to 1
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

                { persons.length > 0 ?
                    <div className="table-responsive">
                        <table className="table">
                            <tbody>

                                <TableHead handleOrder={this.handleOrdering}/>

                                { persons.map((person, index) => (
                                    <TableRow person={person} key={index} />
                                )) }

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

                : !this.state.isLoading ? noItem: undefined }
                
            </div>
        );
    }

}
export default Persons;