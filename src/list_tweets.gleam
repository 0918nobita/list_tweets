import gleam/bbmustache
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import simplifile
import list_tweets/tweets

fn read_tweets(path: String) {
  use json_str <- result.try(
    simplifile.read(path)
    |> result.map_error(fn(_err) { "Failed to open " <> path }),
  )

  json_str
  |> tweets.from_json
  |> result.map_error(fn(_err) { "Failed to decode " <> path })
}

pub fn main() {
  let assert Ok(tweets) = read_tweets("tweets.2.json")

  io.println(int.to_string(list.length(tweets)) <> " tweets")

  let assert Ok(template) = bbmustache.compile_file("tweets.mustache")

  let tweets =
    tweets
    |> list.map(fn(tweet) {
      bbmustache.object([
        #("id", bbmustache.string(tweet.id)),
        #("full_text", bbmustache.string(tweet.full_text)),
        #("created_at", bbmustache.string(tweet.created_at)),
      ])
    })

  bbmustache.render(template, injecting: [#("tweets", bbmustache.list(tweets))])
  |> simplifile.write(to: "tweets.html")
}
