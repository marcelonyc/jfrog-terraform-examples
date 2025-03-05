locals { 
  csv_data  = file("${path.module}/orgs_config.csv") 
  orgs_list = csvdecode(local.csv_data) 
} 