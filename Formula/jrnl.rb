class Jrnl < Formula
  desc "Command-line note taker"
  homepage "https://maebert.github.io/jrnl/"
  url "https://github.com/maebert/jrnl/archive/1.9.7.tar.gz"
  sha256 "789de4bffe0c22911a4968e525feeb20a6c7c4f4fe762a936ce2dac2213cd855"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "d39c2cddcdb82f8cf149007e394d99ef5375c476c0b2042d506ee42b4db5aa86" => :el_capitan
    sha256 "ff4480428569daf2f93a5d7695ccf7c530797cf5d25b42f9ead70b6764549be9" => :yosemite
    sha256 "34e9c83cd58485a32877f7ceb7612cb38e7633732bd753850f52d502d7fd0f22" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/ff/58/f3393b41852c1a1b12a9fcdfb468f638d0808c3520f23cc7c13f8f6c14e0/keyring-9.3.tar.gz"
    sha256 "5c6cc42902c2135e4cb674b9108fc7a9ddb9550466dc332640ca89034984f7c2"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/8b/20/37822d52be72c99cad913fad0b992d982928cac882efbbc491d4b9d216a9/parsedatetime-2.1.tar.gz"
    sha256 "17c578775520c99131634e09cfca5a05ea9e1bd2a05cd06967ebece10df7af2d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/b4/7c/df59c89a753eb33c7c44e1dd42de0e9bc2ccdd5a4d576e0bfad97cc280cb/python-dateutil-1.5.tar.gz"
    sha256 "6f197348b46fb8cdf9f3fcfc2a7d5a97da95db3e2e8667cf657216274fe1b009"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f4/7d/7c0c85e9c64a75dde11bc9d3e1adc4e09a42ce7cdb873baffa1598118709/pytz-2016.4.tar.bz2"
    sha256 "ee7c751544e35a7b7fb5e3fb25a49dade37d51e70a93e5107f10575d7102c311"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/a0/41/c722d033d62f1b3aa01ed55b9ca03d049e72bba1c08c60150a327ba80add/tzlocal-1.2.2.tar.gz"
    sha256 "cbbaa4e9d25c36386f12af9febe315139fdd39317b91abcb42d782a5e93e525d"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"write_journal.sh").write <<-EOS.undent
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/jrnl today: Wrote this fancy test.
      expect -exact "Path to your journal file (leave blank for ~/journal.txt):"
      send -- "#{testpath}/journal\n"
      expect -exact "Enter password for journal (leave blank for no encryption): "
      send -- "Homebrew\n"
      expect "Do you want to store the password in your keychain?"
      send -- "N\n"
      expect -exact "Journal will be encrypted."
      expect "Entry added to default journal"
      expect eof
    EOS
    chmod 0755, testpath/"write_journal.sh"

    system "./write_journal.sh"
    assert File.exist?("journal")
    assert File.exist?(".jrnl_config")
  end
end
