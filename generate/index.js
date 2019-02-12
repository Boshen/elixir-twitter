const request = require('request-promise-native')
const faker = require('faker')

const r = request.defaults({jar: true, json: true})

const host = 'http://localhost:4000/api'

const main = async () => {
  await r.post(host + '/login', {
    body: { username: 'Superuser' }
  })

  Array.from({length: 1000}).forEach(() => {
    r.post(host + '/user', {
      body: {
        name: faker.fake("{{internet.userName}}")
      }
    })
  })
}

main()
