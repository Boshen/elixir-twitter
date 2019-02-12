defmodule TwitterWeb.UserController do
  use TwitterWeb, :controller
  alias Twitter.Accounts
  alias TwitterWeb.ErrorHelpers
  alias Twitter.Accounts.User
  alias Ecto.Changeset

  def index(conn, _params) do
    conn |> json(Accounts.list_users())
  end

  def show(conn, params) do
    try do
      user = Accounts.get_user!(params["id"])
      conn |> json(user)
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: ["not found"]})
    end
  end

  def create(conn, params) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(user)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          errors: Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
        })
    end
  end

  def update(conn, params) do
    try do
      {id, data} = Map.pop(params, "id")
      result = Accounts.update_user(%User{id: String.to_integer(id)}, data)

      case result do
        {:ok, user} ->
          conn |> json(user)

        {:error, changeset} ->
          conn
          |> put_status(:bad_request)
          |> json(%{
            errors: Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
          })
      end
    rescue
      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: ["unable to update user"]})
    end
  end

  def delete(conn, params) do
    try do
      result = Accounts.delete_user(%User{id: String.to_integer(params["id"])})

      case result do
        {:ok, user} ->
          conn
          |> json(user)

        {:error, changeset} ->
          conn
          |> put_status(:bad_request)
          |> json(%{
            errors: Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
          })
      end
    rescue
      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: ["unable to delete user"]})
    end
  end
end
