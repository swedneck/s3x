# MinIO Server Config Guide [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io) [![Docker Pulls](https://img.shields.io/docker/pulls/minio/minio.svg?maxAge=604800)](https://hub.docker.com/r/minio/minio/)

## Configuration Directory

Till MinIO release `RELEASE.2018-08-02T23-11-36Z`, MinIO server configuration file (`config.json`) was stored in the configuration directory specified by `--config-dir` or defaulted to `${HOME}/.minio`. However from releases after `RELEASE.2018-08-18T03-49-57Z`, the configuration file (only), has been migrated to the storage backend (storage backend is the directory passed to MinIO server while starting the server).

You can specify the location of your existing config using `--config-dir`, MinIO will migrate the `config.json` to your backend storage. Your current `config.json` will be renamed upon successful migration as `config.json.deprecated` in your current `--config-dir`. All your existing configurations are honored after this migration.

Additionally `--config-dir` is now a legacy option which will is scheduled for removal in future, so please update your local startup, ansible scripts accordingly.

```sh
minio server /data
```

MinIO also encrypts all the config, IAM and policies content with admin credentials.

### Certificate Directory

TLS certificates by default are stored under ``${HOME}/.minio/certs`` directory. You need to place certificates here to enable `HTTPS` based access. Read more about [How to secure access to MinIO server with TLS](https://docs.min.io/docs/how-to-secure-access-to-minio-server-with-tls).

Following is the directory structure for MinIO server with TLS certificates.

```sh
$ mc tree --files ~/.minio
/home/user1/.minio
└─ certs
   ├─ CAs
   ├─ private.key
   └─ public.crt
```

You can provide a custom certs directory using `--certs-dir` command line option.

#### Credentials
On MinIO admin credentials or root credentials are only allowed to be changed using ENVs namely `MINIO_ACCESS_KEY` and `MINIO_SECRET_KEY`. Using the combination of these two values MinIO encrypts the config stored at the backend.

```
export MINIO_ACCESS_KEY=minio
export MINIO_SECRET_KEY=minio13
minio server /data
```

##### Rotating encryption with new credentials

Additionally if you wish to change the admin credentials, then MinIO will automatically detect this and re-encrypt with new credentials as shown below. For one time only special ENVs as shown below needs to be set for rotating the encryption config.

> Old ENVs are never remembered in memory and are destroyed right after they are used to migrate your existing content with new credentials. You are safe to remove them after the server as successfully started, by restarting the services once again.

```
export MINIO_ACCESS_KEY=newminio
export MINIO_SECRET_KEY=newminio123
export MINIO_ACCESS_KEY_OLD=minio
export MINIO_SECRET_KEY_OLD=minio123
minio server /data
```

Once the migration is complete, server will automatically unset the `MINIO_ACCESS_KEY_OLD` and `MINIO_SECRET_KEY_OLD` with in the process namespace.

> **NOTE: Make sure to remove `MINIO_ACCESS_KEY_OLD` and `MINIO_SECRET_KEY_OLD` in scripts or service files before next service restarts of the server to avoid double encryption of your existing contents.**

#### Region
```
KEY:
region  label the location of the server

ARGS:
name     (string)    name of the location of the server e.g. "us-west-rack2"
comment  (sentence)  optionally add a comment to this setting
```

or environment variables
```
KEY:
region  label the location of the server

ARGS:
MINIO_REGION_NAME     (string)    name of the location of the server e.g. "us-west-rack2"
MINIO_REGION_COMMENT  (sentence)  optionally add a comment to this setting
```

Example:

```sh
export MINIO_REGION_NAME="my_region"
minio server /data
```

### Storage Class
By default, parity for objects with standard storage class is set to `N/2`, and parity for objects with reduced redundancy storage class objects is set to `2`. Read more about storage class support in MinIO server [here](https://github.com/RTradeLtd/s3x/blob/master/docs/erasure/storage-class/README.md).

```
KEY:
storage_class  define object level redundancy

ARGS:
standard  (string)    set the parity count for default standard storage class e.g. "EC:4"
rrs       (string)    set the parity count for reduced redundancy storage class e.g. "EC:2"
comment   (sentence)  optionally add a comment to this setting
```

or environment variables
```
KEY:
storage_class  define object level redundancy

ARGS:
MINIO_STORAGE_CLASS_STANDARD  (string)    set the parity count for default standard storage class e.g. "EC:4"
MINIO_STORAGE_CLASS_RRS       (string)    set the parity count for reduced redundancy storage class e.g. "EC:2"
MINIO_STORAGE_CLASS_COMMENT   (sentence)  optionally add a comment to this setting
```

### Cache
MinIO provides caching storage tier for primarily gateway deployments, allowing you to cache content for faster reads, cost savings on repeated downloads from the cloud.

```
KEY:
cache  add caching storage tier

ARGS:
drives*  (csv)       comma separated mountpoints e.g. "/optane1,/optane2"
expiry   (number)    cache expiry duration in days e.g. "90"
quota    (number)    limit cache drive usage in percentage e.g. "90"
exclude  (csv)       comma separated wildcard exclusion patterns e.g. "bucket/*.tmp,*.exe"
comment  (sentence)  optionally add a comment to this setting
```

or environment variables
```
KEY:
cache  add caching storage tier

ARGS:
MINIO_CACHE_DRIVES*  (csv)       comma separated mountpoints e.g. "/optane1,/optane2"
MINIO_CACHE_EXPIRY   (number)    cache expiry duration in days e.g. "90"
MINIO_CACHE_QUOTA    (number)    limit cache drive usage in percentage e.g. "90"
MINIO_CACHE_EXCLUDE  (csv)       comma separated wildcard exclusion patterns e.g. "bucket/*.tmp,*.exe"
MINIO_CACHE_COMMENT  (sentence)  optionally add a comment to this setting
```

#### Notifications
Notification targets supported by MinIO are in the following list. To configure individual targets please refer to more detailed documentation [here](https://docs.min.io/docs/minio-bucket-notification-guide.html)

```
notify_webhook        publish bucket notifications to webhook endpoints
notify_amqp           publish bucket notifications to AMQP endpoints
notify_kafka          publish bucket notifications to Kafka endpoints
notify_mqtt           publish bucket notifications to MQTT endpoints
notify_nats           publish bucket notifications to NATS endpoints
notify_nsq            publish bucket notifications to NSQ endpoints
notify_mysql          publish bucket notifications to MySQL databases
notify_postgres       publish bucket notifications to Postgres databases
notify_elasticsearch  publish bucket notifications to Elasticsearch endpoints
notify_redis          publish bucket notifications to Redis datastores
```

### Accessing configuration file
All configuration changes can be made using [`mc admin config` get/set commands](https://github.com/minio/mc/blob/master/docs/minio-admin-complete-guide.md). Following sections provide brief explanation of fields and how to customize them. A complete example of `config.json` is available [here](https://raw.githubusercontent.com/minio/minio/master/docs/config/config.sample.json)

## Environment only settings

#### Worm
Enable this to turn on Write-Once-Read-Many. By default it is set to `off`. Set ``MINIO_WORM=on`` environment variable to enable WORM mode.

Example:

```sh
export MINIO_WORM=on
minio server /data
```

### Browser

Enable or disable access to web UI. By default it is set to `on`. You may override this field with `MINIO_BROWSER` environment variable.

Example:

```sh
export MINIO_BROWSER=off
minio server /data
```

### Domain

By default, MinIO supports path-style requests that are of the format http://mydomain.com/bucket/object. `MINIO_DOMAIN` environment variable is used to enable virtual-host-style requests. If the request `Host` header matches with `(.+).mydomain.com` then the matched pattern `$1` is used as bucket and the path is used as object. More information on path-style and virtual-host-style [here](http://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAPI.html)
Example:

```sh
export MINIO_DOMAIN=mydomain.com
minio server /data
```

For advanced use cases `MINIO_DOMAIN` environment variable supports multiple-domains with comma separated values.
```sh
export MINIO_DOMAIN=sub1.mydomain.com,sub2.mydomain.com
minio server /data
```

## Explore Further
* [MinIO Quickstart Guide](https://docs.min.io/docs/minio-quickstart-guide)
* [Configure MinIO Server with TLS](https://docs.min.io/docs/how-to-secure-access-to-minio-server-with-tls)
