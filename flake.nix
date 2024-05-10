{
  description = "A flake defining pulumictl build-from-source package";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;
    pulumictl-src = {
      url = "github:pulumi/pulumictl/v0.0.46";
      flake = false;
    };
  };

  outputs =
    { self,
      nixpkgs,
      pulumictl-src
    }:

    let
      ver = "0.0.46";

      package = { system }:
        let
          pkgs = import nixpkgs { system = system; };
        in pkgs.buildGoModule rec {
          name = "pulumictl-${ver}";
          version = "${ver}";
          src = pulumictl-src;
          subPackages = [ "cmd/pulumictl" ];
          doCheck = false;
          vendorSha256 = "sha256-Wktr3TXSIIzbkiT3Gk5i4K58gahnxySi6ht30li+Z0o=";
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
