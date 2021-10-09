defmodule Berezovskiy.Consumer.MessageCreate do
  alias Nostrum.Api
  alias Nostrum.Cache.GuildCache
  alias Nostrum.Voice

  # Soundcloud link will be fed through youtube-dl
  @soundcloud_url "https://soundcloud.com/fyre-brand/level-up"
  # Audio file will be fed directly to ffmpeg
  @nut_file_url "https://brandthill.com/files/nut.wav"

  def get_voice_channel_of_msg(msg) do
    msg.guild_id
    |> GuildCache.get!()
    |> Map.get(:voice_states)
    |> Enum.find(%{}, fn v -> v.user_id == msg.author.id end)
    |> Map.get(:channel_id)
  end

  def do_not_ready_msg(msg) do
    Api.create_message(msg.channel_id, "I need to be in a voice channel for that.")
  end

  def handle(msg) do
    case msg.content do
      # The bot will search through the guild cache's voice states to find
      # the voice channel that the message author is in to join.
      "!summon" ->
        case get_voice_channel_of_msg(msg) do
          nil ->
            Api.create_message(msg.channel_id, "Must be in a voice channel to summon")

          voice_channel_id ->
            Voice.join_channel(msg.guild_id, voice_channel_id)
        end

      "!leave" ->
        Voice.leave_channel(msg.guild_id)

      # Following play song/nut commands check if connected
      # and will let the user know in case of failure.
      "!play song" ->
        if Voice.ready?(msg.guild_id) do
          Voice.play(msg.guild_id, @soundcloud_url, :ytdl)
        else
          do_not_ready_msg(msg)
        end

      "!play nut" ->
        if Voice.ready?(msg.guild_id) do
          Voice.play(msg.guild_id, @nut_file_url, :url)
        else
          do_not_ready_msg(msg)
        end

      # Following commands don't check anything so they'll
      # fail quietly if nothing is playing/paused or in channel.
      "!pause" ->
        Voice.pause(msg.guild_id)

      "!resume" ->
        Voice.resume(msg.guild_id)

      "!stop" ->
        Voice.stop(msg.guild_id)

      _ ->
        :noop
    end
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event) do
    :noop
  end
end
