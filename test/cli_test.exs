defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1, sort_into_descending_order: 1]

  test ":help é retornado pela função usando -h e --help" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "3 valores são retornados ao enviar 3" do
    assert parse_args(["user", "repo", "99"]) == {"user", "repo", 99}
  end

  test "O contador default é retornado caso forem 2 valores" do
    assert parse_args(["user", "repo"]) == {"user", "repo", 4}
  end

  test "Ordenar as issues de forma correta" do
    result = sort_into_descending_order(fake_created_at_list(["c", "a", "b"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{c b a}
  end

  defp fake_created_at_list(values) do
    for value <- values, do: %{"created_at" => value, "other_data" => "xxx"}
  end
end
