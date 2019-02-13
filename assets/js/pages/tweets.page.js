import React, { useState, useEffect, useRef } from 'react'
import axios from 'axios'

export const TweetsPage = () => {
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


