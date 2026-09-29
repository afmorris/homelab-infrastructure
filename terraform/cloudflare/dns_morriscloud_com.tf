# DNS records for morriscloud.com.
# Generated from the live zone by ./bootstrap.sh (cf-terraforming), then
# hand-maintained. Edit records here, not in the Cloudflare dashboard.

data "cloudflare_zone" "morriscloud_com" {
  filter = {
    name = "morriscloud.com"
  }
}

resource "cloudflare_dns_record" "morriscloud_com_caa_tony" {
  comment = "AWS CAA"
  name    = "tony.morriscloud.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CAA"
  zone_id = data.cloudflare_zone.morriscloud_com.id
  data = {
    flags = 0
    tag   = "issue"
    value = "amazonaws.com"
  }
  settings = {}
}

resource "cloudflare_dns_record" "morriscloud_com_caa_tony_2" {
  comment = "AWS CAA"
  name    = "tony.morriscloud.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CAA"
  zone_id = data.cloudflare_zone.morriscloud_com.id
  data = {
    flags = 0
    tag   = "issue"
    value = "awstrust.com"
  }
  settings = {}
}

resource "cloudflare_dns_record" "morriscloud_com_caa_tony_3" {
  comment = "AWS CAA"
  name    = "tony.morriscloud.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CAA"
  zone_id = data.cloudflare_zone.morriscloud_com.id
  data = {
    flags = 0
    tag   = "issue"
    value = "amazontrust.com"
  }
  settings = {}
}

resource "cloudflare_dns_record" "morriscloud_com_caa_tony_4" {
  comment = "AWS CAA"
  name    = "tony.morriscloud.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CAA"
  zone_id = data.cloudflare_zone.morriscloud_com.id
  data = {
    flags = 0
    tag   = "issue"
    value = "amazon.com"
  }
  settings = {}
}

resource "cloudflare_dns_record" "morriscloud_com_cname_6be1a18dda3a3d6ebe1db2be6dc33ad5_tony" {
  comment = "AWS ACM Domain Validation"
  content = "_d5257b0e659c52c5fc2516c58167c54b.xlfgrmvvlj.acm-validations.aws"
  name    = "_6be1a18dda3a3d6ebe1db2be6dc33ad5.tony.morriscloud.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.morriscloud_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "morriscloud_com_cname_aws_pulumi_static" {
  content = "aws-pulumi-static.morriscloud.com.s3-website-us-east-1.amazonaws.com"
  name    = "aws-pulumi-static.morriscloud.com"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.morriscloud_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "morriscloud_com_cname_aws_terraform_static" {
  content = "aws-terraform-static.morriscloud.com.s3-website.us-east-2.amazonaws.com"
  name    = "aws-terraform-static.morriscloud.com"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.morriscloud_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "morriscloud_com_cname_blog" {
  content = "tony-talks-tech.ghost.io"
  name    = "blog.morriscloud.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.morriscloud_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "morriscloud_com_cname_protonmail2_domainkey" {
  comment = "ProtonMail DKIM #2"
  content = "protonmail2.domainkey.dxgieoj6bjsphm3cxpp6uchpuzxfmoeyyp5jezxich3t4edewzekq.domains.proton.ch"
  name    = "protonmail2._domainkey.morriscloud.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.morriscloud_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "morriscloud_com_cname_protonmail3_domainkey" {
  comment = "ProtonMail DKIM #3"
  content = "protonmail3.domainkey.dxgieoj6bjsphm3cxpp6uchpuzxfmoeyyp5jezxich3t4edewzekq.domains.proton.ch"
  name    = "protonmail3._domainkey.morriscloud.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.morriscloud_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "morriscloud_com_cname_protonmail_domainkey" {
  comment = "ProtonMail DKIM #1"
  content = "protonmail.domainkey.dxgieoj6bjsphm3cxpp6uchpuzxfmoeyyp5jezxich3t4edewzekq.domains.proton.ch"
  name    = "protonmail._domainkey.morriscloud.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.morriscloud_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "morriscloud_com_cname_til" {
  content = "afmorris.github.io"
  name    = "til.morriscloud.com"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.morriscloud_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "morriscloud_com_cname_tony" {
  comment = "AWS CloudFront"
  content = "dtxu7zd5zeygj.cloudfront.net"
  name    = "tony.morriscloud.com"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.morriscloud_com.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "morriscloud_com_mx_apex" {
  comment  = "ProtonMail MX #1"
  content  = "mail.protonmail.ch"
  name     = "morriscloud.com"
  priority = 10
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "MX"
  zone_id  = data.cloudflare_zone.morriscloud_com.id
  settings = {}
}

resource "cloudflare_dns_record" "morriscloud_com_mx_apex_2" {
  comment  = "ProtonMail MX #2"
  content  = "mailsec.protonmail.ch"
  name     = "morriscloud.com"
  priority = 20
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "MX"
  zone_id  = data.cloudflare_zone.morriscloud_com.id
  settings = {}
}

resource "cloudflare_dns_record" "morriscloud_com_txt_atproto_tony" {
  comment  = "BlueSky Domain Verification"
  content  = "\"did=did:plc:t7cz5iikexxr4zh254ju2n7o\""
  name     = "_atproto.tony.morriscloud.com"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.morriscloud_com.id
  settings = {}
}

resource "cloudflare_dns_record" "morriscloud_com_txt_dmarc" {
  comment  = "ProtonMail DMARC"
  content  = "\"v=DMARC1; p=quarantine\""
  name     = "_dmarc.morriscloud.com"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.morriscloud_com.id
  settings = {}
}

resource "cloudflare_dns_record" "morriscloud_com_txt_github_challenge_morriscloud" {
  content  = "c7e290df87"
  name     = "_github-challenge-morriscloud.morriscloud.com"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.morriscloud_com.id
  settings = {}
}

resource "cloudflare_dns_record" "morriscloud_com_txt_apex" {
  comment  = "ProtonMail SPF"
  content  = "\"v=spf1 include:_spf.protonmail.ch ~all\""
  name     = "morriscloud.com"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.morriscloud_com.id
  settings = {}
}

resource "cloudflare_dns_record" "morriscloud_com_txt_apex_2" {
  content  = "\"protonmail-verification=dd343f7239bdf637c36bd24289f101dd5bf179f9\""
  name     = "morriscloud.com"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.morriscloud_com.id
  settings = {}
}
