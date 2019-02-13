import React, { useState, useEffect, useRef, useContext } from 'react'
import axios from 'axios'

import { UserContext } from '../context/user.context'

export const LoginPage = ({ history }) => {
  const {updateUser} = useContext(UserContext)
  const inputEl = useRef(null)

  const onSubmit = (e) => {
    e.preventDefault()
    axios.post('/api/login', {
      username: inputEl.current.value
    })
      .then((res) => {
        updateUser(res.data)
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
    </div>
  )
}
