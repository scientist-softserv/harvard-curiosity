# CURIOSity

CURIOSity enables researchers to discover and easily access a wealth of curated, publicly accessible, digitized materials.

## Technology Stack

##### Language

Ruby on Rails

##### Framework

Blacklight / Spotlight

## Running the stack

### Important URLs

dev: http://localhost:3000

## Local Development Environment Setup Instructions

### 1. Clone the project

```bash
git clone git@github.com:harvard-lts/CURIOSity.git
```

### 2: Create app environment variables

##### Create config file for environment variables

- Make a copy of the config example file `./env-example`
- Rename the file to `.env`
- Replace placeholder values as necessary

_Note: The config file .env is specifically excluded in .gitignore and .dockerignore, since it contains credentials it should NOT ever be committed to any repository._

### 3. Enable full containerization overrides

```bash
cp docker-compose.override.example.yml docker-compose.override.yml
```

### 4. Build the Docker image(s)

`docker compose build`

### 5. Build the Docker image(s) and bring up the stack

`docker compose up -d --build --force-recreate`

After running the above commands, check that you see the following output in the terminal, then navigate to http://localhost:3000

`curiosity-db_migrate-1 exited with code 0`

NOTE: I still had to shell in and run rails db:migrate

### Admin login info

You can find login credentials in the [db/seeds.rb](db/seeds.rb) file. These SHOUDL NOT be brought in to anything beyond local.

To import these:

```bash
docker exec -it curiosity_web_1 sh
rails db:migrate
rails db:seed
```

### How to run the test stack

Bash into the web container
`docker compose exec web sh`

Create & migrate the test database
`RAILS_ENV=test bin/rails db:create db:migrate`

Run your specs (this will run the whole test suite, if you would like to run an individual test, add the relative path to the end.)
`bin/rspec`

### Troubleshooting

- If you get the following error when navigating to http://spotlight.test:

```bash
NoMethodError in Spotlight::ExhibitsController#index
undefined method `current_exhibit = 'for I18n::Backend::ActiveRecord::Translation(Table doesn't exist):Class
```

**Try:** restarting the containers or shelling in and re-running migrations

- If you run into this error the first time you are running the test suite

```bash
  ActiveRecord::NoDatabaseError:
  connection to server at "192.168.32.2", port 5432 failed: FATAL:  database "spotlight_test" does not exist
```

**Try:**

- Comment out lines 8-23 in `config/initializers/translation.rb`
- Comment out lines 27-32 in `spec/rails_helper.rb`
- Run the command to create and migrate the test db again: `RAILS_ENV=test bin/rails db:create db:migrate`
