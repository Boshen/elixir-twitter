import React, { useState, useEffect, useRef } from 'react'
import axios from 'axios'

export const UsersPage = () => {
  const [users, setUsers] = useState({entries: []})
  const [followers, setFollowers] = useState([])
  const [page, setPage] = useState(1)
  const inputEl = useRef(null)

  useEffect(() => {
    axios.get('/api/user?page=' + page).then((res) => setUsers(res.data))
  }, [page])

  useEffect(() => {
    axios.get('/api/follower').then((res) => setFollowers(res.data))
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

  const onFollow = (id) => () => {
    axios.post('/api/follower/', {
      follower_id: id
    })
  }

  const onUnfollow = (id) => () => {
    axios.delete('/api/follower/' + id)
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
        {users.entries.map((u) => (
          <li key={u.id}>
            <input defaultValue={u.name} onChange={onEdit(u.id)}/>
            <button onClick={onFollow(u.id)}>follow</button>
            <button onClick={onDelete(u.id)}>delete</button>
          </li>
        ))}
        <button onClick={() => setPage(page - 1)}>Prev</button>
        <button onClick={() => setPage(page + 1)}>Next</button>
        <br />
        {followers.map((u) => (
          <li key={u.id}>
            { u.name }
            <button onClick={onUnfollow(u.id)}>unfollow</button>
          </li>
        ))}
      </ul>
    </div>
  )
}
