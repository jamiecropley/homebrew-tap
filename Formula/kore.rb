class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-4.2.3.tar.gz"
  sha256 "f9a9727af97441ae87ff9250e374b9fe3a32a3348b25cb50bd2b7de5ec7f5d82"
  license "ISC"

  head "https://github.com/jorisvink/kore.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    openssl = Formula["openssl@3"]

    ENV["OPENSSL_PATH"] = openssl.opt_prefix
    ENV.prepend_path "PKG_CONFIG_PATH", openssl.opt_lib/"pkgconfig"

    ENV.deparallelize { system "make", "PREFIX=#{prefix}", "TASKS=1" }
    system "make", "install", "PREFIX=#{prefix}"

    inreplace [pkgshare/"features", pkgshare/"linker"],
              openssl.prefix.realpath, openssl.opt_prefix if OS.mac?
  end

  test do
    port = free_port
    system bin/"kodev", "create", "test"
    inreplace "test/conf/test.conf", "8888", port.to_s

    cd "test" do
      pid = fork do
        exec bin/"kodev", "run"
      end

      begin
        sleep 3
        system "curl", "--fail", "--silent", "--show-error", "--insecure",
               "https://127.0.0.1:#{port}/"
      ensure
        Process.kill("TERM", pid)
        Process.wait(pid)
      end
    end
  end
end
