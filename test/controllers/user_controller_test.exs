defmodule SocialAppApi.UserControllerTest do
  use SocialAppApi.ConnCase

  alias SocialAppApi.User

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["data"] == %{"attributes" => %{"id" => user.id,
      "email" => user.email,
      "auth_provider" => user.auth_provider,
      "first_name" => user.first_name,
      "last_name" => user.last_name,
      "avatar" => user.avatar,
      "access_token" => user.access_token},
      "type" => "user"}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end
end
