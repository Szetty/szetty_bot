defmodule SzettyBot.Commands.Guild do
  @guild_url "http://api.swgoh.gg/guild/w53E_OdzQfmvfbZrbu-1kw/"
  @aliases %{
    "Jedi Master Luke Skywalker" => "JML",
    "Sith Eternal Emperor" => "GUCCI",
    "Supreme Leader Kylo Ren" => "SLKR",
    "Rey" => "Rey",
    "Jedi Master Kenobi" => "JMK",
    "Lord Vader" => "LV"
  }

  def get_gls() do
    %{status: 200, body: body} = Tesla.get!("http://api.swgoh.gg/guild/w53E_OdzQfmvfbZrbu-1kw/")

    body
    |> Jason.decode!()
    |> then(fn %{"players" => players} ->
      players
      |> Stream.flat_map(fn %{"data" => %{"name" => player_name}, "units" => units} ->
        units
        |> Enum.filter(fn %{"data" => data} ->
          Map.get(data, "is_galactic_legend", false)
        end)
        |> Enum.map(&Map.put(&1, "player_name", player_name))
      end)
      |> Stream.map(fn %{"player_name" => player_name, "data" => %{
        "has_ultimate" => has_ultimate?,
        "zeta_abilities" => zetas,
        "relic_tier" => relic_tier,
        "gear_level" => gear_level,
        "name" => name
      }} ->
        gear_and_relics =
          if gear_level == 13 do
            "R#{relic_tier - 2}"
          else
            "G#{gear_level}"
          end

        zetas = "#{Enum.count(zetas)}Z"

        ultimate = if has_ultimate?, do: "/W ULT", else: "NO ULT"

        [@aliases[name], ultimate, gear_and_relics, zetas, player_name]
      end)
      |> Enum.sort_by(fn [gl, ultimate, gear_and_relics, zetas, player_name] ->
        gear_and_relics = (String.slice(gear_and_relics, 1..-1) |> String.to_integer()) + (
          if String.at(gear_and_relics, 0) == "R" do
            13
          else
            0
          end
        )
        zetas = String.slice(zetas, 0..-2) |> String.to_integer()
        {gl, ultimate, -gear_and_relics, -zetas}
      end)
    end)
    |> TableRex.quick_render!()
  end
end
