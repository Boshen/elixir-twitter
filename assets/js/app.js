import '@babel/polyfill'
import React, { useState, useEffect, useRef } from 'react'
import ReactDOM from 'react-dom'
import axios from 'axios'

import css from "../css/app.css"
import "phoenix_html"

const App = () => {
  const [tweets, setTweets] = useState([])
  const inputEl = useRef(null)

  useEffect(() => {
    axios.get('/api/tweet').then((res) => setTweets(res.data))
    return
  }, [])

  const onSubmit = (e) => {
    e.preventDefault()
    axios.post('/api/tweet', {
      message: inputEl.current.value
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
            <button onClick={onDelete(t.id)}>delete</button>
          </li>
        ))}
      </ul>
    </div>
  )
}

window.APP = {
  submitTweet(e) {
  }
}

ReactDOM.render(<App />, document.querySelector('#react-container'))
