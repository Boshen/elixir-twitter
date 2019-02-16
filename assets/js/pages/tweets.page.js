import React, { useState, useEffect, useRef } from 'react'
import axios from 'axios'

import { Tweet } from '../components/tweet.component'

export const TweetsPage = () => {
  const [tweets, setTweets] = useState({entries: []})
  const inputEl = useRef(null)

  useEffect(() => {
    axios.get('/api/tweet').then((res) => {
      res.data.entries.reverse()
      setTweets(res.data)
    })
  }, [])

  const onSubmit = (e) => {
    e.preventDefault()
    axios.post('/api/tweet', {
      message: inputEl.current.value,
    })
      .then((res) => {
        tweets.entries.unshift(res.data)
        setTweets({ ...tweets, entries: tweets.entries })
      })
  }

  const onDelete = (id) => () => {
    axios.delete('/api/tweet/' + id)
      .then(() => {
        setTweets({ ...tweets, entries:  tweets.entries.filter((t) => t.id !== id) })
      })
  }

  const onEdit = (id) => (e) => {
    axios.patch('/api/tweet/' + id, {
      message: e.currentTarget.value
    })
  }

  const onLoadMore = () => {
    axios.get('/api/tweet?after=' + tweets.after).then((res) => {
      res.data.entries.reverse()
      res.data.entries = res.data.entries.concat(tweets.entries)
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
      { tweets.after && <button onClick={onLoadMore}>Load More</button> }
      <div>
        {tweets.entries.map((t) =>
          <Tweet key={t.id} tweet={t} onEdit={onEdit} onDelete={onDelete} />)
        }
      </div>
    </div>
  )
}


