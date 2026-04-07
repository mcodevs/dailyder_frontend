# dailyder_frontend

Dailyder Telegram Mini App and browser-friendly Flutter Web frontend.

## Runtime configuration

- `API_BASE_URL`: Optional backend base URL. If omitted, web builds use the current site origin for hosted deployments and `http://localhost:8080` for local `localhost` development.
- `DEV_AUTH_ENABLED`: Enables the fallback dev login form outside Telegram. Defaults to `true`.
