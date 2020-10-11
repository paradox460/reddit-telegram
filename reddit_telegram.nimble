# Package

version       = "0.1.0"
author        = "Jeff Sandberg"
description   = "Bot for taking reddit posts and pushing them to a telegram group or channel"
license       = "MIT"
srcDir        = "src"
binDir        = "bin/"
bin           = @["reddit_telegram"]



# Dependencies

requires "nim >= 1.2.4, cligen >= 1.2.2 & < 1.3"

task upx, "Build minified binary":
  let args = "nimble build -d:release"
  exec args

  if findExe("upx") != "":
    echo "Running `upx --best`"
    exec "upx --best bin/reddit_telegram"

  if findExe("sha256sum") != "":
    echo "Generating sha256 sum"
    exec "sha256sum bin/reddit_telegram"
