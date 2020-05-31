defmodule Mix.Tasks.Colly.RemoveEmptyActivities do
  import Ecto.Query, only: [from: 1, from: 2]
  alias Colly.Repo
  alias Colly.Collab.Activity

  @shortdoc "Removed empty and unused activities"

  def remove do
    %{months: months} = Application.get_env(:colly, :remove_activities_after)
    IO.puts "Removing empty activities before last #{months} months"

    Repo.delete_all(
      from a in Activity,
      where: a.inserted_at <= ^Timex.shift(Timex.now, months: months*-1),
      where: fragment("? NOT IN (SELECT activity_uuid FROM items)", a.uuid)
    )
  end
end
