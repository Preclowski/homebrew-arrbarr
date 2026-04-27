cask "arrbarr" do
  version "0.2.0"
  sha256 "53fe051f320682bf97ec386084e119220f2e5248987fa90b65b99c92cbe2fbdb"

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
