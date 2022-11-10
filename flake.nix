{
  description = "A flake defining pulumictl build-from-source package";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
    pulumictl-src = {
      url = "github:pulumi/pulumictl/v0.0.36";
      flake = false;
    };
  };

  outputs =
    { self,
      nixpkgs,
      pulumictl-src
    }:

    let
      ver = "0.0.36";

      package = { system }:
        let
          pkgs = import nixpkgs { system = system; };
        in pkgs.buildGo118Module rec {
          name = "pulumictl-${ver}";
          version = "${ver}";
          src = pulumictl-src;
          doCheck = false;
          vendorSha256 = "sha256-R1xrRH3GMR7xSUQ1Fsn9pLa729t5/gnPqAp8As7F+UI=";
          ldflags = ["-X" "github.com/pulumi/pulumictl/pkg/version.Version=${ver}"];
        };
    in {
      packages.x86_64-linux.default = package {
        system = "x86_64-linux";
      };
      packages.x86_64-darwin.default = package {
        system = "x86_64-darwin";
      };
      packages.aarch64-darwin.default = package {
        system = "aarch64-darwin";
      };
    };
}
