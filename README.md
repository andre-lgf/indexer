# README

* Ruby version
`3.2.2`

* System dependencies
  - Redis
  - Sidekiq
  - Elasticsearch
  - PostgreSQL
  - Docker/Orbstack for Deployment using Kamal

# The Solution
This app was built for scrapping github profiles using Nokogiri, storing the info in the database and providing a search functionality, as well as an option for fetching the information manually. It relies on Sidekiq for processing the job responsible for fetching the page and retrieving the information (as it can take a while). It should also shorten the provided github url using an external service (this solution is using Tinyurl).

Since the objective was to retrieve only the profile using this method, the organization info is being fetched using GitHub's API via Octokit. A simple search solution using Elasticsearch was also implemented (can be opted in or out in the Profiles index page), and everytime a Profile gets saved, it will reindex the record, and will remove it when the Profile gets deleted, so make sure to have Elasticsearch running. It also makes use of Hotwire.

It can be run locally starting the rails server (the dependencies can be installed locally too, or run by starting the desired containers -- you may need to set `network_mode: "host"` for the containers you wish to use), or by using docker-compose to run the entire stack (there's a nginx server configured for it, so the application can be accessed simply in `http://localhost`, without the need for the port. It will also run in production environment when using docker-compose).

## Configuration
  - `.compose.env` file is used by `docker-compose`, e.g.:
  ```ini
    RAILS_MASTER_KEY=<INSERT_MASTER_KEY_HERE>
    REDIS_URL=redis://redis:6379/1
    ELASTICSEARCH_URL=http://elasticsearch:9200
    DB_HOST=db
    POSTGRES_USER=postgres
    POSTGRES_PASSWORD=postgres
  ```


## How to run the test suite
  - Can be run locally, using `rspec` or `bundle exec rspec`
  - Will run automatically by GH Actions after pushing the code to the repository

# Deployment instructions
  * The repository has Kamal configured for deployment, just needing to have the secrets in the `.env` file (Project root directory), e.g.:
  ```ini
    KAMAL_REGISTRY_PASSWORD=<INSERT_YOUR_DOCKER_TOKEN_HERE>
    RAILS_MASTER_KEY=<INSERT_MASTER_KEY_HERE>
    POSTGRES_PASSWORD=postgres
  ```

  and updating the file `deploy.yml` with your servers IP addresses.

  ***If it's the first time you're running Kamal accessing those servers, you'll need to setup the environment with `kamal setup`***
  * Then run `kamal deploy` having Docker/Orbstack running so it can build and deploy the images.
  A full overview of Kamal can be [found here](https://kamal-deploy.org/).


# Points of improvement
  - Setup Kibana, create a refined index for the profiles search using elasticsearch and improve elasticsearch overall
  - Improve GitHub action workflows (create dependency between CI and Deployment, and improving deployment action)
  - Setup load balancers (just need to create it in the server and configure kamal's `deploy.yml` file with the information)
  - Setup SSL (configure Cloudflare for the host or generate it by any other methods)
  - Break down some page information into ViewComponents (specially the show page for Profiles/Organizations)
  - Implement cache on some other parts of the application (for example, cache the profile url so it won't be fetched multiple times in a short period of time)
  - Build own url shortener within the application
  - Implement location change + add some hardcoded texts to the localization templates (mostly attribute names)