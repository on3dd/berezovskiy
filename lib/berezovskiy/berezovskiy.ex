defmodule Berezovskiy do
  use Application

  @impl true
  def start(_type, _args) do
    Berezovskiy.Supervisor.start_link(name: Berezovskiy.Supervisor)
  end
end
