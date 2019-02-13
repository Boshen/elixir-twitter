import React, { useState, useEffect, useRef } from 'react'
import axios from 'axios'

export const UsersPage = () => {
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
