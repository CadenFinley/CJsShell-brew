class Cjsh < Formula
  desc "CJ's Shell"
  homepage "https://github.com/CadenFinley/CJsShell"
  url "https://github.com/CadenFinley/CJsShell.git",
      tag:      "2.0.2.4",
      revision: "7daa3f941777f8d8fd75a0130714b1ff70597859"
  version "2.0.2.4"

  license "MIT"

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "pkg-config" => :build

  def install
    mkdir "build" do
      system "cmake", "..",
             "-DCMAKE_BUILD_TYPE=Release",
             "-DCMAKE_INSTALL_PREFIX=#{prefix}",
             "-DCMAKE_PREFIX_PATH=#{Formula["openssl@3"].opt_prefix}",
             *std_cmake_args
      system "make"
      bin.install "cjsh"
    end
  end

  def post_install
    original_shell = ENV["SHELL"]
    (prefix/"original_shell.txt").write original_shell
  end

  def post_uninstall
    original = (prefix/"original_shell.txt").read.chomp rescue nil
    return if original.to_s.empty?
    ohai "Restoring your original shell to #{original}"
    safe_system "sudo", "chsh", "-s", original, ENV["USER"]
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/cjsh --version")
  end
end
