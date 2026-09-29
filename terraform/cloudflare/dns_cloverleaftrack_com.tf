# DNS records for cloverleaftrack.com.
# Generated from the live zone by ./bootstrap.sh (cf-terraforming), then
# hand-maintained. Edit records here, not in the Cloudflare dashboard.

data "cloudflare_zone" "cloverleaftrack_com" {
  filter = {
    name = "cloverleaftrack.com"
  }
}

resource "cloudflare_dns_record" "cloverleaftrack_com_caa_apex" {
  name    = "cloverleaftrack.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CAA"
  zone_id = data.cloudflare_zone.cloverleaftrack_com.id
  data = {
    flags = 0
    tag   = "issue"
    value = "amazonaws.com"
  }
  settings = {}
}

resource "cloudflare_dns_record" "cloverleaftrack_com_caa_apex_2" {
  name    = "cloverleaftrack.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CAA"
  zone_id = data.cloudflare_zone.cloverleaftrack_com.id
  data = {
    flags = 0
    tag   = "issue"
    value = "amazontrust.com"
  }
  settings = {}
}

resource "cloudflare_dns_record" "cloverleaftrack_com_caa_apex_3" {
  name    = "cloverleaftrack.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CAA"
  zone_id = data.cloudflare_zone.cloverleaftrack_com.id
  data = {
    flags = 0
    tag   = "issue"
    value = "awstrust.com"
  }
  settings = {}
}

resource "cloudflare_dns_record" "cloverleaftrack_com_caa_apex_4" {
  name    = "cloverleaftrack.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CAA"
  zone_id = data.cloudflare_zone.cloverleaftrack_com.id
  data = {
    flags = 0
    tag   = "issue"
    value = "amazon.com"
  }
  settings = {}
}

resource "cloudflare_dns_record" "cloverleaftrack_com_cname_c43d4ae72168ccbe4814f7b4f297d39a" {
  content = "_790ad146ed3b701f7173f2438271bd25.vtqfhvjlcp.acm-validations.aws"
  name    = "_c43d4ae72168ccbe4814f7b4f297d39a.cloverleaftrack.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.cloverleaftrack_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "cloverleaftrack_com_cname_apex" {
  content = "d1agn4g5pghhiu.cloudfront.net"
  name    = "cloverleaftrack.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.cloverleaftrack_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "cloverleaftrack_com_cname_www" {
  content = "cloverleaftrack.com"
  name    = "www.cloverleaftrack.com"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.cloverleaftrack_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "cloverleaftrack_com_mx_apex" {
  content  = "route3.mx.cloudflare.net"
  name     = "cloverleaftrack.com"
  priority = 50
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "MX"
  zone_id  = data.cloudflare_zone.cloverleaftrack_com.id
  settings = {}
}

resource "cloudflare_dns_record" "cloverleaftrack_com_mx_apex_2" {
  content  = "route2.mx.cloudflare.net"
  name     = "cloverleaftrack.com"
  priority = 55
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "MX"
  zone_id  = data.cloudflare_zone.cloverleaftrack_com.id
  settings = {}
}

resource "cloudflare_dns_record" "cloverleaftrack_com_mx_apex_3" {
  content  = "route1.mx.cloudflare.net"
  name     = "cloverleaftrack.com"
  priority = 44
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "MX"
  zone_id  = data.cloudflare_zone.cloverleaftrack_com.id
  settings = {}
}

resource "cloudflare_dns_record" "cloverleaftrack_com_txt_cf2024_1_domainkey" {
  content  = "\"v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiweykoi+o48IOGuP7GR3X0MOExCUDY/BCRHoWBnh3rChl7WhdyCxW3jgq1daEjPPqoi7sJvdg5hEQVsgVRQP4DcnQDVjGMbASQtrY4WmB1VebF+RPJB2ECPsEDTpeiI5ZyUAwJaVX7r6bznU67g7LvFq35yIo4sdlmtZGV+i0H4cpYH9+3JJ78k\" \"m4KXwaf9xUJCWF6nxeD+qG6Fyruw1Qlbds2r85U9dkNDVAS3gioCvELryh1TxKGiVTkg4wqHTyHfWsp7KD3WQHYJn0RyfJJu6YEmL77zonn7p2SRMvTMP3ZEXibnC9gz3nnhR6wcYL8Q7zXypKTMD58bTixDSJwIDAQAB\""
  name     = "cf2024-1._domainkey.cloverleaftrack.com"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.cloverleaftrack_com.id
  settings = {}
}

resource "cloudflare_dns_record" "cloverleaftrack_com_txt_apex" {
  content  = "v=spf1 include:_spf.mx.cloudflare.net ~all"
  name     = "cloverleaftrack.com"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.cloverleaftrack_com.id
  settings = {}
}

resource "cloudflare_dns_record" "cloverleaftrack_com_txt_apex_2" {
  content  = "google-site-verification=yzBJz2SLYPmhS2q7_3y11mmwoXpfpeLfHIZY10lkEOI"
  name     = "cloverleaftrack.com"
  proxied  = false
  tags     = []
  ttl      = 3600
  type     = "TXT"
  zone_id  = data.cloudflare_zone.cloverleaftrack_com.id
  settings = {}
}

resource "cloudflare_dns_record" "cloverleaftrack_com_txt_dmarc" {
  content  = "v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s; rua=mailto:6a4c3d86860b4084adb5f2690b4c9408@dmarc-reports.cloudflare.net"
  name     = "_dmarc.cloverleaftrack.com"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.cloverleaftrack_com.id
  settings = {}
}

resource "cloudflare_dns_record" "cloverleaftrack_com_txt_wildcard_domainkey" {
  content  = "v=DKIM1; p="
  name     = "*._domainkey.cloverleaftrack.com"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.cloverleaftrack_com.id
  settings = {}
}
