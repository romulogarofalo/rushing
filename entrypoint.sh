#!/bin/bash
# Docker entrypoint script.

# Wait until Postgres is ready.
echo "Creating Database $PGDATABASE ."
mix do ecto.create, ecto.migrate
echo "run seeder"
mix run priv/repo/seeds.exs
echo "starting server"
exec mix phx.server
