# OpenReadout 0.1.0: installs the prebuilt, statically linked release binary.
# Rendered from https://github.com/openreadout/openreadout/blob/main/packaging/homebrew/openreadout.rb

class Openreadout < Formula
  desc "Read raw lab-instrument files and export them to open formats"
  homepage "https://github.com/openreadout/openreadout"
  version "0.1.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/openreadout/openreadout/releases/download/v0.1.0/openreadout-aarch64-apple-darwin.tar.gz"
      sha256 "f74de553f2db8b3d440240993322e30e570af88129687076db73c23bdba8d3f0"
    end
    on_intel do
      url "https://github.com/openreadout/openreadout/releases/download/v0.1.0/openreadout-x86_64-apple-darwin.tar.gz"
      sha256 "0563c53e2dbf8a1dcfddecf624222e5b66764bfba9a378196469980ed72ac8e3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/openreadout/openreadout/releases/download/v0.1.0/openreadout-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7de9dde069fcf65d910f785eaa93bc252df72ec88199a3b49efaa9a4747204e5"
    end
    on_intel do
      url "https://github.com/openreadout/openreadout/releases/download/v0.1.0/openreadout-x86_64-unknown-linux-musl.tar.gz"
      sha256 "776fb7528609366adef5c5acfa0545797c561fbcd3c7d90b5ed32c9de533a202"
    end
  end

  def install
    bin.install "openreadout"
    doc.install "README.md", "SKILL.md", "references"
    doc.install "THIRD-PARTY-NOTICES.md" if File.exist?("THIRD-PARTY-NOTICES.md")
    # Man pages and completions (`cargo xtask man`) ship in every release archive; the guards
    # keep an archive without them installable.
    man1.install Dir["man/*.1"] if Dir.exist?("man")
    if Dir.exist?("completions")
      bash_completion.install "completions/openreadout.bash" => "openreadout"
      zsh_completion.install "completions/_openreadout"
      fish_completion.install "completions/openreadout.fish"
    end
  end

  def caveats
    <<~EOS
      Agent skill:  openreadout self skill --install all
      MCP server:   openreadout mcp --config claude
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openreadout --version")
    assert_match "czi", shell_output("#{bin}/openreadout self formats --json")
    assert_match "\"ok\": true", shell_output("#{bin}/openreadout self doctor --json")
  end
end
