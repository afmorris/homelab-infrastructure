# DNS records for cloverleafthrows.com.
# Generated from the live zone by ./bootstrap.sh (cf-terraforming), then
# hand-maintained. Edit records here, not in the Cloudflare dashboard.

data "cloudflare_zone" "cloverleafthrows_com" {
  filter = {
    name = "cloverleafthrows.com"
  }
}

resource "cloudflare_dns_record" "cloverleafthrows_com_cname_4e8b3325e4043fdd8a5defa59508e897" {
  content = "_bec09f66cf53793a90e818a5f10cb004.jkddzztszm.acm-validations.aws"
  name    = "_4e8b3325e4043fdd8a5defa59508e897.cloverleafthrows.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.cloverleafthrows_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "cloverleafthrows_com_cname_apex" {
  content = "dhennwkv1pzxg.cloudfront.net"
  name    = "cloverleafthrows.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.cloverleafthrows_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "cloverleafthrows_com_cname_www" {
  content = "cloverleafthrows.com"
  name    = "www.cloverleafthrows.com"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.cloverleafthrows_com.id
  settings = {
    flatten_cname = false
  }
}
