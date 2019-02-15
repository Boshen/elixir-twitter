import React, { useState, useContext, useEffect } from 'react'
import { Link } from 'react-router-dom'
import axios from 'axios'

import { UserContext } from '../context/user.context'

export const Header = () => {
  const { user, updateUser } = useContext(UserContext)
  const [counts, setCounts] = useState(null)

  useEffect(() => {
    axios.get('/api/count').then((res) => setCounts(res.data))
  }, [])

  const onLogout = () => {
    axios.post('/api/logout')
      .then(() => {
        updateUser('error')
      })
  }

  const countBlock = counts && (
    <ul>
      <li>Tweets {counts.tweets}</li>
    </ul>
  )


  return (
    <header>
      <ul>
        <li><Link to='/users'>Users</Link></li>
        <li><Link to='/tweets'>Tweets</Link></li>
      </ul>
      { user.name }
      { countBlock }
      <button onClick={onLogout}>Logout</button>
    </header>
  )
}
