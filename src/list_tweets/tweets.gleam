import gleam/dynamic
import gleam/json
import list_tweets/tweet.{type Tweet}

pub type Tweets =
  List(Tweet)

fn from_dynamic(
  dyn: dynamic.Dynamic,
) -> Result(Tweets, List(dynamic.DecodeError)) {
  dyn
  |> dynamic.list(of: tweet.from_dynamic)
}

pub fn from_json(json_str: String) -> Result(Tweets, json.DecodeError) {
  json_str
  |> json.decode(from_dynamic)
}
