locals { 
  csv_data  = file(var.REPO_LIST_FILE) 
  prefixs_list = csvdecode(local.csv_data) 
} 