import gleam/bbmustache
import gleam/dynamic
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/result
import simplifile

type Tweet {
  Tweet(id: String, created_at: String, full_text: String)
}

fn dyn_to_tweets(
  dyn: dynamic.Dynamic,
) -> Result(List(Tweet), List(dynamic.DecodeError)) {
  dyn
  |> dynamic.list(of: dynamic.decode3(
    Tweet,
    dynamic.field("id_str", dynamic.string),
    dynamic.field("created_at", dynamic.string),
    dynamic.field("full_text", dynamic.string),
  ))
}

fn tweets_from_json(path: String) {
  use json_str <- result.try(
    simplifile.read(path)
    |> result.map_error(fn(_err) { "Failed to open " <> path }),
  )

  json_str
  |> json.decode(dyn_to_tweets)
  |> result.map_error(fn(_err) { "Failed to decode " <> path })
}

pub fn main() {
  let assert Ok(tweets) = tweets_from_json("tweets.2.json")

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
