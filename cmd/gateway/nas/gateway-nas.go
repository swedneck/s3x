/*
 * MinIO Cloud Storage, (C) 2018 MinIO, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package nas

import (
	"context"

	"github.com/minio/cli"
	minio "github.com/RTradeLtd/s3x/cmd"
	"github.com/RTradeLtd/s3x/pkg/auth"
)

const (
	nasBackend = "nas"
)

func init() {
	const nasGatewayTemplate = `NAME:
  {{.HelpName}} - {{.Usage}}

USAGE:
  {{.HelpName}} {{if .VisibleFlags}}[FLAGS]{{end}} PATH
{{if .VisibleFlags}}
FLAGS:
  {{range .VisibleFlags}}{{.}}
  {{end}}{{end}}
PATH:
  path to NAS mount point

EXAMPLES:
  1. Start minio gateway server for NAS backend
     {{.Prompt}} {{.EnvVarSetCommand}} MINIO_ACCESS_KEY{{.AssignmentOperator}}accesskey
     {{.Prompt}} {{.EnvVarSetCommand}} MINIO_SECRET_KEY{{.AssignmentOperator}}secretkey
     {{.Prompt}} {{.HelpName}} /shared/nasvol

  2. Start minio gateway server for NAS with edge caching enabled
     {{.Prompt}} {{.EnvVarSetCommand}} MINIO_ACCESS_KEY{{.AssignmentOperator}}accesskey
     {{.Prompt}} {{.EnvVarSetCommand}} MINIO_SECRET_KEY{{.AssignmentOperator}}secretkey
     {{.Prompt}} {{.EnvVarSetCommand}} MINIO_CACHE_DRIVES{{.AssignmentOperator}}"/mnt/drive1,/mnt/drive2,/mnt/drive3,/mnt/drive4"
     {{.Prompt}} {{.EnvVarSetCommand}} MINIO_CACHE_EXCLUDE{{.AssignmentOperator}}"bucket1/*,*.png"
     {{.Prompt}} {{.EnvVarSetCommand}} MINIO_CACHE_EXPIRY{{.AssignmentOperator}}40
     {{.Prompt}} {{.EnvVarSetCommand}} MINIO_CACHE_QUOTA{{.AssignmentOperator}}80
     {{.Prompt}} {{.HelpName}} /shared/nasvol
`

	minio.RegisterGatewayCommand(cli.Command{
		Name:               nasBackend,
		Usage:              "Network-attached storage (NAS)",
		Action:             nasGatewayMain,
		CustomHelpTemplate: nasGatewayTemplate,
		HideHelpCommand:    true,
	})
}

// Handler for 'minio gateway nas' command line.
func nasGatewayMain(ctx *cli.Context) {
	// Validate gateway arguments.
	if !ctx.Args().Present() || ctx.Args().First() == "help" {
		cli.ShowCommandHelpAndExit(ctx, nasBackend, 1)
	}

	minio.StartGateway(ctx, &NAS{ctx.Args().First()})
}

// NAS implements Gateway.
type NAS struct {
	path string
}

// Name implements Gateway interface.
func (g *NAS) Name() string {
	return nasBackend
}

// NewGatewayLayer returns nas gatewaylayer.
func (g *NAS) NewGatewayLayer(creds auth.Credentials) (minio.ObjectLayer, error) {
	var err error
	newObject, err := minio.NewFSObjectLayer(g.path)
	if err != nil {
		return nil, err
	}
	return &nasObjects{newObject}, nil
}

// Production - nas gateway is production ready.
func (g *NAS) Production() bool {
	return true
}

// IsListenBucketSupported returns whether listen bucket notification is applicable for this gateway.
func (n *nasObjects) IsListenBucketSupported() bool {
	return false
}

func (n *nasObjects) StorageInfo(ctx context.Context) minio.StorageInfo {
	sinfo := n.ObjectLayer.StorageInfo(ctx)
	sinfo.Backend.GatewayOnline = sinfo.Backend.Type == minio.BackendFS
	sinfo.Backend.Type = minio.BackendGateway
	return sinfo
}

// nasObjects implements gateway for MinIO and S3 compatible object storage servers.
type nasObjects struct {
	minio.ObjectLayer
}
