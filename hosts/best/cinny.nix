{ config, lib, pkgs, ... }: let
  inherit (lib) flip merge;
  inherit (lib.strings) toJSON;

  fqdn = "cinny.rgbcu.be";
  root = pkgs.cinny;

  cinnyConfig = {
    allowCustomHomeservers = false;
    homeserverList         = [ "rgbcu.be" ];
    defaultHomeserver      = 0;

    hashRouter = {
      enabled  = false;
      basename = "/";
    };

    featuredCommunities = {
      openAsDefault = false;

      servers = [
        "rgbcu.be"
        "matrix.org"
        "privatevoid.net"
        "notashelf.dev"
        "outfoxxed.me"
      ];

      spaces = [
        "#nixos-fallout:privatevoid.net"
        "#ferronweb:matrix.org"
      ];

      rooms = [
        "#ferronweb-general:matrix.org"
        "#ferronweb-development:matrix.org"
      ];
    };
  };
in {
  nixpkgs.overlays = [(self: super: {
    cinny-unwrapped = flip self.callPackage {} ({
      lib,
      buildNpmPackage,
      fetchFromGitHub,
      giflib,
      python3,
      pkg-config,
      pixman,
      cairo,
      pango,
      stdenv,
    }:

    buildNpmPackage {
      pname = "cinny";
      version = "4.8.0";

      src = fetchFromGitHub {
        owner = "RGBCube";
        repo  = "cinny";
        rev   = "becc5f65820c6bf0d9acf3ddf5519519c3e174ad";
        hash  = "sha256-Ym7BzkWjwR+ojP5jGBeHJeH03PZFuiME54RILR7pDqs=";
      };

      npmDepsHash = "sha256-LZLaaFL7vmFos3TCL4brT6gyEpZFjctsag6uH4CQPdI=";

      nativeBuildInputs = [
        python3
        pkg-config
      ];

      buildInputs = [
        pixman
        cairo
        pango
      ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ giflib ];

      installPhase = ''
        runHook preInstall

        cp -r dist $out

        runHook postInstall
      '';

      meta = {
        description = "Yet another Matrix client for the web";
        homepage    = "https://cinny.in/";
        license     = lib.licenses.agpl3Only;
        platforms   = lib.platforms.all;
      };
    });
  })];

  services.nginx.virtualHosts.${fqdn} = merge config.services.nginx.sslTemplate {
    inherit root;

    locations."= /config.json".extraConfig = /* nginx */ ''
      default_type application/json;
      return 200 '${toJSON cinnyConfig}';
    '';

    extraConfig = /* nginx */ ''
      rewrite ^/config.json$ /config.json break;
      rewrite ^/manifest.json$ /manifest.json break;

      rewrite ^/sw.js$ /sw.js break;
      rewrite ^/pdf.worker.min.js$ /pdf.worker.min.js break;

      rewrite ^/public/(.*)$ /public/$1 break;
      rewrite ^/assets/(.*)$ /assets/$1 break;

      rewrite ^(.+)$ /index.html break;
    '';
  };
}
