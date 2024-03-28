import gleam/dynamic

pub type Tweet {
  Tweet(id: String, created_at: String, full_text: String)
}

pub fn from_dynamic(
  dyn: dynamic.Dynamic,
) -> Result(Tweet, List(dynamic.DecodeError)) {
  dyn
  |> dynamic.decode3(
    Tweet,
    dynamic.field("id_str", dynamic.string),
    dynamic.field("created_at", dynamic.string),
    dynamic.field("full_text", dynamic.string),
  )
}
