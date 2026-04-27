cask "arrbarr" do
  version "0.1.0"
  sha256 "PLACEHOLDER_SHA256"

  url "https://github.com/Preclowski/ArrBarr/releases/download/v#{version}/ArrBarr.dmg"
  name "ArrBarr"
  desc "Menu bar app for monitoring Radarr and Sonarr download queues"
  homepage "https://github.com/Preclowski/ArrBarr"

  depends_on macos: ">= :sonoma"

  app "ArrBarr.app"

  zap trash: [
    "~/Library/Preferences/com.preclowski.ArrBarr.plist",
  ]
end
