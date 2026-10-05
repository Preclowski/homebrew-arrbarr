cask "arrbarr" do
  version "3.3.0"
  sha256 "818a268346d8b3f845c2e6dcd8546f918ed6a4debf445b70ca5b7d31a4fa48ee"

  # 3.x needs macOS 26; older Macs stay on the last release that runs there.
  on_sequoia :or_older do
    version "2.1.0"
    sha256 "50bec837c513fea7f6132260da5b3428b130e4307ca3e9d414a25b787a89486b"
  end

  url "https://github.com/Preclowski/ArrBarr/releases/download/v#{version}/ArrBarr.dmg"
  name "ArrBarr"
  desc "Menu bar app for monitoring Radarr and Sonarr download queues"
  homepage "https://github.com/Preclowski/ArrBarr"

  depends_on macos: :sonoma

  app "ArrBarr.app"

  # Quit a running instance before the upgrade so the .app on disk can be
  # replaced cleanly. A sentinel file tells postflight whether to relaunch it;
  # a leftover one from an interrupted upgrade is cleared first.
  preflight_steps do
    run "/bin/sh",
        args:         [
          "-c",
          "rm -f /tmp/arrbarr-was-running; " \
          "/usr/bin/pgrep -x ArrBarr >/dev/null 2>&1 || exit 0; " \
          ": > /tmp/arrbarr-was-running; " \
          "/usr/bin/osascript -e 'tell application \"ArrBarr\" to quit'; " \
          "sleep 1",
        ],
        must_succeed: false
  end

  postflight_steps do
    run "/usr/bin/xattr", args: ["-cr", "{{appdir}}/ArrBarr.app"]

    if_path_exists "/tmp/arrbarr-was-running" do
      run "/bin/sh",
          args:         [
            "-c",
            "rm -f /tmp/arrbarr-was-running; /usr/bin/open -a '{{appdir}}/ArrBarr.app'",
          ],
          must_succeed: false
    end
  end

  zap trash: "~/Library/Preferences/pl.incred.ArrBarr.plist"
end
