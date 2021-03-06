defmodule BanamexWeb.CallCenterController do
  use BanamexWeb, :controller
  import Ecto.Query
  import Ecto.Repo
  alias Banamex.CallCenters
  alias Banamex.CallCenters.CallCenter
  #alias Banamex.Accounts
  #alias Banamex.Cuentas
  #alias Banamex.Cuentas.Cuenta
  #alias Banamex.Accounts.User

  def index(conn, _params) do
    if Banamex.Accounts.Auth.logged_in?(conn) do
      current = Banamex.Accounts.Auth.current_user(conn)
      if (current.tipo == 1) do
        c = from u in "users",
                #where: u.id == ^current.id,
                select: [u.telefono,u.username]
        callcenter = Banamex.Repo.all(c)
        render(conn, "index.html", callcenter: callcenter)
      else
        render(conn,"no_auth2.html")
      end
    else
      render(conn,"no_auth.html")
    end
  end


  def new(conn, _params) do
    changeset = CallCenters.change_call_center(%CallCenter{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"call_center" => call_center_params}) do
    case CallCenters.create_call_center(call_center_params) do
      {:ok, call_center} ->
        conn
        |> put_flash(:info, "Call center created successfully.")
        |> redirect(to: Routes.call_center_path(conn, :show, call_center))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    call_center = CallCenters.get_call_center!(id)
    render(conn, "show.html", call_center: call_center)
  end

  def edit(conn, %{"id" => id}) do
    call_center = CallCenters.get_call_center!(id)
    changeset = CallCenters.change_call_center(call_center)
    render(conn, "edit.html", call_center: call_center, changeset: changeset)
  end

  def update(conn, %{"id" => id, "call_center" => call_center_params}) do
    call_center = CallCenters.get_call_center!(id)

    case CallCenters.update_call_center(call_center, call_center_params) do
      {:ok, call_center} ->
        conn
        |> put_flash(:info, "Call center updated successfully.")
        |> redirect(to: Routes.call_center_path(conn, :show, call_center))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", call_center: call_center, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    call_center = CallCenters.get_call_center!(id)
    {:ok, _call_center} = CallCenters.delete_call_center(call_center)

    conn
    |> put_flash(:info, "Call center deleted successfully.")
    |> redirect(to: Routes.call_center_path(conn, :index))
  end
end
