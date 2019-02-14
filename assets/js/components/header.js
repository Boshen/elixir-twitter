import React, { useContext } from 'react'
import { Link } from 'react-router-dom'
import axios from 'axios'

import { UserContext } from '../context/user.context'

export const Header = () => {
  const { user, updateUser } = useContext(UserContext)

  const onLogout = () => {
    axios.post('/api/logout')
      .then(() => {
        updateUser('error')
      })
  }

  return (
    <header>
      <ul>
        <li><Link to='/users'>Users</Link></li>
        <li><Link to='/tweets'>Tweets</Link></li>
      </ul>
      { user.name }
      <button onClick={onLogout}>Logout</button>
    </header>
  )
}
