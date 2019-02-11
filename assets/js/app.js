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
    if (tweets.length > 0) {
      return
    }
    axios.get('/api/tweet')
      .then((res) => {
        setTweets(res.data)
      })
    return () => { }
  }, [tweets])

  const onSubmit = (e) => {
    e.preventDefault()
    axios.post('/api/tweet', {
      message: inputEl.current.value
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
          <li key={t.id}>{ t.message }</li>
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
