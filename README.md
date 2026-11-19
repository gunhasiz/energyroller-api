# Energy Drink Roulette API

A lightweight REST API and static web server built in **Dart** using `shelf` and `sqlite3`. It powers the **EnergyRoller** frontend and serves compiled Flutter Web assets from a single process.

## Configuration

The server is configured via environment variables with sensible defaults:

| Variable | Default | Description |
| :--- | :--- | :--- |
| `PORT` | `8080` | TCP port the HTTP server listens on (`0.0.0.0`). |
| `DB_PATH` | `db/drinks.db` | Path to the SQLite database file. |
| `WEB_DIR` | `../build/web` | Directory containing compiled Flutter Web static files. |

## API Endpoints

### `GET /api/drinks/roll`

Returns 3 randomly selected energy drinks from the database.

- **Response (`200 OK`):** JSON array of drink objects.

### `GET /api/drinks`

Returns all energy drinks ordered by newest first (`id DESC`).

- **Response (`200 OK`):** JSON array of drink objects.

### `POST /api/drinks`

Creates a new energy drink record.

- **Request Body (`application/json`):**

  ```json
  {
    "name": "Ultra White",
    "brand": "Monster",
    "flavor": "Citrus",
    "caffeine_mg": 150,
    "volume_ml": 500
  }
  ```

  *(Note: `name` and `brand` are required; `caffeine_mg` defaults to `80` and `volume_ml` defaults to `250`.)*
- **Responses:**
  - `201 Created`: `{"id": 1, "status": "created"}`
  - `400 Bad Request`: `{"error": "Validation message"}`

## Local Development

1. Install dependencies:

   ```bash
   dart pub get
   ```

2. Run static analysis:

   ```bash
   dart analyze
   ```

3. Start the development server:

   ```bash
   dart run bin/server.dart
   ```

   The API will be available at `http://0.0.0.0:8080`.

## Deployment

1. Compile a standalone native executable:

   ```bash
   dart compile exe bin/server.dart -o server
   ```

2. Copy the `server` binary and compiled Flutter Web assets (`build/web`) to your server (e.g., `/opt/energyroller/backend`).
3. Create a `systemd` service at `/etc/systemd/system/energyroller.service`:

   ```ini
   [Unit]
   Description=EnergyRoller API
   After=network.target

   [Service]
   Type=simple
   WorkingDirectory=/opt/energyroller/backend
   ExecStart=/opt/energyroller/backend/server
   Restart=always
   RestartSec=3

   [Install]
   WantedBy=multi-user.target
   ```

4. Enable and start the service:

   ```bash
   systemctl daemon-reload
   systemctl enable --now energyroller
   ```
