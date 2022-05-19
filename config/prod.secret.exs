import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    enviroment varible DATABASE_URL is missing.
    for exemple: ecto://USER:PASS@HOST/DATABASE
    """

config :rushing, Rushing.Repo,
  adapter: Ecto.Adapter.Postgres,
  database: "",
  ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || 10)
