import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import Header from "../components/Header";
import Persons from "../components/Persons";
import Upload from "../components/Upload";

export default (
  <Router>
    <Header />
    <Switch>
      <Route path="/" exact component={Persons} />
      <Route path="/upload" exact component={Upload} />
    </Switch>
  </Router>
);