import birl
import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import gsv
import list_tweets/quarter
import list_tweets/tweets.{type Tweets}
import simplifile

pub fn gen_csv(tweets: Tweets) -> Result(Nil, String) {
  use _ <- result.try(
    simplifile.create_directory_all("output")
    |> result.map_error(fn(_err) { "Failed to create output directory" }),
  )

  let tweets =
    tweets
    |> list.group(fn(tweet) {
      let day = birl.get_day(tweet.created_at)
      #(
        day.year,
        quarter.from_month(day.month)
          |> option.unwrap(quarter.Q1),
      )
    })

  tweets
  |> dict.fold(from: Ok(Nil), with: fn(proc, k, tweets) {
    let #(year, quarter) = k
    let year = int.to_string(year)

    let tweets =
      tweets
      |> list.map(fn(tweet) {
        [
          string.replace(tweet.full_text, "\n", "\\n"),
          birl.to_iso8601(tweet.created_at),
        ]
      })

    let file_name =
      "tweets_" <> year <> "_" <> quarter.to_string(quarter) <> ".csv"

    proc
    |> result.then(fn(_) {
      tweets
      |> gsv.from_lists(separator: ",", line_ending: gsv.Unix)
      |> simplifile.write(to: "output/" <> file_name)
      |> result.map_error(fn(_) { "Failed to write output/" <> file_name })
    })
  })
}
