import gleam/io
import list_tweets/gen_html.{gen_html}
import list_tweets/read_tweets.{read_tweets}

pub fn main() {
  let assert Ok(tweets) = read_tweets("tweets.2.json")

  case gen_html(tweets) {
    Ok(_) -> Nil
    Error(err) -> io.print_error(err)
  }
}
