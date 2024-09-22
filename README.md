# HexDepSearch

A commandline helper to execute mix hex.search and format the 
output already in mix.exs format.

A little bit like a cargo add.

```fish

mix deps.get
mix deps.compile
mix test

mix escript.build

env MIX_ENV=prod mix escript.build

./hex_search postgrex

```
