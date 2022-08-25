{
  description = "A flake defining pulumictl build-from-source package";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
    pulumictl-src = {
      url = "github:pulumi/pulumictl/v0.0.32";
      flake = false;
    };
  };

  outputs =
    { self,
      nixpkgs,
      pulumictl-src
    }:

    let
      ver = "0.0.32";

      package = { system }:
        let
          pkgs = import nixpkgs { system = system; };
        in pkgs.buildGoModule rec {
          name = "pulumictl-${ver}";
          version = "${ver}";
          src = pulumictl-src;
          doCheck = false;
          vendorSha256 = "0szp7gibv8bh6jkca71mkqgww2m6fghxny30kdpz0v1snyf5zaf5";
          ldflags = ["-X" "github.com/pulumi/pulumictl/pkg/version.Version=${ver}"];
        };
    in {
      packages.x86_64-linux.default = package {
        system = "x86_64-linux";
      };
      packages.x86_64-darwin.default = package {
        system = "x86_64-darwin";
      };
    };
}
