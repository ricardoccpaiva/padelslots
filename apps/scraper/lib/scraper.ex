defmodule Scraper.Worker do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def start_link(name, args) do
    GenServer.start_link(__MODULE__, args, name: name)
  end

  # GenServer Callbacks
  def init(%{} = _args) do
    hello()

    {:ok, %{}}
  end

  def hello do
    IO.puts("-----> HELLO")
    :world
  end
end
