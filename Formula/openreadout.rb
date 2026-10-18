# OpenReadout 0.4.0: installs the prebuilt, statically linked release binary.
# Rendered from the template https://github.com/openreadout/openreadout/blob/main/packaging/homebrew/openreadout.rb
class Openreadout < Formula
  desc "Read raw lab-instrument files and export them to open formats"
  homepage "https://github.com/openreadout/openreadout"
  version "0.4.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/openreadout/openreadout/releases/download/v0.4.0/openreadout-aarch64-apple-darwin.tar.gz"
      sha256 "0668cc71c9a93280d9b4dc0eb72f5e7e72ceb43a2f038587550aa727ab79b8d0"
    end
    on_intel do
      url "https://github.com/openreadout/openreadout/releases/download/v0.4.0/openreadout-x86_64-apple-darwin.tar.gz"
      sha256 "7107822130023020825dde44502ef6845df66bfa852e672713aa3660077eb4c8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/openreadout/openreadout/releases/download/v0.4.0/openreadout-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d1576775a3e971d61ee5bec42cc7ba4ffbc04aa820bf4cb7bdd074d849dfd523"
    end
    on_intel do
      url "https://github.com/openreadout/openreadout/releases/download/v0.4.0/openreadout-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7696c3a923ba677f0b79ea32b2fb6d45f69c8950e2934f11cbbc3184eb636431"
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
