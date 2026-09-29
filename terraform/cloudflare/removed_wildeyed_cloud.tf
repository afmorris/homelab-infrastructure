# wildeyed.cloud is no longer used (internal names now live on
# morriscloud.com via UniFi CNAMEs + Nginx Proxy Manager). Stop managing its
# records WITHOUT deleting them; they go away when the domain lapses
# (auto-renew is off). Safe to delete this file after the next apply.

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_argocd

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_auth

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_awx

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_backup

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_books

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_code

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_ctf

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_dns

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_docs

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_download

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_gitlab

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_movies

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_mssql

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_next

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_notifiarr

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_photos

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_portainer

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_proxmox

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_racktables

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_request

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_truenas

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_cname_tv

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_mx_apex

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_mx_apex_2

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_mx_apex_3

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_txt_cf2024_1_domainkey

  lifecycle {
    destroy = false
  }
}

removed {
  from = cloudflare_dns_record.wildeyed_cloud_txt_apex

  lifecycle {
    destroy = false
  }
}
