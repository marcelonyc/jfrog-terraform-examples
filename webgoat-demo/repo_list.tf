locals { 
  csv_data  = file("${path.module}/repos.csv") 
  orgs_list = csvdecode(local.csv_data) 
} 