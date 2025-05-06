#!/usr/bin/env python3
import signal
import time
import psutil
import threading
import gi
gi.require_version("Gtk", "3.0")
gi.require_version("AppIndicator3", "0.1")
from gi.repository import Gtk, GLib, AppIndicator3

# Try to get CPU temperature
def get_cpu_temp():
    temps = psutil.sensors_temperatures()
    for name in temps:
        for entry in temps[name]:
            if "cpu" in entry.label.lower() or "package" in entry.label.lower():
                return f"{entry.current:.1f}°C"
    return "N/A"

def get_stats():
    cpu = psutil.cpu_percent()
    ram = psutil.virtual_memory().percent
    temp = get_cpu_temp()
    return f"CPU: {cpu:.0f}%  RAM: {ram:.0f}%  Temp: {temp}"

class SysIndicator:
    def __init__(self):
        self.indicator = AppIndicator3.Indicator.new(
            "sys-monitor-indicator",
            "utilities-system-monitor",
            AppIndicator3.IndicatorCategory.SYSTEM_SERVICES
        )
        self.indicator.set_status(AppIndicator3.IndicatorStatus.ACTIVE)

        # Empty menu with just a Quit option
        self.menu = Gtk.Menu()
        quit_item = Gtk.MenuItem(label="Quit")
        quit_item.connect("activate", self.quit)
        self.menu.append(quit_item)
        self.menu.show_all()

        self.indicator.set_menu(self.menu)
        self.update_label()

    def update_label(self):
        stats = get_stats()
        self.indicator.set_label(stats, "")
        GLib.timeout_add_seconds(2, self.update_label)  # update every 2 seconds
        return False

    def quit(self, source):
        Gtk.main_quit()

def main():
    signal.signal(signal.SIGINT, signal.SIG_DFL)
    SysIndicator()
    Gtk.main()

if __name__ == "__main__":
    main()
