import birl
import gleam/dynamic as dyn
import gleam/result

pub type Tweet {
  Tweet(id: String, created_at: birl.Time, full_text: String)
}

pub fn from_dynamic(dyn: dyn.Dynamic) -> Result(Tweet, List(dyn.DecodeError)) {
  use #(id, created_at, full_text) <- result.try(
    dyn
    |> dyn.decode3(
      fn(id, created_at, full_text) { #(id, created_at, full_text) },
      dyn.field("id_str", dyn.string),
      dyn.field("created_at", dyn.string),
      dyn.field("full_text", dyn.string),
    ),
  )

  use created_at <- result.try(
    created_at
    |> birl.parse
    |> result.map_error(fn(_) {
      [
        dyn.DecodeError(expected: "ISO 8601", found: "Invalid format", path: [
          "created_at",
        ]),
      ]
    }),
  )

  Ok(Tweet(id, created_at, full_text))
}
