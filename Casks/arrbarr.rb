cask "arrbarr" do
  version "1.2.0"
  sha256 "70847b4842baaaf25ea63ef4352d349acb920c30081a2b854a8557d75dbf0ea1"

  url "https://github.com/Preclowski/ArrBarr/releases/download/v#{version}/ArrBarr.dmg"
  name "ArrBarr"
  desc "Menu bar app for monitoring Radarr and Sonarr download queues"
  homepage "https://github.com/Preclowski/ArrBarr"

  depends_on macos: :sonoma

  app "ArrBarr.app"

  # Quit a running instance before the upgrade so the .app on disk can be
  # replaced cleanly. Drop a sentinel file so postflight knows whether to
  # relaunch.
  preflight do
    sentinel = "/tmp/arrbarr-was-running"

    # A leftover sentinel means an earlier upgrade was interrupted; clear it so
    # postflight won't relaunch an app the user isn't currently running.
    stale = File.exist?(sentinel)
    File.delete(sentinel) if stale

    pgrep = system_command "/usr/bin/pgrep",
                           args:         ["-x", "ArrBarr"],
                           must_succeed: false
    if pgrep.success?
      File.write(sentinel, "1")
      system_command "/usr/bin/osascript",
                     args:         ["-e", 'tell application "ArrBarr" to quit'],
                     must_succeed: false
      sleep 1
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

  zap trash: "~/Library/Preferences/pl.incred.ArrBarr.plist"
end
