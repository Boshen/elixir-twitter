const request = require('request-promise-native')
const faker = require('faker')

const r = request.defaults({jar: true, json: true})

const host = 'http://localhost:4000/api'

const tweetsCount = 100000

const login = (username) => {
  return r.post(host + '/login', { body: { username } })
}

const createTweets = async () => {
  await login('Superuser')

  const u = await r.post(host + '/user', {
    body: { name: faker.fake("{{internet.userName}}") }
  })

  await login(u.name)

  await Array.from({length: tweetsCount}).reduce(async (p) => {
    await p
    await r.post(host + '/tweet', {
      body: { message: faker.fake("{{lorem.sentence}}") }
    })
  }, Promise.resolve())
}

const followUsers = async () => {
  await login('Superuser')
  const users = await r.get(host + '/user')
  Array.from({length: users.total_pages}).map(async (_, i) => {
    const { entries } = await r.get(host + '/user?page=' + (i + 1))
    entries.forEach((u) => {
      r.post(host + '/follower', {
        body: { follower_id: u.id }
      }).catch(() => {})
    })
  })
}

createTweets()
// followUsers()
