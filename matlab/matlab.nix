{ common, buildFHSUserEnv }:
let
  
in
buildFHSUserEnv {
  name = "matlab";

  targetPkgs = pkgs: with pkgs; common.targetPkgs pkgs;

  runScript = "${common.runPath}/bin/matlab";
}
