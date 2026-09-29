# DNS records for morrisphotos.com.
# Generated from the live zone by ./bootstrap.sh (cf-terraforming), then
# hand-maintained. Edit records here, not in the Cloudflare dashboard.

data "cloudflare_zone" "morrisphotos_com" {
  filter = {
    name = "morrisphotos.com"
  }
}

resource "cloudflare_dns_record" "morrisphotos_com_cname_cdn" {
  content = "d1taa8oxhlkxij.cloudfront.net"
  name    = "cdn.morrisphotos.com"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.morrisphotos_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "morrisphotos_com_cname_email_cdn" {
  content = "mailgun.org"
  name    = "email.cdn.morrisphotos.com"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.morrisphotos_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "morrisphotos_com_cname_email" {
  content = "mailgun.org"
  name    = "email.morrisphotos.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.morrisphotos_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "morrisphotos_com_cname_apex" {
  content = "www.morrisphotos.com"
  name    = "morrisphotos.com"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.morrisphotos_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "morrisphotos_com_cname_www" {
  content = "domains.smugmug.com"
  name    = "www.morrisphotos.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.morrisphotos_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "morrisphotos_com_mx_cdn" {
  content  = "mxb.mailgun.org"
  name     = "cdn.morrisphotos.com"
  priority = 10
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "MX"
  zone_id  = data.cloudflare_zone.morrisphotos_com.id
  settings = {}
}

resource "cloudflare_dns_record" "morrisphotos_com_mx_cdn_2" {
  content  = "mxa.mailgun.org"
  name     = "cdn.morrisphotos.com"
  priority = 10
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "MX"
  zone_id  = data.cloudflare_zone.morrisphotos_com.id
  settings = {}
}

resource "cloudflare_dns_record" "morrisphotos_com_mx_apex" {
  content  = "mxb.mailgun.org"
  name     = "morrisphotos.com"
  priority = 10
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "MX"
  zone_id  = data.cloudflare_zone.morrisphotos_com.id
  settings = {}
}

resource "cloudflare_dns_record" "morrisphotos_com_mx_apex_2" {
  content  = "mxa.mailgun.org"
  name     = "morrisphotos.com"
  priority = 10
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "MX"
  zone_id  = data.cloudflare_zone.morrisphotos_com.id
  settings = {}
}

resource "cloudflare_dns_record" "morrisphotos_com_txt_cdn" {
  content  = "v=spf1 include:mailgun.org ~all"
  name     = "cdn.morrisphotos.com"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.morrisphotos_com.id
  settings = {}
}

resource "cloudflare_dns_record" "morrisphotos_com_txt_keybase" {
  content  = "keybase-site-verification=cetRveIM-puNd_pwqHpbXkcas4ZUEVMhXBQYGXmMQDI"
  name     = "_keybase.morrisphotos.com"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.morrisphotos_com.id
  settings = {}
}

resource "cloudflare_dns_record" "morrisphotos_com_txt_apex" {
  content  = "google-site-verification=ICSu8WwKsksJRW3zF4EDde-AyljVCCxsWMLKNTj4XE8"
  name     = "morrisphotos.com"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.morrisphotos_com.id
  settings = {}
}

resource "cloudflare_dns_record" "morrisphotos_com_txt_apex_2" {
  content  = "v=spf1 include:mailgun.org ~all"
  name     = "morrisphotos.com"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.morrisphotos_com.id
  settings = {}
}

resource "cloudflare_dns_record" "morrisphotos_com_txt_pic_domainkey" {
  content  = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDRFnZH7/rslb3M2DZKAJL+kWGkWLq8053B8YU4KebpBVA9mirPfRRBc/RdhqNyZ/cTJUnfz0fEeXe6qHL3XPvEeYxdur6kUthgvicNHxnuEJ3EAbiriTVfLpGjbidqxWJRSPgpqsGOXYNVeXmHuUrwd4ySEqYJeqwZ3L5Lr0jI4wIDAQAB"
  name     = "pic._domainkey.morrisphotos.com"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.morrisphotos_com.id
  settings = {}
}
