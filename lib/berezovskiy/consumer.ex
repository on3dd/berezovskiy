defmodule Berezovskiy.Consumer do
  use Nostrum.Consumer

  alias Berezovskiy.Consumer.MessageCreate

  require Logger

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    MessageCreate.handle(msg)
  end

  def handle_event({:VOICE_SPEAKING_UPDATE, payload, _ws_state}) do
    Logger.debug("VOICE SPEAKING UPDATE #{inspect(payload)}")
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event) do
    :noop
  end
end
