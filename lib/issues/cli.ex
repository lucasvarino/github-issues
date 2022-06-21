defmodule Issues.CLI do
  @moduledoc """
  Tratamento da CLI e geração de uma tabela das últimas
  n issues abertas em um repositório do github
  """
  @default_count 4

  def run(argv) do
    argv
    |> parse_args()
    |> process()
  end

  @doc """
  argv pode ser -h ou --help, ambos devem retornar :help

  Caso contrário, é um user do github, o nome do repositório e (opicional) o número
  de issues para exibir

  Retorna uma tupla de `{user, repo, count}` ou `:help` se for pedido
  """
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_representation()

  end

  def args_to_internal_representation([user, repo, count]) do
    {user, repo, String.to_integer(count)}
  end

  def args_to_internal_representation([user, repo]) do
    {user, repo, @default_count}
  end

  def args_to_internal_representation(_) do
    :help
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end

  def process({user, repo, _count}) do
    Issues.GithubIssues.fetch(user, repo)
    |> decode_response()
  end

  defp decode_response({:ok, body}) do
    body
  end

  defp decode_response({:error, error}) do
    IO.puts("Erro ao fazer a requisição para o github: #{error["message"]}")
    System.halt(2)
  end
end
