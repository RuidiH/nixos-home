{ pkgs, inputs, lib, osConfig, ... }:
{
  imports = [ inputs.noctalia.homeModules.default ];
  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        density = "compact";
        position = "top";
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              id = "Workspace";
            }
          ];
          center = [
            {
              id = "SystemMonitor";
              alwaysShowPercentage = false;
            }
          ];
          right = [
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
            }
            {
              alwaysShowPercentage = true;
              id = "Battery";
              warningThreshold = 20;
            }
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };
      wallpaper = {
        enabled = true;
      } // lib.optionalAttrs (osConfig.networking.hostName == "jz") {
        directory = "/home/reedh/Downloads/Wallpapers";
        sortOrder = "random";
        automationEnabled = true;
        wallpaperChangeMode = "random";
        randomIntervalSec = 600;
      };
      colorSchemes = {
        predefinedScheme = "Monochrome";
        useWallpaperColors = false;
        darkMode = true;
        schedulingMode = "off";
      };
      general = {
        radiusRatio = 0.2;
      };
      location = {
        monthBeforeDay = true;
        name = "Vancouver, Canada";
      };
      systemMonitor = {
        cpuWarningThreshold = 80;
        cpuCriticalThreshold = 90;
        tempWarningThreshold = 80;
        tempCriticalThreshold = 90;
        memWarningThreshold = 80;
        memCriticalThreshold = 90;
        diskWarningThreshold = 80;
        diskCriticalThreshold = 90;
        cpuPollingInterval = 3000;
        tempPollingInterval = 3000;
        enableDgpuMonitoring = false;
        memPollingInterval = 3000;
        diskPollingInterval = 3000;
        networkPollingInterval = 3000;
        loadAvgPollingInterval = 3000;
        useCustomColors = false;
        warningColor = "";
        criticalColor = "";
        externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
      };
    };
  };
}
