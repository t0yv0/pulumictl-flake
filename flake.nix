{
  description = "A flake defining pulumictl build-from-source package";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;
    pulumictl-src = {
      url = "github:pulumi/pulumictl/v0.0.42";
      flake = false;
    };
  };

  outputs =
    { self,
      nixpkgs,
      pulumictl-src
    }:

    let
      ver = "0.0.42";

      package = { system }:
        let
          pkgs = import nixpkgs { system = system; };
        in pkgs.buildGoModule rec {
          name = "pulumictl-${ver}";
          version = "${ver}";
          src = pulumictl-src;
          subPackages = [ "cmd/pulumictl" ];
          doCheck = false;
          vendorSha256 = "sha256-WzfTS68YIpoZYbm6i0USxXyEyR4px+hrNRbsCTXdJsk=";
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
