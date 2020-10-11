import reddit_telegram/reddit
import reddit_telegram/telegram

import logging, os, strformat, times

const NimblePkgVersion {.strdefine.} = ""

var
  lastRun: Time = getTime()
  logger = newConsoleLogger(fmtStr = verboseFmtStr)

addHandler(logger)

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

proc run(subreddit, botKey, chatId: string; minScore: int = 5;
    interval: int = 60; verbose: bool = false): void =
  if verbose:
    setLogFilter(lvlAll)

  info("Starting bot")
  initTelegram(botKey)

  while true:
    info("Grabbing posts")
    for post in getNew(subreddit).postFilter(minScore, lastRun):
      let tgMessage = post.buildTelegramMessage()
      info(&"Posting: {tgMessage}")
      sendMessage(chatId, tgMessage)
    lastRun = getTime()
    sleep(interval * 1000)


when isMainModule:
  import cligen
  include cligen/mergeCfgEnv
  clCfg.version = NimblePkgVersion

  dispatch(
    run,
    cmdName = "reddit_telegram",
    help = {
      "subreddit": "subreddit (singular) from which to fetch",
      "minScore": "minimum score a post can have to be sent to telegram",
      "botKey": "Telegram bot key. Don't add the `bot` prefix",
      "chatId": "Telegram channel id or name. ID is safest",
      "interval": "interval, in seconds, to check reddit for new posts"
    }
  )
