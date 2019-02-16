import '@babel/polyfill'
import React from 'react'
import ReactDOM from 'react-dom'
import { BrowserRouter, Route, Redirect, Switch } from 'react-router-dom'

import 'phoenix_html'
import css from '../css/app.css'
import { Auth } from './components/auth'
import { Header } from './components/header'
import { UsersPage } from './pages/users.page'
import { TweetsPage } from './pages/tweets.page'

const App = () => (
  <BrowserRouter>
    <Auth>
      <>
        <Header />
        <Switch>
          <Route path='/tweets' component={TweetsPage} />
          <Route path='/users' component={UsersPage} />
          <Redirect to='/tweets' />
        </Switch>
      </>
    </Auth>
  </BrowserRouter>
)

ReactDOM.render(<App />, document.querySelector('#react-container'))
