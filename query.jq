[ map(.tweet)[] | select(.full_text | startswith("RT") | not) ]
| map(
    del(
        .lang,
        .favorited,
        .favorite_count,
        .retweeted,
        .retweet_count,
        .display_text_range,
        .source,
        .truncated,
        .entities,
        .edit_info,
        .id,
        .possibly_sensitive
    )
    | .created_at = (
        .created_at
        | strptime("%a %b %d %H:%M:%S %z %Y")
        | mktime
        | todateiso8601
    )
)
| sort_by(.created_at)
