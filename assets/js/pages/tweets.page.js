import React, { useState, useEffect, useRef } from 'react'
import axios from 'axios'

export const TweetsPage = () => {
  const [tweets, setTweets] = useState({entries: []})
  const inputEl = useRef(null)

  useEffect(() => {
    axios.get('/api/tweet').then((res) => setTweets(res.data))
  }, [])

  const onSubmit = (e) => {
    e.preventDefault()
    axios.post('/api/tweet', {
      message: inputEl.current.value,
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

  const onLoadMore = () => {
    axios.get('/api/tweet?after=' + tweets.after).then((res) => {
      res.data.entries = tweets.entries.concat(res.data.entries)
      setTweets(res.data)
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
        {tweets.entries.map((t) => (
          <li key={t.id}>
            <input defaultValue={t.message} onChange={onEdit(t.id)}/>
            <span>by {t.creator.name}</span>
            <button onClick={onDelete(t.id)}>delete</button>
          </li>
        ))}
      </ul>
      { tweets.after && <button onClick={onLoadMore}>Load More</button> }
    </div>
  )
}


