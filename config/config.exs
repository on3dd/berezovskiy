import Config

config :nostrum,
  token: System.get_env("BOT_TOKEN")

config :logger, :console, metadata: [:shard, :guild, :channel]
