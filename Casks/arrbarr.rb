cask "arrbarr" do
  version "0.6.0"
  sha256 "507065d9e845aa2ef09bc7cec33660a9839ab77cee34314cbfd3f1558c25ecd2"

  url "https://github.com/Preclowski/ArrBarr/releases/download/v#{version}/ArrBarr.dmg"
  name "ArrBarr"
  desc "Menu bar app for monitoring Radarr and Sonarr download queues"
  homepage "https://github.com/Preclowski/ArrBarr"

  depends_on macos: ">= :sonoma"

  app "ArrBarr.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/ArrBarr.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Preferences/com.preclowski.ArrBarr.plist",
  ]
end
