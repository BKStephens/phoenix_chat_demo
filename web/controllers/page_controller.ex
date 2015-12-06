defmodule ChatDemo.PageController do
  use ChatDemo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
