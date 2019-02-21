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
    plug TwitterWeb.Guardian.Pipeline
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

    get "/auth", SessionController, :auth
    resources "/tweet", TweetController, except: [:new, :edit]
    resources "/user", UserController, except: [:edit]
    get "/count", UserController, :count
    resources "/follower", FollowerController, only: [:index, :create, :delete]
  end

  scope "/", TwitterWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
