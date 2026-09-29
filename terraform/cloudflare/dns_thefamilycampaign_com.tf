# DNS records for thefamilycampaign.com.
# Generated from the live zone by ./bootstrap.sh (cf-terraforming), then
# hand-maintained. Edit records here, not in the Cloudflare dashboard.

data "cloudflare_zone" "thefamilycampaign_com" {
  filter = {
    name = "thefamilycampaign.com"
  }
}

resource "cloudflare_dns_record" "thefamilycampaign_com_cname_apex" {
  content = "thefamilycampaign.pages.dev"
  name    = "thefamilycampaign.com"
  proxied = true
  tags    = []
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.thefamilycampaign_com.id
  settings = {
    flatten_cname = false
  }
}
