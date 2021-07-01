defmodule Padelslots.Decorators.StopWatch do
  use Decorator.Define, measure: 0

  def measure(body, _context) do
    quote do
      {timer, result} =
        :timer.tc(fn ->
          unquote(body)
        end)

      IO.puts("Function #{inspect(__ENV__.function)} took #{timer / 1000}ms to execute")
      result
    end
  end
end
