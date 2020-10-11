import httpclient, json, sequtils, strformat, times

type
  RedditPost* = tuple[
    title: string,
    author: string,
    url: string,
    permalink: string,
    score: int,
    created: float
  ]

var RedditClient* = newHttpClient()

proc redditUrl(subreddit: string): string =
  return fmt"https://reddit.com/r/{subreddit}/new/.json?count=100"

proc getNew*(subreddit: string): seq[RedditPost] =
  let url = redditUrl(subreddit)

  let response = RedditClient.get(url, )

  if response.code != Http200:
    raise newException(HttpRequestError, fmt"Reddit fetch returned code {response.code}")
  return response.body.parseJson{ "data", "children" }.getElems.map(proc(node: JsonNode): RedditPost =

    return node["data"].to(RedditPost)
  )

proc postFilter*(posts: seq[RedditPost], minScore: int, maxAge: Time): seq[RedditPost] =
  return posts.filter(proc(post:RedditPost): bool =
    post.score >= minScore and post.created > maxAge.toUnixFloat
  )
