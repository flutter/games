{pkgs, template ? "templates/basic", ...}: {
    packages = [
        pkgs.curl
        pkgs.gnutar
        pkgs.xz
        pkgs.git
        pkgs.busybox
    ];
    bootstrap = ''
        ${
          if template == "samples/ads" then "cp -r ${./samples/ads}/* \"$out\""
          else if template == "samples/crossword" then "cp -r ${./samples/crossword}/* \"$out\""
          else if template == "samples/multiplayer" then "cp -r ${./samples/multiplayer}/* \"$out\""
          else if template == "templates/basic" then "cp -r ${./templates/basic}/* \"$out\""
          else if template == "templates/card" then "cp -r ${./templates/card}/* \"$out\""
          else if template == "templates/endless_runner" then "cp -r ${./templates/endless_runner}/* \"$out\""
          else "cp -r ${./templates/basic}/* \"$out\""
        }
        chmod -R u+w "$out"
    '';
}