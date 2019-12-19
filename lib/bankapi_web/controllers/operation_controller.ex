defmodule BankWeb.OperationController do
  use BankWeb, :controller

  alias Bank.Operations
  alias Bank.Operations.Operation
  alias Bank.Users

  action_fallback BankWeb.FallbackController

  def index(conn, %{"account_id" => acc_id}) do
    operations = Operations.list_operations(acc_id)
    render(conn, "index.json", operations: operations)
  end

  def create(conn, %{"operation" => op_params, "account_id" => acc_id}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, _} <- Users.user_account(user, acc_id),
         {:ok, %Operation{} = op} <- Operations.create_valid_operation(op_params, acc_id) do
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

  def total(conn, %{"period" => period}) do
    {total, operations} = Operations.total_operations(period)
    render(conn, "total_operations.json", total: total, operations: operations)
  end
end
