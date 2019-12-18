defmodule Bank.Operations.Notify do
  @moduledoc """
    Envia uma notificação para o cliente
    para um operacao realizada em uma de suas contas.
  """
  alias Bank.Operations.Operation

  require Logger

  def send(operation) do
    {:ok, msg} = template(operation)
    send_email(msg)
    {:ok, msg}
  end

  def send_email(_msg) do
    Task.Supervisor.async_nolink(Bank.TaskSupervisor, fn ->
      Logger.debug("Envidando email")
      :timer.sleep(10000)
      Logger.debug("Email enviado com sucesso.")
    end)
  end

  defp template(%Operation{type: "SAQUE"} = op) do
    # tempalte msg para SAQUE .
    Logger.debug("Construindo msg para operação de #{op.type}")
    {:ok, " template here "}
  end

  defp template(operation) do
    {:error, "Tipo #{operation.type} sem template definido para notificação."}
  end
end
