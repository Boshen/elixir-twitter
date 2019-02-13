import '@babel/polyfill'
import React from 'react'
import ReactDOM from 'react-dom'
import { BrowserRouter, Route, Redirect, Switch } from 'react-router-dom'

import "phoenix_html"
import css from "../css/app.css"
import { Auth } from './auth'
import { UsersPage } from './pages/users.page'
import { TweetsPage } from './pages/tweets.page'

const App = () => (
  <BrowserRouter>
    <Auth>
      <Switch>
        <Route exact path='/' component={TweetsPage}/>
        <Route path='/users' component={UsersPage}/>
        <Redirect to='/' />
      </Switch>
    </Auth>
  </BrowserRouter>
)

ReactDOM.render(
  <App />,
  document.querySelector('#react-container')
)
