settings: let

  callSettingsIfNeeded = fn:
    # If there are "no arguments", then it is a lambda
    # that requires settings that need to be passed
    if ((builtins.functionArgs fn) == {}) then (fn settings) else fn;
  
  in rec {
  applySettings = module: callSettingsIfNeeded (import module);
  forAllApplySettings = with builtins; modules: map applySettings modules;
}
