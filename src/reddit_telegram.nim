# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import reddit_telegram/reddit
import reddit_telegram/telegram

import sequtils, strformat, times

proc buildTelegramMessage(data: RedditPost): string =
  let
    title = data.title.escape
    permalink = fmt("https://www.reddit.com{data.permalink}").escape
    author = data.author.escape
    url = data.url.escape

  &"""
[*{title}*]({permalink}) \- _[/u/{author}](https://www.reddit.com/user/{author})_
[link]({url}) • [comments]({permalink})
  """


when isMainModule:
  initTelegram("")
  let ten_ago = getTime() - initDuration(minutes = 10)
  for post in getNew("").postFilter(5, ten_ago):
    let tgMessage = post.buildTelegramMessage()
    sendMessage("", tgMessage)
