#include "include/n_body/n_body_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "n_body_plugin.h"

void NBodyPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  n_body::NBodyPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
