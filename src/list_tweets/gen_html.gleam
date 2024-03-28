import birl
import gleam/bbmustache.{list as list_arg, object as obj_arg, string as str_arg} as mustache
import gleam/dict
import gleam/list
import gleam/result
import list_tweets/tweets.{type Tweets}
import simplifile

pub fn gen_html(tweets: Tweets) -> Result(Nil, String) {
  use template <- result.try(
    mustache.compile_file("tweets.mustache")
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
      obj_arg([
        #("id", str_arg(tweet.id)),
        #("full_text", str_arg(tweet.full_text)),
        #(
          "created_at",
          tweet.created_at
            |> birl.to_iso8601
            |> str_arg,
        ),
      ])
    })
    |> list_arg

  mustache.render(template, injecting: [#("tweets", tweets)])
  |> simplifile.write(to: "output/tweets.html")
  |> result.map_error(fn(_err) { "Failed to write file" })
}
