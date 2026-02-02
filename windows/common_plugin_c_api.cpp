#include "include/willow_data/willow_data_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "willow_data_plugin.h"

void willow_dataPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  willow_data::willow_dataPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
