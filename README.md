# Tomer

## Deployment
To deploy you need to secret two variable
- `SECRET_KEY` is the password for logging in
- `SECRET_KEY_BASE` is internally used for the framework. you can use any alphanumeric mumbo jumbo for this.
```sh
docker run \
  -e SECRET_KEY=<SECRET_KEY> \
  -e SECRET_KEY_BASE=<SECRET_KEY_BASE> \
  -p 80:4000
ghcr.io/imsozrious/tomer:latest
```

Also you need proxy to make it secure (https).

# Usage
let say it is deployed at `www.example.com`.
## For admin
The admin route is located at `www.example.com/admin`.

## For user
The user route is located at `www.example.com`.

User route can be track (send connect / disconnect notice to admin) if you set query params `id` along with the endpoint (e.g. `https://www.example.com/?id=observer`). Be careful when you sharing the url, the behavior of using the same id is unknown.

Another feature is chat, it make one-way communication from admin (top textarea in admin page) to every user connect to the room, user will not received chat by default. It can be enabled with `chat=true` in search params.