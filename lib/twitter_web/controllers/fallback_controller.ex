defmodule TwitterWeb.FallbackController do
  use TwitterWeb, :controller
  alias Ecto.Changeset
  alias TwitterWeb.ErrorHelpers

  def call(conn, {:error, nil}) do
    conn
    |> put_status(:not_found)
    |> json(%{errors: ["not found"]})
  end

  def call(conn, {:error, changeset}) do
    conn
    |> put_status(:bad_request)
    |> json(%{
      errors: Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
    })
  end
end
