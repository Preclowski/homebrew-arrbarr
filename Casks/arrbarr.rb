cask "arrbarr" do
  version "0.9.0"
  sha256 "5ce791073962cc9aaace42285a43e32331333bb757b3ca5e8449cf32d285d58a"

  url "https://github.com/Preclowski/ArrBarr/releases/download/v#{version}/ArrBarr.dmg"
  name "ArrBarr"
  desc "Menu bar app for monitoring Radarr and Sonarr download queues"
  homepage "https://github.com/Preclowski/ArrBarr"

  depends_on macos: ">= :sonoma"

  app "ArrBarr.app"

  # Quit a running instance before the upgrade so the .app on disk can be
  # replaced cleanly. Drop a sentinel file so postflight knows whether to
  # relaunch.
  preflight do
    sentinel = "/tmp/arrbarr-was-running"
    pgrep = system_command "/usr/bin/pgrep",
                           args: ["-x", "ArrBarr"],
                           must_succeed: false
    if pgrep.success?
      File.write(sentinel, "1")
      system_command "/usr/bin/osascript",
                     args: ["-e", 'tell application "ArrBarr" to quit'],
                     must_succeed: false
      sleep 1
    elsif File.exist?(sentinel)
      File.delete(sentinel)
    end
  end

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/ArrBarr.app"],
                   sudo: false
    sentinel = "/tmp/arrbarr-was-running"
    if File.exist?(sentinel)
      File.delete(sentinel)
      system_command "/usr/bin/open",
                     args: ["-a", "#{appdir}/ArrBarr.app"],
                     sudo: false
    end
  end

  zap trash: [
    "~/Library/Preferences/com.preclowski.ArrBarr.plist",
  ]
end
