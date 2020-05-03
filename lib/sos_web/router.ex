defmodule SosWeb.Router do
  use SosWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SosWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SosWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/patients", PatientLive.Index, :index
    live "/patients/new", PatientLive.Index, :new
    live "/patients/:id/edit", PatientLive.Index, :edit

    live "/patients/:id", PatientLive.Show, :show
    live "/patients/:id/show/edit", PatientLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", SosWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: SosWeb.Telemetry
    end
  end
end
