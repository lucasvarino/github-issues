defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1]

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
end
