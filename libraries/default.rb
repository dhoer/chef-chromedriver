# chromedriver helper
module ChromeDriver
  # Fixes drivers not copied to /selenium/drivers/ folders on Windows 7
  def powershell_version
    out = shell_out!('powershell.exe $host.version.major')
    out.to_i
  rescue # powershell not installed
    -1
  end
end
