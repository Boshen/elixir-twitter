# https://docs.locust.io/en/stable/quickstart.html

# locust --host=http://localhost.4001

from locust import HttpLocust, TaskSet, task

class UserBehavior(TaskSet):
    def on_start(self):
        self.login()

    def on_stop(self):
        self.logout()

    def login(self):
        self.client.post("/api/login", {"username":"Superuser"})

    def logout(self):
        self.client.post("/api/logout")

    @task(20)
    def create_tweet(self):
        self.client.post("/api/tweet", {"message": "test"})

    @task(1)
    def get_tweet(self):
        self.client.get("/api/tweet")

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 5000
    max_wait = 9000
