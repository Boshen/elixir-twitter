import * as React from 'react'
import { distanceInWordsToNow } from 'date-fns'

export const Tweet = ({ tweet: t, onEdit, onDelete }) => {

  return (
    <div >
      <div>by {t.creator.name} · {distanceInWordsToNow(t.inserted_at)}</div>
      <input defaultValue={t.message} onChange={onEdit(t.id)} />
      <button onClick={onDelete(t.id)}>delete</button>
    </div>
  )
}
