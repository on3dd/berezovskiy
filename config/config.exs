import Config

config :nostrum,
  # TODO: hide token in env variable
  token: "ODk2MjY3NDIzNTEzMTk0NTI4.YWEoFQ.Fb98BDVWq-6Vgb0d5g8lH2tSZ1s"

config :logger, :console, metadata: [:shard, :guild, :channel]
