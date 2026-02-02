#ifndef FLUTTER_PLUGIN_willow_data_PLUGIN_H_
#define FLUTTER_PLUGIN_willow_data_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace willow_data {

class willow_dataPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  willow_dataPlugin();

  virtual ~willow_dataPlugin();

  // Disallow copy and assign.
  willow_dataPlugin(const willow_dataPlugin&) = delete;
  willow_dataPlugin& operator=(const willow_dataPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace willow_data

#endif  // FLUTTER_PLUGIN_willow_data_PLUGIN_H_
