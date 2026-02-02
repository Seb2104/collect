#ifndef FLUTTER_PLUGIN_collect_PLUGIN_H_
#define FLUTTER_PLUGIN_collect_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace collect {

class collectPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  collectPlugin();

  virtual ~collectPlugin();

  // Disallow copy and assign.
  collectPlugin(const collectPlugin&) = delete;
  collectPlugin& operator=(const collectPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace collect

#endif  // FLUTTER_PLUGIN_collect_PLUGIN_H_
