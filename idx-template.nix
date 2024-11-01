{pkgs, template ? "templates/basic", ...}: {
    packages = [
        pkgs.curl
        pkgs.gnutar
        pkgs.xz
        pkgs.git
        pkgs.busybox
    ];
    bootstrap = ''
        mkdir "$out"
        ${
          if template == "samples/ads" then "cp -pPR ${./samples/ads}/* \"$out\""
          else if template == "samples/crossword" then "cp -pPR ${./samples/crossword}/* \"$out\""
          else if template == "samples/multiplayer" then "cp -pPR ${./samples/multiplayer}/* \"$out\""
          else if template == "templates/basic" then "cp -pPR ${./templates/basic}/* \"$out\""
          else if template == "templates/card" then "cp -pPR ${./templates/card}/* \"$out\""
          else if template == "templates/endless_runner" then "cp -pPR ${./templates/endless_runner}/* \"$out\""
          else "cp -pPR ${./templates/basic}/* \"$out\""
        }
        chmod -R u+w "$out"
    '';
}