import httpclient, json, nre, strformat

var
  TelegramClient: HttpClient
  TelegramToken: string


proc initTelegram*(token: string): void =
  TelegramClient = newHttpClient()
  TelegramClient.headers = newHttpHeaders({ "Content-Type": "application/json" })
  TelegramToken = token

proc sendMessage*(chat_id: string, text: string): void =
  var message = %*{
    "chat_id": chat_id,
    "text": text,
    "parse_mode": "MarkdownV2"

  }
  let response = TelegramClient.post(url = fmt("https://api.telegram.org/bot{TelegramToken}/sendMessage"), body = $message)

  if response.code != Http200:
    raise newException(HttpRequestError, fmt"Telegram post returned code {response.code}")

  return


proc escape*(text: string): string =
  return text.replace(re"([_*\\[\]()~`\->#+=|{}.!])", "\\$1")
