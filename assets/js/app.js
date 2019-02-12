import '@babel/polyfill'
import React, { useState, useEffect, useRef } from 'react'
import ReactDOM from 'react-dom'
import { BrowserRouter, Route, Switch } from 'react-router-dom'
import axios from 'axios'

import css from "../css/app.css"
import "phoenix_html"

const TweetPage = () => {
  const [tweets, setTweets] = useState([])
  const [user, setUser] = useState(null)
  const inputEl = useRef(null)

  useEffect(() => {
    axios.get('/api/tweet').then((res) => setTweets(res.data))
    axios.get('/api/user').then((res) => setUser(res.data[0]))
  }, [])

  const onSubmit = (e) => {
    e.preventDefault()
    axios.post('/api/tweet', {
      message: inputEl.current.value,
      creator_id: user.id
    })
      .then((response) => {
        setTweets(tweets.concat(response.data))
      })
  }

  const onDelete = (id) => () => {
    axios.delete('/api/tweet/' + id)
      .then(() => {
        setTweets(tweets.filter((t) => t.id !== id))
      })
  }

  const onEdit = (id) => (e) => {
    axios.patch('/api/tweet/' + id, {
      message: e.currentTarget.value
    })
  }

  return (
    <div>
      <form onSubmit={onSubmit}>
        <input
          ref={inputEl}
          placeholder="message"
        />
        <button>
          Submit
        </button>
      </form>
      <ul>
        {tweets.map((t) => (
          <li key={t.id}>
            <input defaultValue={t.message} onChange={onEdit(t.id)}/>
            <span>by {t.creator.name}</span>
            <button onClick={onDelete(t.id)}>delete</button>
          </li>
        ))}
      </ul>
    </div>
  )
}

const UserPage = () => {
  const [users, setUsers] = useState([])
  const inputEl = useRef(null)

  useEffect(() => {
    axios.get('/api/user').then((res) => setUsers(res.data))
  }, [])

  const onSubmit = (e) => {
    e.preventDefault()
    axios.post('/api/user', {
      name: inputEl.current.value
    })
      .then((response) => {
        setTweets(tweets.concat(response.data))
      })
  }

  const onDelete = (id) => () => {
    axios.delete('/api/user/' + id)
      .then(() => {
        setUsers(users.filter((u) => u.id !== id))
      })
  }

  const onEdit = (id) => (e) => {
    axios.patch('/api/user/' + id, {
      name: e.currentTarget.value
    })
  }
  return (
    <div>
      <form onSubmit={onSubmit}>
        <input
          ref={inputEl}
          placeholder="username"
        />
        <button>
          Submit
        </button>
      </form>
      <ul>
        {users.map((u) => (
          <li key={u.id}>
            <input defaultValue={u.name} onChange={onEdit(u.id)}/>
            <button onClick={onDelete(u.id)}>delete</button>
          </li>
        ))}
      </ul>
    </div>
  )
}

const App = () => {
  return (
    <BrowserRouter>
      <Switch>
        <Route exact path='/' component={TweetPage}/>
        <Route path='/user' component={UserPage}/>
        <Route component={TweetPage}/>
        </Switch>
    </BrowserRouter>
  )
}

ReactDOM.render(<App />, document.querySelector('#react-container'))
