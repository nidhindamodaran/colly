defmodule Mix.Tasks.Colly.UsageReports do
  import Ecto.Query, only: [from: 1, from: 2]
  alias Colly.Repo
  alias Colly.Collab.Activity
  
  @shortdoc "Daily usage stats"
  
  def send do
    IO.puts "** Calculating daily usage stats **"
  
    count = Repo.one(
      from a in Activity,
      select: count("*"),
      where: a.inserted_at >= ^Timex.beginning_of_day(Timex.shift(Timex.now, days: -1)),
      where: a.inserted_at <= ^Timex.end_of_day(Timex.shift(Timex.now, days: -1))
    )

    IO.puts "Total Activities #{count}"
  end
end
  