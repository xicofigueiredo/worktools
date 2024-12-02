from locust import HttpUser, task

class HelloWorldUser(HttpUser):
    def on_start(self):
        # Form post to /login with email and password
        self.client.post("/users/sign_in", {
            'email': 'francisco-abf@hotmail.com',
            'password': 'cduprugby'
        })
    @task
    def hello_world(self):
        self.client.get("/")
