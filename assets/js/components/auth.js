import React, { useState, useEffect, userContext } from 'react'
import axios from 'axios'

import { UserContext } from '../context/user.context'
import { LoginPage } from '../pages/login.page'

export const Auth = ({ children }) => {
  const [user, updateUser] = useState(userContext)

  useEffect(() => {
    axios.get('/api/auth')
      .then((res) => updateUser(res.data))
      .catch(() => updateUser('error'))
  }, [])

  return !!user && (
    <UserContext.Provider value={{user, updateUser}}>
      { user == 'error' ? <LoginPage /> : children }
    </UserContext.Provider>
  )
}
