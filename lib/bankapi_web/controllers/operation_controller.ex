defmodule BankWeb.OperationController do
  use BankWeb, :controller

  alias Bank.Operations
  alias Bank.Operations.Operation

  action_fallback BankWeb.FallbackController

  def index(conn, _params) do
    operations = Operations.list_operations()
    render(conn, "index.json", operations: operations)
  end

  def create(conn, %{"operation" => op_params, "account_id" => acc_id}) do
    with {:ok, %Operation{} = op} <- Operations.create_operation(op_params, acc_id) do
      localization = Routes.account_operation_path(conn, :show, acc_id, op)

      conn
      |> put_status(:created)
      |> put_resp_header("location", localization)
      |> render("show.json", operation: op)
    end
  end

  def show(conn, %{"id" => id}) do
    operation = Operations.get_operation!(id)
    render(conn, "show.json", operation: operation)
  end

  def update(conn, %{"id" => id, "operation" => operation_params}) do
    operation = Operations.get_operation!(id)

    with {:ok, %Operation{} = operation} <-
           Operations.update_operation(operation, operation_params) do
      render(conn, "show.json", operation: operation)
    end
  end

  def delete(conn, %{"id" => id}) do
    operation = Operations.get_operation!(id)

    with {:ok, %Operation{}} <- Operations.delete_operation(operation) do
      send_resp(conn, :no_content, "")
    end
  end
end
