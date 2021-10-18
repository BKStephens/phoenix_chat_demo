#!/bin/bash

set -e

npm install
mix local.hex --force
mix local.rebar --force
mix deps.get && mix deps.compile
mix ecto.drop && mix ecto.create && mix ecto.migrate
mix run priv/repo/seeds.exs
mix phoenix.server
