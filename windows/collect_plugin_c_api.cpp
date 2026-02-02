#include "include/collect/collect_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "collect_plugin.h"

void collectPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  collect::collectPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
