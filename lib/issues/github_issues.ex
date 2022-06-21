defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Lucas lucasvarino@gmail.com"}]

  def fetch(user, repo) do
    issues_url(user, repo)
    |> HTTPoison.get(@user_agent)
    |> handle_response()
  end

  defp issues_url(user, repo) do
    "https://api.github.com/repos/#{user}/#{repo}/issues"
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, body}
  end

  defp handle_response({_, %{status_code: status_code, body: body}}) do
    {
      status_code |> check_for_error(),
      body |> Poison.Parser.parse()
    }
  end

  defp check_for_error(200) do
    :ok
  end

  defp check_for_error(_) do
    :error
  end
end
