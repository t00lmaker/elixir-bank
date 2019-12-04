defmodule BankWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use BankWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(BankWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, %{msg: msg, status: status}}) do
    conn
    |> put_status(status)
    |> json(%{msg: msg})
  end

  def call(conn, error) do
    conn
    |> put_status(:internal_server_error)
    |> text(error)
  end
end
