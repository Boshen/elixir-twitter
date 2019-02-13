defmodule TwitterWeb.Router do
  use TwitterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Twitter.Accounts.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", TwitterWeb do
    pipe_through [:api, :auth]
    post "/login", SessionController, :login
    post "/logout", SessionController, :logout
  end

  scope "/api", TwitterWeb do
    pipe_through [:api, :auth, :ensure_auth]

    resources "/tweet", TweetController, except: [:new, :edit]
    resources "/user", UserController, except: [:edit]
    get "/auth", SessionController, :auth
  end

  scope "/", TwitterWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/user", PageController, :index
  end
end
