defmodule Rushing.Helpers.CsvTest do
	use ExUnit.Case
  use RushingWeb.ConnCase

	alias Rushing.Helpers.Csv
  alias Rushing.Statistics.StatisticsModel

  describe "download/3" do
    setup do
      inserted_data =
        Enum.map([1,2], fn number ->
          %{
            "Player" => Integer.to_string(number),
            "Team" => "JAX",
            "Pos" => "RB",
            "Att" => 2,
            "Att/G" => 2,
            "Yds" => 7,
            "Avg" => 3.5,
            "Yds/G" => 7,
            "TD" => 6,
            "Lng" => "7",
            "1st" => 0,
            "1st%" => 0,
            "20+" => 0,
            "40+" => 0,
            "FUM" => 0
          }
          |> StatisticsModel.create_changeset()
          |> Repo.insert!()
        end)

      %{inserted_data: inserted_data}
    end

    test "with all params", %{conn: conn, inserted_data: inserted_data} do
      conn =
        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", ~s[attachment; filename="report.csv"])
        |> send_chunked(:ok)

      {:ok, %{resp_body: resp_body}} = Csv.download(nil, nil, nil, conn)

      assert resp_body == """
      Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,Td,Lng,1st,1st%,20+,40+,FUM\r\n1,JAX,RB,2,2.0,7,3.5,7.0,6,7,0,0.0,0.0,0,0\r\n2,JAX,RB,2,2.0,7,3.5,7.0,6,7,0,0.0,0.0,0,0\r
      """
    end
  end
end
