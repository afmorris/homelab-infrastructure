# DNS records for tonymorris.io.
# Generated from the live zone by ./bootstrap.sh (cf-terraforming), then
# hand-maintained. Edit records here, not in the Cloudflare dashboard.

data "cloudflare_zone" "tonymorris_io" {
  filter = {
    name = "tonymorris.io"
  }
}

resource "cloudflare_dns_record" "tonymorris_io_cname_blog" {
  content = "afmorris.gitlab.io"
  name    = "blog.tonymorris.io"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.tonymorris_io.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "tonymorris_io_cname_apex" {
  content = "afmorris.gitlab.io"
  name    = "tonymorris.io"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.tonymorris_io.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "tonymorris_io_cname_www" {
  content = "tonymorris.io"
  name    = "www.tonymorris.io"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.tonymorris_io.id
  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_dns_record" "tonymorris_io_ds_apex" {
  name    = "tonymorris.io"
  proxied = false
  tags    = []
  ttl     = 1
  type    = "DS"
  zone_id = data.cloudflare_zone.tonymorris_io.id
  data = {
    algorithm   = 13
    digest      = "812AE2B771ED807F4112538BCFCF8A219BBCE6BEDA82AC63208931A7A56CD017"
    digest_type = 2
    key_tag     = 2371
  }
  settings = {}
}

resource "cloudflare_dns_record" "tonymorris_io_mx_apex" {
  content  = "mailsec.protonmail.ch"
  name     = "tonymorris.io"
  priority = 20
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "MX"
  zone_id  = data.cloudflare_zone.tonymorris_io.id
  settings = {}
}

resource "cloudflare_dns_record" "tonymorris_io_mx_apex_2" {
  content  = "mail.protonmail.ch"
  name     = "tonymorris.io"
  priority = 10
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "MX"
  zone_id  = data.cloudflare_zone.tonymorris_io.id
  settings = {}
}

resource "cloudflare_dns_record" "tonymorris_io_txt_cf2024_1_domainkey" {
  content  = "\"v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiweykoi+o48IOGuP7GR3X0MOExCUDY/BCRHoWBnh3rChl7WhdyCxW3jgq1daEjPPqoi7sJvdg5hEQVsgVRQP4DcnQDVjGMbASQtrY4WmB1VebF+RPJB2ECPsEDTpeiI5ZyUAwJaVX7r6bznU67g7LvFq35yIo4sdlmtZGV+i0H4cpYH9+3JJ78k\" \"m4KXwaf9xUJCWF6nxeD+qG6Fyruw1Qlbds2r85U9dkNDVAS3gioCvELryh1TxKGiVTkg4wqHTyHfWsp7KD3WQHYJn0RyfJJu6YEmL77zonn7p2SRMvTMP3ZEXibnC9gz3nnhR6wcYL8Q7zXypKTMD58bTixDSJwIDAQAB\""
  name     = "cf2024-1._domainkey.tonymorris.io"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.tonymorris_io.id
  settings = {}
}

resource "cloudflare_dns_record" "tonymorris_io_txt_gitlab_pages_verification_code_blog" {
  content  = "gitlab-pages-verification-code=42dbc6f8b01529c9c5724acd8c200528"
  name     = "_gitlab-pages-verification-code.blog.tonymorris.io"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.tonymorris_io.id
  settings = {}
}

resource "cloudflare_dns_record" "tonymorris_io_txt_gitlab_pages_verification_code" {
  content  = "gitlab-pages-verification-code=b4af6d2955dab00e02ced9caca583d53"
  name     = "_gitlab-pages-verification-code.tonymorris.io"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.tonymorris_io.id
  settings = {}
}

resource "cloudflare_dns_record" "tonymorris_io_txt_keybase" {
  content  = "keybase-site-verification=7K03-GkihLuWi4ZLrQ0LOSfNK6IqbXFii0I4ZNiDDQw"
  name     = "_keybase.tonymorris.io"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.tonymorris_io.id
  settings = {}
}

resource "cloudflare_dns_record" "tonymorris_io_txt_krs_domainkey" {
  content  = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDKSPtJ8OAOxa8R8tyI+RLnoCjNlgHcn2ORL8atXDqi0nTSiCiPbMhJ5aV/Uw8BlL9FLP9rbxDCcRX6Ck0KJ6cjyFvbMYitr3fQtXsuzeykGRZjThRKNu7zMo0tr/d4FvDNxho1KLOEVrysrx2hDHbSST/Y9i/RtasDmgA9QnsX4QIDAQAB"
  name     = "krs._domainkey.tonymorris.io"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.tonymorris_io.id
  settings = {}
}

resource "cloudflare_dns_record" "tonymorris_io_txt_protonmail_domainkey" {
  content  = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC+VaQmFgXNwkelsBexsUEjVaja2zPPJOEKgG60FrCH+XMDvkZSV1n/KDvcnbDaZ6EpgBheOKSY7BpChqdza+P5ReinMCHXiUoCV7z1ppb3LJBT8M1JT4ayrIO7QTkc+rUbwJwC8wLbMJ7pKiF11a38IC/Q7s8/lybnp7SB6NeWuwIDAQAB"
  name     = "protonmail._domainkey.tonymorris.io"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.tonymorris_io.id
  settings = {}
}

resource "cloudflare_dns_record" "tonymorris_io_txt_apex" {
  content  = "v=spf1 include:_spf.protonmail.ch mx ~all"
  name     = "tonymorris.io"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.tonymorris_io.id
  settings = {}
}

resource "cloudflare_dns_record" "tonymorris_io_txt_apex_2" {
  content  = "protonmail-verification=e67376e08526654acaaae0eca56cb710a0481b93"
  name     = "tonymorris.io"
  proxied  = false
  tags     = []
  ttl      = 1
  type     = "TXT"
  zone_id  = data.cloudflare_zone.tonymorris_io.id
  settings = {}
}
