# NFL Rushing
[![ci](https://github.com/cgerling/nfl-rushing/actions/workflows/ci.yml/badge.svg)](https://github.com/cgerling/nfl-rushing/actions/workflows/ci.yml)

A Phoenix LiveView application to visualize rushing statistics of NFL Players.

## Setting up

You can run the whole application through Docker Compose using the command below.

```bash
docker compose up -d
```

You can visit [localhost:4000](http://localhost:4000) from your browser to interact with the application.

### Imports

You will need to run the imports in order to have any data available in the application. For now, you can do so with the command below.

```bash
docker compose exec server bin/nfl_rushing eval "Elixir.NflRushing.ReleaseTasks.run_importer()"
```

