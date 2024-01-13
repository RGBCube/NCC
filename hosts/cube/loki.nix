{ config, ulib, ... }: with ulib;

serverSystemConfiguration {
  services.grafana.provision.datasources.settings.datasources = [{
    name = "Loki";
    type = "loki";
    url  = "http://[::]:${toString config.services.promtail.configuration.server.http_listen_port}";
  }];

  services.promtail = enabled {
    configuration = {
      server.http_listen_port = 9002;
      server.grpc_listen_port = 0;

      positions.filename = "/tmp/promtail-positions.yml";

      clients = [{
        url = "http://[::]:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
      }];

      scrape_configs = [{
        job_name = "journal";

        journal.max_age = "1w";
        journal.labels  = {
          job = "journal";
          host = config.networking.hostName;
        };

        relabel_configs = [{
          source_labels = [ "__journal__systemd_unit" ];
          target_label  = "journal";
        }];
      }];
    };
  };

  services.loki = enabled {
    configuration = {
      auth_enabled = false;

      server.http_listen_port = 9001;

      ingester = {
        lifecycler.address     = "::";

        lifecycler.ring = {
          kvstore.store      = "inmemory";
          replication_factor = 1;
        };

        chunk_idle_period    = "1h";
        chunk_retain_period  = "1h";
        chunk_target_size    = 999999;
        max_chunk_age        = "1h";
        max_transfer_retries = 0;
      };

      schema_config.configs = [{
        from   = "2022-06-06";
        schema = "v12";

        store        = "boltdb-shipper";
        object_store = "filesystem";

        index.period = "24h";
        index.prefix = "index_";
      }];

      storage_config = {
        filesystem.directory = "/var/lib/loki/chunks";

        boltdb_shipper = {
          active_index_directory = "/var/lib/loki/boltdb-shipper-active";
          cache_location         = "/var/lib/loki/boltdb-shipper-cache";
          cache_ttl              = "1d";
          shared_store           = "filesystem";
        };
      };

      limits_config = {
        reject_old_samples         = true;
        reject_old_samples_max_age = "2w";
      };

      chunk_store_config.max_look_back_period = "0s";

      table_manager = {
        retention_deletes_enabled = false;
        retention_period          = "0s";
      };

      compactor = {
        compactor_ring.kvstore.store = "inmemory";
        shared_store                 = "filesystem";

        working_directory = "/var/lib/loki";
      };
    };
  };
}
