# DNS records for wildeyed.cloud.
# Generated from the live zone by ./bootstrap.sh (cf-terraforming), then
# hand-maintained. Edit records here, not in the Cloudflare dashboard.

data "cloudflare_zone" "wildeyed_cloud" {
  filter = {
    name = "wildeyed.cloud"
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_argocd" {
  content = "3d968613-c11f-4954-909f-04413d4c492e.cfargotunnel.com"
  name    = "argocd.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_auth" {
  content = "0196f02a-c5e4-41ed-8e1b-24b81fdc52b6.cfargotunnel.com"
  name    = "auth.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_awx" {
  content = "0196f02a-c5e4-41ed-8e1b-24b81fdc52b6.cfargotunnel.com"
  name    = "awx.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_backup" {
  content = "0196f02a-c5e4-41ed-8e1b-24b81fdc52b6.cfargotunnel.com"
  name    = "backup.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_books" {
  content = "d3a95bbc-e2e8-4adb-b6b4-995532f223bc.cfargotunnel.com"
  name    = "books.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_code" {
  content = "d3a95bbc-e2e8-4adb-b6b4-995532f223bc.cfargotunnel.com"
  name    = "code.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_ctf" {
  content = "0196f02a-c5e4-41ed-8e1b-24b81fdc52b6.cfargotunnel.com"
  name    = "ctf.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_dns" {
  content = "057c5d0f-14e9-4b25-8b7a-2b16ce4a42fa.cfargotunnel.com"
  name    = "dns.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_docs" {
  content = "d3a95bbc-e2e8-4adb-b6b4-995532f223bc.cfargotunnel.com"
  name    = "docs.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_download" {
  content = "e804668e-ad14-4f88-95de-07b7b51db648.cfargotunnel.com"
  name    = "download.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_gitlab" {
  content = "66450cb4-9fea-4244-bca2-501051263cdb.cfargotunnel.com"
  name    = "gitlab.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_movies" {
  content = "1858eba4-fed5-4060-beef-04a52c3cc861.cfargotunnel.com"
  name    = "movies.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_mssql" {
  content = "212fccbb-8f4b-4bcc-ae5e-306aa4b95f6b.cfargotunnel.com"
  name    = "mssql.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_next" {
  content = "d3a95bbc-e2e8-4adb-b6b4-995532f223bc.cfargotunnel.com"
  name    = "next.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_notifiarr" {
  content = "d7f58213-036c-44bf-a7a9-e4508893730f.cfargotunnel.com"
  name    = "notifiarr.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_photos" {
  content = "0196f02a-c5e4-41ed-8e1b-24b81fdc52b6.cfargotunnel.com"
  name    = "photos.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_portainer" {
  content = "0196f02a-c5e4-41ed-8e1b-24b81fdc52b6.cfargotunnel.com"
  name    = "portainer.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_proxmox" {
  content = "4a8c9896-0b09-4c90-9d0d-e6f11c24960e.cfargotunnel.com"
  name    = "proxmox.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_racktables" {
  content = "9ddd9bf4-38f8-4b02-a9ed-367a14973ed1.cfargotunnel.com"
  name    = "racktables.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_request" {
  content = "d3a95bbc-e2e8-4adb-b6b4-995532f223bc.cfargotunnel.com"
  name    = "request.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_truenas" {
  content = "75bf1090-6345-4174-a494-b1e63028555a.cfargotunnel.com"
  name    = "truenas.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_cname_tv" {
  content = "34f0ed35-7a39-4039-b7b5-91b6c3a1149e.cfargotunnel.com"
  name    = "tv.wildeyed.cloud"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.wildeyed_cloud.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "wildeyed_cloud_mx_apex" {
  content  = "route3.mx.cloudflare.net"
  name     = "wildeyed.cloud"
  priority = 78
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "MX"
  zone_id  = data.cloudflare_zone.wildeyed_cloud.id
  settings = {}
}

resource "cloudflare_dns_record" "wildeyed_cloud_mx_apex_2" {
  content  = "route2.mx.cloudflare.net"
  name     = "wildeyed.cloud"
  priority = 28
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "MX"
  zone_id  = data.cloudflare_zone.wildeyed_cloud.id
  settings = {}
}

resource "cloudflare_dns_record" "wildeyed_cloud_mx_apex_3" {
  content  = "route1.mx.cloudflare.net"
  name     = "wildeyed.cloud"
  priority = 15
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "MX"
  zone_id  = data.cloudflare_zone.wildeyed_cloud.id
  settings = {}
}

resource "cloudflare_dns_record" "wildeyed_cloud_txt_cf2024_1_domainkey" {
  content  = "\"v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiweykoi+o48IOGuP7GR3X0MOExCUDY/BCRHoWBnh3rChl7WhdyCxW3jgq1daEjPPqoi7sJvdg5hEQVsgVRQP4DcnQDVjGMbASQtrY4WmB1VebF+RPJB2ECPsEDTpeiI5ZyUAwJaVX7r6bznU67g7LvFq35yIo4sdlmtZGV+i0H4cpYH9+3JJ78k\" \"m4KXwaf9xUJCWF6nxeD+qG6Fyruw1Qlbds2r85U9dkNDVAS3gioCvELryh1TxKGiVTkg4wqHTyHfWsp7KD3WQHYJn0RyfJJu6YEmL77zonn7p2SRMvTMP3ZEXibnC9gz3nnhR6wcYL8Q7zXypKTMD58bTixDSJwIDAQAB\""
  name     = "cf2024-1._domainkey.wildeyed.cloud"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.wildeyed_cloud.id
  settings = {}
}

resource "cloudflare_dns_record" "wildeyed_cloud_txt_apex" {
  content  = "v=spf1 include:_spf.mx.cloudflare.net ~all"
  name     = "wildeyed.cloud"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.wildeyed_cloud.id
  settings = {}
}
