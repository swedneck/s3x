module github.com/RTradeLtd/s3x

go 1.13

require (
	cloud.google.com/go v0.39.0
	github.com/Azure/azure-pipeline-go v0.2.1
	github.com/Azure/azure-storage-blob-go v0.8.0
	github.com/RTradeLtd/TxPB v1.1.1
	github.com/Shopify/sarama v1.24.1
	github.com/StackExchange/wmi v0.0.0-20190523213315-cbe66965904d // indirect
	github.com/alecthomas/participle v0.2.1
	github.com/aliyun/aliyun-oss-go-sdk v0.0.0-20190307165228-86c17b95fcd5
	github.com/aws/aws-sdk-go v1.20.21
	github.com/bcicen/jstream v0.0.0-20190220045926-16c1f8af81c2
	github.com/beevik/ntp v0.2.0
	github.com/cheggaaa/pb v1.0.28
	github.com/coredns/coredns v1.4.0
	github.com/coreos/etcd v3.3.12+incompatible
	github.com/dgrijalva/jwt-go v3.2.0+incompatible
	github.com/djherbis/atime v1.0.0
	github.com/dustin/go-humanize v1.0.0
	github.com/eclipse/paho.mqtt.golang v1.2.0
	github.com/elazarl/go-bindata-assetfs v1.0.0
	github.com/fatih/color v1.7.0
	github.com/fatih/structs v1.1.0
	github.com/go-ole/go-ole v1.2.4 // indirect
	github.com/go-sql-driver/mysql v1.4.1
	github.com/gogo/protobuf v1.3.1
	github.com/gomodule/redigo v2.0.0+incompatible
	github.com/gorilla/handlers v1.4.0
	github.com/gorilla/mux v1.7.0
	github.com/gorilla/rpc v1.2.0+incompatible
	github.com/hashicorp/vault/api v1.0.4
	github.com/inconshreveable/go-update v0.0.0-20160112193335-8152e7eb6ccf
	github.com/ipfs/go-datastore v0.3.1
	github.com/json-iterator/go v1.1.7
	github.com/klauspost/compress v1.8.3
	github.com/klauspost/pgzip v1.2.1
	github.com/klauspost/readahead v1.3.1
	github.com/klauspost/reedsolomon v1.9.3
	github.com/kurin/blazer v0.5.4-0.20190613185654-cf2f27cc0be3
	github.com/lib/pq v1.1.1
	github.com/mattn/go-ieproxy v0.0.0-20190805055040-f9202b1cfdeb // indirect
	github.com/miekg/dns v1.1.8
	github.com/minio/cli v1.22.0
	github.com/minio/gokrb5/v7 v7.2.5
	github.com/minio/hdfs/v3 v3.0.1
	github.com/minio/highwayhash v1.0.0
	github.com/minio/lsync v1.0.1
	github.com/minio/mc v0.0.0-20191012041914-735aa139b19c
	github.com/minio/minio-go v0.0.0-20190327203652-5325257a208f
	github.com/minio/minio-go/v6 v6.0.39
	github.com/minio/parquet-go v0.0.0-20190318185229-9d767baf1679
	github.com/minio/sha256-simd v0.1.1
	github.com/minio/sio v0.2.0
	github.com/mitchellh/go-homedir v1.1.0
	github.com/nats-io/nats-server/v2 v2.1.2
	github.com/nats-io/nats.go v1.9.1
	github.com/nats-io/stan.go v0.4.5
	github.com/ncw/directio v1.0.5
	github.com/nsqio/go-nsq v1.0.7
	github.com/pkg/errors v0.8.1
	github.com/pkg/profile v1.3.0
	github.com/prometheus/client_golang v0.9.3-0.20190127221311-3c4408c8b829
	github.com/rjeczalik/notify v0.9.2
	github.com/rs/cors v1.6.0
	github.com/secure-io/sio-go v0.3.0
	github.com/shirou/gopsutil v2.18.12+incompatible
	github.com/sirupsen/logrus v1.4.2
	github.com/skyrings/skyring-common v0.0.0-20160929130248-d1c0bb1cbd5e
	github.com/streadway/amqp v0.0.0-20190404075320-75d898a42a94
	github.com/valyala/tcplisten v0.0.0-20161114210144-ceec8f93295a
	go.uber.org/atomic v1.3.2
	golang.org/x/crypto v0.0.0-20191117063200-497ca9f6d64f
	golang.org/x/sys v0.0.0-20190922100055-0a153f010e69
	google.golang.org/api v0.5.0
	google.golang.org/grpc v1.22.0
	gopkg.in/ldap.v3 v3.0.3
	gopkg.in/olivere/elastic.v5 v5.0.80
	gopkg.in/yaml.v2 v2.2.4
)

// Added for go1.13 migration https://github.com/golang/go/issues/32805
replace github.com/gorilla/rpc v1.2.0+incompatible => github.com/gorilla/rpc v1.2.0

// Allow this for offline builds
replace github.com/eapache/go-xerial-snappy => github.com/eapache/go-xerial-snappy v0.0.0-20180814174437-776d5712da21

replace github.com/eapache/queue => github.com/eapache/queue v1.1.0

replace github.com/mattn/go-runewidth => github.com/mattn/go-runewidth v0.0.4

replace github.com/mitchellh/mapstructure => github.com/mitchellh/mapstructure v1.1.2

// Version 1.2.0 adds support for go modules
replace github.com/hashicorp/vault => github.com/hashicorp/vault v1.2.0-beta2
