#ifndef FLUTTER_PLUGIN_N_BODY_PLUGIN_H_
#define FLUTTER_PLUGIN_N_BODY_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace n_body {

class NBodyPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  NBodyPlugin();

  virtual ~NBodyPlugin();

  // Disallow copy and assign.
  NBodyPlugin(const NBodyPlugin&) = delete;
  NBodyPlugin& operator=(const NBodyPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace n_body

#endif  // FLUTTER_PLUGIN_N_BODY_PLUGIN_H_
