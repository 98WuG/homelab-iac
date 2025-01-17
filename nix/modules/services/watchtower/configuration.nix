# Auto-generated using compose2nix v0.3.2-pre.
{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    watchtower = with lib; {
      hostname = mkOption {
        type = types.str;
        description = "hostname for usage with watchtower";
      };
    };
  };
  config = {
    sops.secrets.ntfy-url = { };

    # Containers
    virtualisation.oci-containers.containers."watchtower-watchtower" = {
      image = "containrrr/watchtower";
      environment = {
        "WATCHTOWER_NOTIFICATIONS" = "shoutrrr";
        "WATCHTOWER_NOTIFICATIONS_HOSTNAME" = config.watchtower.hostname;
        "WATCHTOWER_NOTIFICATIONS_SKIP_TITLE" = "true";
        "WATCHTOWER_NOTIFICATION_URL" = "/url";
      };
      volumes = [
        "${config.sops.secrets.ntfy-url.path}:/url:ro"
        "/var/run/podman/podman.sock:/var/run/docker.sock:rw"
      ];
      cmd = [
        "--cleanup"
        "--interval"
        "43200"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=watchtower"
        "--network=watchtower_default"
      ];
    };
    systemd.services."podman-watchtower-watchtower" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [ "podman-network-watchtower_default.service" ];
      requires = [ "podman-network-watchtower_default.service" ];
      partOf = [ "podman-compose-watchtower-root.target" ];
      wantedBy = [ "podman-compose-watchtower-root.target" ];
    };

    # Networks
    systemd.services."podman-network-watchtower_default" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "podman network rm -f watchtower_default";
      };
      script = ''
        podman network inspect watchtower_default || podman network create watchtower_default
      '';
      partOf = [ "podman-compose-watchtower-root.target" ];
      wantedBy = [ "podman-compose-watchtower-root.target" ];
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    systemd.targets."podman-compose-watchtower-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
