import gleam/result
import list_tweets/tweets
import simplifile

pub fn read_tweets(path: String) {
  use json_str <- result.try(
    simplifile.read(path)
    |> result.map_error(fn(_err) { "Failed to open " <> path }),
  )

  json_str
  |> tweets.from_json
  |> result.map_error(fn(_err) { "Failed to decode " <> path })
}
