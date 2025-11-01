{
  services.music-assistant = {
    enable = true;
    # Optional: Open the default port in the firewall (recommended for remote access)
    # openFirewall = true;
    # Optional: Customize the data directory (default: /var/lib/music-assistant)
    # dataDir = "/path/to/your/data/dir";
    # Optional: Set a custom port (default: 8095)
    # port = 8096;
    # Optional: Pass extra config options as JSON attrs (e.g., for logging; see Music Assistant docs for more)
    extraOptions = {
      log_level = "info"; # Options: debug, info, warning, error
      # enable_tv = true;  # Example: Enable TV features if needed
    };
  };
}
