defmodule SzettyBot.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Struct.{
    ApplicationCommandInteractionData,
    Interaction
  }

  require Logger

  def start_link do
    Logger.info("Starting Discord Consumer")
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, _, _}) do
    Logger.info("READY")
    create_commands()
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    Logger.info("INTERACTION_CREATE", interaction: inspect(interaction))

    response =
      case interaction do
        %Interaction{type: 1} ->
          %{type: 1}

        %Interaction{type: 2, data: %ApplicationCommandInteractionData{name: "ping"}} ->
          %{
            type: 4,
            data: %{
              content: "pong"
            }
          }

        %Interaction{type: 2, data: %ApplicationCommandInteractionData{name: "showguildgls"}} ->
          spawn(fn ->
            Nostrum.Api.create_message!(
              interaction.channel_id,
              content: "```#{SzettyBot.Commands.Guild.get_gls()}```"
            )
          end)

          %{
            type: 4,
            data: %{
              content: "Got your command, will process it"
            }
          }
      end

    Nostrum.Api.create_interaction_response(interaction, response)
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(event) do
    Logger.info("EVENT", event: inspect(event))
  end

  defp create_commands() do
    [
      %{
        name: "ping",
        description: "Ping-Pong",
        options: []
      },
      %{
        name: "showguildgls",
        description: "Show the status of GL in the guild",
        options: []
      }
    ]
    |> Enum.map(&Nostrum.Api.create_global_application_command(&1))
  end
end
