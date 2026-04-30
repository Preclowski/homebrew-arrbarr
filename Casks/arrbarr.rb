cask "arrbarr" do
  version "0.8.5"
  sha256 "8030183880f5d7d12ab078006c16dc4c7fb1090d11449601b9748c616ff25a86"

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
