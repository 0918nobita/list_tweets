import birl
import gleam/bbmustache
import gleam/dict
import gleam/list
import gleam/result
import list_tweets/tweets.{type Tweets}
import simplifile

pub fn gen_html(tweets: Tweets) -> Result(Nil, String) {
  use template <- result.try(
    bbmustache.compile_file("tweets.mustache")
    |> result.map_error(fn(_err) { "Failed to compile template" }),
  )

  use _ <- result.try(
    simplifile.create_directory_all("output")
    |> result.map_error(fn(_err) { "Failed to create output directory" }),
  )

  let tweets =
    tweets
    |> list.group(fn(tweet) {
      let day = birl.get_day(tweet.created_at)
      day.year
    })
    |> dict.get(2024)
    |> result.unwrap(or: [])
    |> list.map(fn(tweet) {
      bbmustache.object([
        #("id", bbmustache.string(tweet.id)),
        #("full_text", bbmustache.string(tweet.full_text)),
        #(
          "created_at",
          tweet.created_at
            |> birl.to_iso8601
            |> bbmustache.string,
        ),
      ])
    })
    |> bbmustache.list

  bbmustache.render(template, injecting: [#("tweets", tweets)])
  |> simplifile.write(to: "output/tweets.html")
  |> result.map_error(fn(_err) { "Failed to write file" })
}
