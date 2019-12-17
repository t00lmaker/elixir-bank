defmodule BankWeb.OperationView do
  use BankWeb, :view
  alias BankWeb.OperationView

  def render("index.json", %{operations: operations}) do
    %{data: render_many(operations, OperationView, "operation.json")}
  end

  def render("show.json", %{operation: operation}) do
    %{data: render_one(operation, OperationView, "operation.json")}
  end

  def render("operation.json", %{operation: operation}) do
    %{
      id: operation.id,
      description: operation.description,
      type: operation.type,
      value: operation.value,
      is_consolidaded: operation.is_consolidaded
    }
  end

  def render("total_operations.json", %{total: total, operations: operations}) do
    %{ 
      total: total,
      operations: render_many(operations, OperationView, "operation.json")
    }
  end
end
