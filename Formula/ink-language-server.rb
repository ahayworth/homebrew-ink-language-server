require "fileutils"
require "json"
require "language/node"

class InkLanguageServer < Formula
  desc "A language server for inkle's Ink."
  homepage "https://github.com/ephread/ink-language-server"
  url "https://registry.npmjs.org/ink-language-server/-/ink-language-server-0.2.3.tgz"
  version "0.2.3"
  sha256 "987d41a2c9a9edcda36369e8d7b9c30173f0e82603ded7df605c3c9bd9df404c"

  depends_on "node"
  depends_on "inklecate"

  head "https://github.com/ephread/ink-language-server.git"

  def install
    package_json = JSON.parse(File.read("package.json"))
    ENV['npm_package_engines_vscode'] = package_json['engines']['vscode']
    if build.head?
      system "npm", "install", "typescript", *Language::Node.local_npm_install_args
      system "./node_modules/.bin/tsc", "-p", "./"
    end
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "install", "pkg", *Language::Node.local_npm_install_args
    system "./node_modules/.bin/pkg", "lib/server.js", "-o", "ink-language-server"
    bin.install "ink-language-server"
  end
end
